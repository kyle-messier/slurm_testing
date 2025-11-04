#!/bin/bash
#SBATCH --job-name=container_test
#SBATCH --output=container_test_%j.out
#SBATCH --error=container_test_%j.err
#SBATCH --time=01:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G

# If SLURM container support exists, these won't error
#SBATCH --container-image=ubuntu:22.04
#SBATCH --container-mounts=/tmp:/tmp

echo "SLURM JOB RUNNING"
echo "Hostname inside container:"
hostname

echo "Testing basic commands:"
ls /
echo "Done."
