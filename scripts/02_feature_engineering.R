
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



