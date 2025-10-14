#!/bin/bash

#SBATCH --job-name=dispatch
#SBATCH --mail-user=kyle.messier@nih.gov
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=geo
#SBATCH --ntasks=1
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --error=slurm/dispatch_%j.err
#SBATCH --output=slurm/dispatch_%j.out


apptainer exec \
  --bind $PWD:/mnt \
  --bind targets:/opt/_targets \
  --bind /run/munge:/run/munge \
  --bind /ddn/gs1/tools/slurm/etc/slurm:/ddn/gs1/tools/slurm/etc/slurm \
  slurm_testing.sif \
  /usr/local/lib/R/bin/Rscript --no-init-file /mnt/targets_run.R