#### Preamble ####
# Purpose: download data
# Author: Xinrui Xie
# Date: 20 November 2024
# Contact: xinrui.xie@mail.utoronto.ca
# Pre-requisites: The `tidyverse` and 'janitor'  and 'dplyr' package must be installed

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Download and Save Data ####
url <- "https://open.alberta.ca/dataset/03339dc5-fb51-4552-97c7-853688fc428d/resource/3e241965-fee3-400e-9652-07cfbf0c0bda/download/deaths-leading-causes.csv"
destfile <- "data/raw_data/deaths_causes.csv"
download.file(url, destfile)


