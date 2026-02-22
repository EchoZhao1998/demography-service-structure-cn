# 01_data_cleaning.R
# Demography & Service Structure Project

library(tidyverse)

# Inspect structure

df_panel <- read.csv("data/raw/panel_data.csv")
df_dict  <- read.csv("data/raw/indicator_dictionary.csv")

head(df_panel)
head(df_dict)
