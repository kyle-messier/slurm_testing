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

export PATH1="/ddn/gs1/home/messierkp/R/x86_64-pc-linux-gnu-library/4.3"
export PATH2="/ddn/gs1/biotools/R/lib64/R/library"
export BASEDIR=$PWD

R_LIBS_USER=""
R_LIBS_SITE=""
unset R_LIBS_USER
unset R_LIBS_SITE
unset LD_LIBRARY_PATH


Rscript targets_run.R