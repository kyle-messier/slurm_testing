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


###############################      GPU SETUP     #############################
# Ensure all allocated GPUs are visible
export CUDA_VISIBLE_DEVICES=$(echo $(seq 0 $((SLURM_GPUS_ON_NODE-1))) | tr ' ' ',')

#############################        MODELS        #############################
# Set environmental variable to indicate CPU-enabled model fitting targets.

# Fit CPU-enabled base learner models via container_models.sif.
Rscript --no-save --no-restore targets_run.R
