#!/bin/bash
# sbatch_apptainer.sh
# Pass all arguments through to sbatch, but run inside container.

apptainer exec --cleanenv \
  --bind $PWD:/mnt \
  --bind $PWD/_targets:/mnt/_targets \
  --bind /run/munge:/run/munge \
  --bind /ddn/gs1/tools/slurm/etc/slurm:/ddn/gs1/tools/slurm/etc/slurm \
  slurm_testing.sif \
  sbatch "$@"
