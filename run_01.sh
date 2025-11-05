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

############################      CERTIFICATES      ############################
# Export CURL_CA_BUNDLE and SSL_CERT_FILE environmental variables to vertify
# servers' SSL certificates during download.
# export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
# export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

###############################      GPU SETUP     #############################
# Ensure all allocated GPUs are visible
export R_LIBS="/opt/Rlibs"
export R_LIBS_USER="/opt/Rlibs"
export R_LIBS_SITE="/opt/Rlibs"
export LD_LIBRARY_PATH="/opt/Rlibs/lib"
export R_HOME=/usr/lib/R
export PATH=/usr/lib/R/bin:$PATH

export PATH="/usr/local/cuda/bin:\
/usr/local/nvidia/bin:\
/usr/local/cuda/bin:\
/usr/local/sbin:\
/usr/local/bin:\
/usr/sbin:\
/usr/bin:\
/sbin:\
/bin"

# ---- CUDA ----
export CUDA_HOME="/usr/local/cuda"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64"

apptainer exec  \
  --bind $PWD:/mnt \
  --bind $PWD/_targets:/opt/_targets \
  --bind /run/munge:/run/munge \
  --bind /ddn/gs1/tools/slurm/etc/slurm:/ddn/gs1/tools/slurm/etc/slurm \
  slurm_testing.sif \
  /usr/local/lib/R/bin/Rscript --no-init-file /mnt/targets_run.R