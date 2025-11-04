#!/bin/bash
#SBATCH --job-name apptainer-mpi
#SBATCH -N $NNODES # total number of nodes
#SBATCH --time=00:05:00 # Max execution time
#SBATCH --mail-user=kyle.messier@nih.gov
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=highmem
#SBATCH --nodes=2
#SBATCH --error=slurm/mpi_test_%j.err
#SBATCH --output=slurm/mpi_test_%j.out

srun -n $NP apptainer exec mpitest.sif /opt/mpitest