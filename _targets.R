library(targets)
library(tidyverse)
library(crew)
library(crew.cluster)

scriptlines_apptainer <- "apptainer"
scriptlines_basedir <- Sys.getenv("BASEDIR")
scriptlines_container <- "slurm_testing.sif"

path1 <- val <- Sys.getenv("PATH1")
path2 <- val <- Sys.getenv("PATH2")

scriptlines_grid <- glue::glue(
  "#SBATCH --job-name=grid \
  #SBATCH --error=slurm/grid_%j.out \
  unset R_LIBS_USER; \
  unset R_LIBS_SITE; \
  unset LD_LIBRARY_PATH; \
  {scriptlines_apptainer} exec ",
  "--cleanenv ",
  "  --env R_LIBS_USER=/opt/Rlibs ",
  "--no-home ",
  "--no-mount {path1} ",
  "--no-mount {path2} ",
  "--bind {scriptlines_basedir}:/mnt ",
  "--bind /run/munge:/run/munge ",
  "--bind /ddn/gs1/tools/slurm/etc/slurm:/etc/slurm ",
  "--bind {scriptlines_basedir}/_targets:/opt/_targets ",
  "{scriptlines_container} \\"
)


controller_grid <- crew.cluster::crew_controller_slurm(
  name = "controller_grid",
  workers = 50,
  crashes_max = 5L,
  tasks_max = 1,
  options_cluster = crew.cluster::crew_options_slurm(
    verbose = TRUE,
    script_lines = scriptlines_grid,
    n_tasks = 1,
    cpus_per_task = 1,
    partition = "geo",
    memory_gigabytes_required = 10
  ),
  options_metrics = crew::crew_options_metrics(
    path = "pipeline/"
  ),
  garbage_collection = TRUE
)

beethoven_packages <- c(
  "amadeus",
  "targets",
  "tarchetypes",
  "data.table",
  # "sqltargets",
  "chopin",
  "dplyr",
  "tidyverse",
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
  "h3",
  "h3r",
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

targets::tar_config_set(store = "_targets")

list(
  target_slurm_test
)
