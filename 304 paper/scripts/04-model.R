#### Preamble ####
# Purpose: Construct model
# Author: Xinrui Xie
# Date: 20 November 2024
# Contact: xinrui.xie@mail.utoronto.ca
# Pre-requisites: The `rstanarm`  package must be installed

# Load the library
library(rstanarm)
library(arrow)

# Load your data (replace 'your_data.csv' with the actual file name)
data <- read_parquet("data/analysis_data/cleaned_deaths_causes.parquet")

# Convert Cause to a factor if it's not already
data$cause <- as.factor(data$cause)
data$total_deaths <- as.numeric(data$total_deaths)
data$calendar_year <- as.numeric(data$calendar_year)

# Define the Bayesian regression model
# We use a Poisson family since total deaths are count data
model <- stan_glm(
  formula = total_deaths ~ calendar_year + cause, 
  family = poisson(link = "log"),         # Poisson regression with log link
  data = data,                            # Dataset
  prior = normal(location = 0, scale = 10), # Prior for coefficients
  prior_intercept = normal(location = 0, scale = 10), # Prior for intercept
  chains = 4,                             # Number of chains
  iter = 2000,                            # Number of iterations
  seed = 123                              # For reproducibility
)

# Generate new data for predictions across years and causes
new_data <- expand.grid(
  calendar_year = seq(min(data$calendar_year), max(data$calendar_year), by = 1),
  cause = levels(data$cause)  # Use all levels of 'cause'
)

# Predict the number of deaths for the new data
new_data$predicted_deaths <- exp(predict(model, newdata = new_data, type = "link"))

# Visualize the trend using ggplot2
library(ggplot2)

ggplot(new_data, aes(x = calendar_year, y = predicted_deaths, color = cause)) +
  geom_line(size = 1) +
  labs(
    title = "Predicted Trends of Total Deaths by Cause Over Time",
    x = "Year",
    y = "Predicted Number of Deaths",
    color = "Cause"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )

# Create a line plot for the original data
ggplot(data, aes(x = calendar_year, y = total_deaths, color = cause)) +
  geom_line(size = 1, alpha = 0.8) +  # Line plot for trends
  labs(
    title = "Trends in Total Deaths by Cause Over Time",
    x = "Year",
    y = "Total Number of Deaths",
    color = "Cause"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )

#### Save Model ####
saveRDS(
  model,
  file = "models/model.rds"
)
