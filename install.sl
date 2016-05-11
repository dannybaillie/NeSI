#!/bin/bash
#SBATCH -J install_pkg
#SBATCH -A projectIDhere
#SBATCH --ntasks 1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --output=install_pkg_Rout.txt
#SBATCH --error=install_pkg_err.txt
module load R/3.1.1-goolf-1.5.14
srun Rscript install.R 'package_name' # <- name CRAN package here

