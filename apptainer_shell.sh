apptainer shell \
  --bind /ddn/gs1/tools/slurm/bin:/usr/bin \
  --bind /ddn/gs1/tools/slurm/etc/slurm:/etc/slurm \
  --bind /run/munge:/run/munge \
  --bind $PWD:/mnt \
  slurm_testing.sif
