library(targets)
library(tidyverse)
# library(sf)
library(crew)
library(crew.cluster)

# SBATCH --signal=TERM@10 \
# setwd("/mnt")
scriptlines_grid <- glue::glue(
  "#SBATCH --job-name=grid \
  #SBATCH --partition=geo,highmem,normal \
  #SBATCH --cpus-per-task=1 \
  #SBATCH --mem=10G \
  #SBATCH --error=slurm/grid_%j.out \
  #SBATCH --ntasks=1 \
  srun \
  --exclusive \
  apptainer exec ",
  "--cleanenv ",
  "--env R_LIBS='/opt/Rlibs' ",
  "--env R_LIBS_USER='/opt/Rlibs' ",
  "--env R_LIBS_SITE='/opt/Rlibs' ",
  "--bind /ddn/gs1/home/messierkp/slurm_testing:/mnt ",
  "--bind /run/munge:/run/munge ",
  "--bind /ddn/gs1/tools/slurm/etc/slurm:/ddn/gs1/tools/slurm/etc/slurm ",
  "--bind /ddn/gs1/home/messierkp/slurm_testing/_targets:/opt/_targets ",
  "slurm_testing.sif \\"
)

controller_grid <- crew.cluster::crew_controller_slurm(
  name = "controller_grid",
  workers = 10L,
  options_cluster = crew.cluster::crew_options_slurm(
    verbose = TRUE,
    script_lines = scriptlines_grid,
    time_minutes = 5
  ),
  options_metrics = crew::crew_options_metrics(
    path = "pipeline/",
    seconds_interval = 1
  ),
  garbage_collection = TRUE,
  tasks_max = Inf
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
  "h3",
  "h3r",
  "autometric"
)

targets::tar_option_set(
  tidy_eval = TRUE,
  packages = beethoven_packages,
  repository = "local",
  library = "/opt/Rlibs",
  error = "continue",
  backoff = tar_backoff(min = 5, max = 300),
  memory = "auto",
  format = "qs",
  storage = "worker",
  retrieval = "worker",
  deployment = "worker",
  seed = 202401L,
  controller = crew::crew_controller_group(
    controller_grid
  ),
  resources = targets::tar_resources(
    crew = targets::tar_resources_crew(controller = "controller_grid")
  )
)

targets::tar_source("target_slurm_test.R")
targets::tar_source()
# targets::tar_source("target_slurm_test.R")
# targets::tar_source()
targets::tar_config_set(store = "/opt/_targets")

list(
  target_slurm_test
)
