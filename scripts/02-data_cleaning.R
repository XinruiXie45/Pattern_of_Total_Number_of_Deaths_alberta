#### Preamble ####
# Purpose: download data
# Author: Xinrui Xie
# Date: 14 December 2024
# Contact: xinrui.xie@mail.utoronto.ca
# Pre-requisites: The `tidyverse` and 'janitor'  and 'dplyr' package must be installed


#### Workspace setup ####
library(arrow)
library(tidyverse)
library(janitor)
library(readr)
library(stringr)
library(forcats)

#### Clean Data ####
data <- read_csv("data/raw_data/deaths_causes.csv")

# Remove the first row and use the second row as headers
cleaned_data <- data[-1, ]
colnames(cleaned_data) <- data[2, ]
cleaned_data <- cleaned_data[-1, ]

# Rename columns for better clarity
colnames(cleaned_data) <- c("Calendar Year", "Cause", "Ranking", "Total Deaths")

# Reset row indices
rownames(cleaned_data) <- NULL

# Display the cleaned data
head(cleaned_data)

# Clean column names
cleaned_data <- clean_names(cleaned_data)

# Remove rows with NA in calendar_year
cleaned_data <- cleaned_data[!is.na(cleaned_data$calendar_year), ]

# Convert Cause to a factor if it's not already
cleaned_data$cause <- as.factor(cleaned_data$cause)
cleaned_data$total_deaths <- as.numeric(cleaned_data$total_deaths)
cleaned_data$calendar_year <- as.numeric(cleaned_data$calendar_year)

#### Save Data ####
write_csv(cleaned_data, "data/analysis_data/cleaned_deaths_causes.csv")
write_parquet(cleaned_data, "data/analysis_data/cleaned_deaths_causes.parquet")

