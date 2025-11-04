#!/bin/bash
#SBATCH --job-name=mpi-test
#SBATCH --mail-user=kyle.messier@nih.gov
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=highmem
#SBATCH --nodes=2
#SBATCH --error=slurm/mpi_test_%j.err
#SBATCH --output=slurm/mpi_test_%j.out
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:05:00

# module load mpi/mpich-x86_64

srun apptainer exec -np 4 mpitest.sif /opt/mpitest
