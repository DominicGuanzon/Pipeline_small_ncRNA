#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=45G
#SBATCH --job-name=Test
#SBATCH --time=12:00:00
#SBATCH --partition=general
#SBATCH --account=a_salomon
#SBATCH -o slurm.output
#SBATCH -e slurm.error

conda activate Pipeline_small_ncRNA 

sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/210408_CS_Run_18_MN00796_0101_A000H3F2LK" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 8 --set-threads annotate_read=8
sleep 5
cd ..

sh Helper_scripts/Backup.sh "210408_CS_Run_18_MN00796_0101_A000H3F2LK" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5

conda deactivate
sleep 5
