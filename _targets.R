library(targets)
library(tidyverse)
library(tidymodels)
library(qs2)
library(crew)
library(crew.cluster)


controller_grid <- crew.cluster::crew_controller_slurm(
  name = "controller_grid",
  workers = 10,
  crashes_max = 5L,
  seconds_idle = 30,
  options_cluster = crew.cluster::crew_options_slurm(
    verbose = TRUE,
    memory_gigabytes_required = 10,
    cpus_per_task = 1,
    time_minutes = 5
  ),
  options_metrics = crew::crew_options_metrics(
    path = "pipeline/",
    seconds_interval = 1
  ),
  garbage_collection = TRUE,
  reset_globals = TRUE,
  tasks_max = 1,
  seconds_exit = 60
)

beethoven_packages <- c(
  "amadeus",
  "targets",
  "tarchetypes",
  # "sqltargets",
  "chopin",
  "dplyr",
  "tidyverse",
  "data.table",
  "sf",
  "crew",
  "crew.cluster",
  "lubridate",
  "mirai",
  "qs2",
  "torch",
  "parsnip",
  "bonsai",
  "dials",
  "lightgbm",
  "glmnet",
  "finetune",
  "spatialsample",
  "tidymodels",
  "brulee",
  "workflows",
  "autometric"
)

targets::tar_option_set(
  packages = beethoven_packages,
  repository = "local",
  error = "continue",
  memory = "auto",
  format = "qs",
  storage = "worker",
  deployment = "worker",
  seed = 202401L,
  controller = crew::crew_controller_group(
    controller_grid
  ),
  resources = targets::tar_resources(
    crew = targets::tar_resources_crew(controller = "controller_grid")
  ),
  retrieval = "worker"
)

targets::tar_source("target_slurm_test.R")
targets::tar_source()

targets::tar_config_set(store = "targets")


list(
  target_slurm_test
)
