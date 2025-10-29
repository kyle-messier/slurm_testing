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
  --containall\
  --bind $PWD:/mnt \
  --bind targets:/opt/_targets \
  --bind /run/munge:/run/munge \
  --bind /ddn/gs1/tools/slurm/etc/slurm:/ddn/gs1/tools/slurm/etc/slurm \
  slurm_testing.sif \
  /usr/local/lib/R/bin/Rscript --no-init-file /mnt/sf-tests.r


  # apptainer exec --containall \
#   --bind /tmp \
#   slurm_testing.sif \
#   R -q -e "library(sf); print(sessionInfo()); st_point(c(1,2));"

# apptainer exec --containall slurm_testing.sif gdalinfo --version

# apptainer exec --containall slurm_testing.sif ldconfig -p | grep gdal

# apptainer exec --containall slurm_testing.sif sh -c 'gdalinfo --version; which gdalinfo; gdal-config --prefix'