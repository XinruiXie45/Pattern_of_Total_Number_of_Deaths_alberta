#### Preamble ####
# Purpose: Simulates a dataset of Number of Deaths Caused by 30 Most Common Causes.
# Author: Xinrui Xie
# Date: 14 December 2024
# Contact: xinrui.xie@mail.utoronto.ca
# Pre-requisites: The `tidyverse` and 'janitor'  and 'dplyr' package must be installed

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)

#### Simulate data ####
# Set seed for reproducibility
set.seed(1234)

# Simulate data with relationships
simulated_data <- tibble(
  Calendar.Year = sample(2001:2022, 663, replace = TRUE),
  Cause = sample(c("All other forms of chronic ischemic heart disease", 
                   "Acute myocardial infarction",
                   "Malignant neoplasms of trachea, bronchus and lung",
                   "Diabetes mellitus"), 663, replace = TRUE)
) %>%
  mutate(
    # Create ranking inversely proportional to deaths, with some randomness
    Total.Deaths = case_when(
      Cause == "All other forms of chronic ischemic heart disease" ~ rnorm(n(), mean = 4000, sd = 500),
      Cause == "Acute myocardial infarction" ~ rnorm(n(), mean = 3000, sd = 400),
      Cause == "Malignant neoplasms of trachea, bronchus and lung" ~ rnorm(n(), mean = 2500, sd = 300),
      Cause == "Diabetes mellitus" ~ rnorm(n(), mean = 1500, sd = 200),
      TRUE ~ rnorm(n(), mean = 2000, sd = 500)
    ) %>% round(),
    Total.Deaths = pmax(100, Total.Deaths),  # Ensure no deaths are below 100
    Ranking = case_when(
      Total.Deaths > 3500 ~ sample(1:5, n(), replace = TRUE),  # Higher deaths, higher priority
      Total.Deaths > 2000 ~ sample(6:15, n(), replace = TRUE),
      TRUE ~ sample(16:30, n(), replace = TRUE)
    )
  )

# Add temporal trends
simulated_data <- simulated_data %>%
  mutate(
    # Add a small yearly trend for specific causes
    Total.Deaths = Total.Deaths + ifelse(Cause == "Diabetes mellitus", (Calendar.Year - 2000) * 5, 0),
    Total.Deaths = Total.Deaths + ifelse(Cause == "Malignant neoplasms of trachea, bronchus and lung", -(Calendar.Year - 2000) * 3, 0)
  )

head(simulated_data)

#### Save data ####
write_csv(simulated_data, "data/simulated_data/simulated_data.csv")

