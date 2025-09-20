library(targets)
library(tidyverse)
library(tidymodels)
library(bonsai)
library(qs2) # For efficient storage of data objects.
# Set target options:
tar_option_set(
  packages = c("targets", "tidyverse", "tidymodels", "bonsai", "qs2"),
  error = "continue"
)

targets::tar_config_set(store = "/opt/_targets")

list(
  # Add your targets here
)
