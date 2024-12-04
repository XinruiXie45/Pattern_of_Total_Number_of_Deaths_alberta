#### Preamble ####
# Purpose: download data
# Author: Xinrui Xie
# Date: 20 November 2024
# Contact: xinrui.xie@mail.utoronto.ca
# Pre-requisites: The `tidyverse` and 'janitor'  and 'dplyr' package must be installed


#### Workspace setup ####
library(tidyverse)
library(arrow)

data <- read_csv("data/analysis_data/cleaned_deaths_causes.csv")

# Check for correct columns
if (!all(c("Calendar Year", "Cause", "Ranking", "Total Deaths") %in% names(data))) {
  stop("Data frame does not have the correct columns.")
}

# Check for correct types
if (!is.numeric(data$`Calendar Year`)) {
  stop("Calendar Year is not numeric.")
}
if (!is.character(data$Cause)) {
  stop("Cause is not character.")
}
if (!is.numeric(data$Ranking)) {
  stop("Ranking is not numeric.")
}
if (!is.numeric(data$`Total Deaths`)) {
  stop("Total Deaths is not numeric.")
}

# Check numeric variables for expected range
if (any(!is.na(data$`Calendar Year`) & 
        (data$`Calendar Year` < 2001) & 
        (data$`Calendar Year` > 2022))) {
  stop("Calendar Year contains wrong year.")
}
if (any(!is.na(data$Ranking) & 
        (data$Ranking < 0) & 
        (data$Ranking > 30))) {
  stop("Ranking contains wrong value.")
}
if (any(!is.na(data$`Total Deaths`) & 
        (data$`Total Deaths` < 0))) {
  stop("Total Deaths contains negative values.")
}

# Check for missing values
if (any(!complete.cases(data))) {
  stop("There are missing values in the data.")
}

print("All tests passed!")
