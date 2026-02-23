
df_long <- read_csv('data/processed/panel_long_clean.csv')

# summary df_long
summary(df_long$Value)

# Diagnose NA pattern
df_long %>%
  filter(is.na(Value)) %>%
  count(Category)


#   Category     n
# <chr>    <int>
#   1 CDR         31
# 2 GDR         31
# 3 IT_value     1
# 4 ODR         31
# 5 elderpop    31


df_long %>%
  filter(is.na(Value)) %>%
  count(Year)


# Year     n
#   <dbl> <int>
# 1  2016     1
# 2  2020   124


# Demographic survey indicators were unavailable for 2020; #
# therefore, 2020 is excluded from demographic alignment analysis.#

df_wide <- df_long %>%
  pivot_wider(
    names_from = Category,
    values_from = Value
  )

glimpse(df_wide)
str(df_wide)

# Verify 2020 structure
df_wide %>% 
  filter(Year == 2020) %>%
  summarise(
    missing_CDR = sum(is.na(CDR)),
    missing_ODR = sum(is.na(ODR)),
    missing_GDR = sum(is.na(GDR)),
    missing_elder = sum(is.na(elderpop))
    )

#  Feature Engineering (Safe With NA)
## compute necessary cols
df_wide <- df_wide %>%
  mutate(
    IT_pc = IT_value / totpop,
    retail_pc = retail_value / totpop,
    bed_per_elderly_1000 =(medicalbed / elderpop) * 1000
  )

# 	Larger edu_pri = better teacher availability
# Interpretation becomes consistent with bed_per_elderly_1000
df_wide <- df_wide %>%
  mutate(
    edu_pri = 1 / STR_pri,
    edu_jun = 1 / STR_jun,
    edu_sen = 1 / STR_sen
  )

# Check new variables
summary(df_wide$IT_pc)
summary(df_wide$bed_per_elderly_1000)



# Correlation Exploration

## Hypothesis:
###   1. Aging ↔ health supply
###   2. Marriage rate ↔ IT development
###   3. CDR ↔ STR
###   4. ODR ↔ bed_per_elderly


# Compute correlation matrix
cor_variable <- df_wide %>%
  select(
    IT_pc,
    retail_pc,
    bed_per_elderly_1000,
    edu_pri, edu_jun, edu_sen,
    birth_rate,
    marriagerate,
    CDR, ODR
  )

# For each pair of variables, use only the rows where both variables have a complete (non-missing) observation.
cor_matrix <- cor(cor_variable, use = "pairwise.complete.obs")

# print full numric matrix
print(round(cor_matrix,4))

# Extract notable correlations (|r| >= 0.50) 
cor_tidy <- as.data.frame(as.table(cor_matrix)) %>%
  rename(Variable_1 = Var1, Variable_2 = Var2, r = Freq) %>%
  filter(as.character(Variable_1) != as.character(Variable_2)) %>%
  filter(as.character(Variable_1) < as.character(Variable_2))

notable_correlations <- cor_tidy %>%
  filter(abs(r) >= 0.50) %>%
  arrange(desc(abs(r)))

print(notable_correlations)

# plot the matrix
library(corrplot)

pic_path <- "/Users/ez_us/Documents/demography_service_structure/output"
png(file.path(pic_path, "correlation_heatmap.png"), width = 9, height = 8, units = "in", res = 300)
corrplot(
  cor_matrix,
  method     = "color",
  type       = "full",
  order      = "hclust",
  tl.col     = "black",
  tl.srt     = 45,
  addCoef.col = "#F0F0F0",
  number.cex = 0.75,
  cl.cex     = 0.8,
  title      = "Correlation of Provincial Indicators",
  mar        = c(0, 0, 2, 0)
)

dev.off()


# Start to Fixed-Effect analysis

library(plm)


df_model <- df_wide %>%
  filter(!is.na(ODR))  # remove 2020

# Prepare panel data
pdata <- pdata.frame(df_model,
                     index = c("Region", "Year"))

