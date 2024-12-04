#### Preamble ####
# Purpose: Simulates a dataset of Number of Deaths Caused by 30 Most Common Causes.
# Author: Xinrui Xie
# Date: 20 November 2024
# Contact: xinrui.xie@mail.utoronto.ca
# Pre-requisites: The `tidyverse` and 'janitor'  and 'dplyr' package must be installed

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)

#### Simulate data ####
# Set seed for reproducibility
set.seed(1234)

# Simulated data generation
simulated_data <- tibble(
  Caldendar.Year = sample(2001:2022, 663, replace = TRUE),
  Cause = sample(c("All other forms of chronic ischemic heart disease", "Acute myocardial infarction",
                   "Malignant neoplasms of trachea, bronchus and lung",
                   "Diabetes mellitus"), 663, replace = TRUE),
  Ranking = sample(1:30, 663, replace = TRUE),
  Total.Deaths = sample(100:5000, 663, replace = TRUE)
)

head(simulated_data)

#### Save data ####
write_csv(simulated_data, "data/simulated_data/simulated_data.csv")

