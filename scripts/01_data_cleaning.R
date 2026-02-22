# 01_data_cleaning.R
# Demography & Service Structure Project

library(tidyverse)

# Inspect structure

df_panel <- read.csv("data/raw/panel_data.csv")
df_dict  <- read.csv("data/raw/indicator_dictionary.csv")

head(df_panel)
head(df_dict)

# check the 'unique category, find issue then solve.

# Inspect the Problem Rows
df_panel %>%
filter(Category == "Category" | Category == "Category ")

df_panel <- df_panel %>%
  mutate(
    Category = str_trim(Category)  # remove leading/trailing spaces
  )

# Remove the False Header row
df_panel <- df_panel %>%
  filter(Category != "Category")

# Verify clean category
unique(df_panel$Category)

# Pivot Longer (Wide → Long)
df_long <- df_panel %>%
  pivot_longer(
    cols = starts_with("X"),
    names_to = "Year",
    values_to = "Value"
  ) %>%
  mutate(
    Year = as.integer(str_remove(Year, "X")),
    Value = as.numeric(Value)
  )

# check structure
str(df_long)
head(df_long)

# rows should be 31 provinces × 14 indicators × 9 years = 3906
nrow(df_long)


# Save Clean Long Dataset(Always save intermediate clean state.)

write_csv(df_long, 
          "data/processed/panel_long_clean.csv")