# Model 1: Elderly Infrastructure Responsiveness
model_elder <- plm(
  bed_per_elderly_1000 ~ ODR,
  data = pdata,
  model = "within",
  effect = "twoways"
)

summary(model_elder)

# Model 2: Education Responsiveness
model_edu <- plm(
  edu_pri ~ CDR,
  data = pdata,
  model = "within",
  effect = "twoways"
)

summary(model_edu)

# Model 3: Modernazation & Marriage
model_marriage <- plm(
  marriagerate ~ IT_pc,
  data = pdata,
  model = "within",
  effect = "twoaways"
)

summary(model_marriage)

# Add plots according to the FE results

# 'method = "lm"' — fits a linear regression line through the data points. "lm" stands for linear model, so it draws a straight line that best fits the relationship between ODR (x) and hospital beds (y).
# 'se = TRUE' — displays the confidence interval (the shaded ribbon around the line). This ribbon represents uncertainty in the trend — wider ribbons mean less certainty, often because there are fewer data points or more spread in that region.

library(ggplot2)

ggplot(df_wide, aes(x = ODR, y = bed_per_elderly_1000)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Healthcare Capacity vs Aging Pressure",
    x = "Old Dependency Ratio (ODR)",
    y = "Hospital Beds per 1,000 Elderly"
  ) +
  theme_minimal()

# FE Coefficient Plot

library(broom)

tidy_model <- tidy(model_elder, conf.int = TRUE)
tidy_model$term <- "Old Dependency Ratio"

library(broom)
library(ggplot2)

tidy_model <- tidy(model_elder, conf.int = TRUE)
tidy_model$term <- "Old Dependency Ratio"

ggplot(tidy_model, aes(y = term, x = estimate)) +
  geom_point(size = 4, color = "#B91C1C") +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high),
                 height = 0.2,
                 color = "#B91C1C") +
  geom_vline(xintercept = 0,
             linetype = "dashed",
             color = "#6B7280") +
  labs(
    title = "Fixed-Effects Estimate: \nAging Pressure on Healthcare Supply",
    x = "Coefficient Estimate",
    y = ""
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.title = element_text(face = "bold"),
    axis.text.y = element_text(face = "bold")
  )

# Structural Quadrant Plot (High Value)

# compute Means
mean_ODR <- mean(df_wide$ODR, na.rm = TRUE)
mean_bed <- mean(df_wide$bed_per_elderly_1000, na.rm = TRUE)

# plot with quadrant lines
ggplot(df_wide, aes(x = ODR, y = bed_per_elderly_1000, color = retial_pc)) +
  geom_point(alpha = 0.6, size = 2) +
  scale_color_gradient(low = "#d73027", high = "#1a9850") +
  geom_vline(xintercept = mean_ODR, linetype = "dashed") +
  geom_hline(yintercept = mean_bed, linetype = "dashed") +
  labs(
    title = "Provincial Service Alignment Quadrants",
    x = "Old Dependency Ratio",
    y = "Beds per 1,000 Elderly"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) # place the title to center

# library(broom)
# library(dplyr)
# library(ggplot2)

# Tidy models
tidy_elder <- tidy(model_elder, conf.int = TRUE) %>%
  mutate(variable = "Healthcare (ODR → Beds)")

tidy_edu <- tidy(model_edu, conf.int = TRUE) %>%
  mutate(variable = "Education (CDR → Teacher Availability)")

tidy_marriage <- tidy(model_marriage, conf.int = TRUE) %>%
  mutate(variable = "Marriage (IT → Marriage Rate)")

combined <- bind_rows(tidy_elder, tidy_edu, tidy_marriage)

ggplot(combined, aes(y = variable, x = estimate)) +
  geom_point(size = 4, color = "#1E3A8A") +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high),
                 height = 0.2,
                 color = "#1E3A8A") +
  geom_vline(xintercept = 0,
             linetype = "dashed",
             color = "#6B7280") +
  labs(
    title = "Fixed-Effects Estimates Across Service Domains",
    x = "Coefficient Estimate",
    y = ""
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.title = element_text(face = "bold")
  )