#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=300G
#SBATCH --job-name=smallRNA
#SBATCH --time=24:00:00
#SBATCH --partition=general
#SBATCH --account=a_salomon
#SBATCH -o slurm.output
#SBATCH -e slurm.error

conda activate Pipeline_small_ncRNA 

sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/MGRF-NGS-165-DOMINIC_B-68316248" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "MGRF-NGS-165-DOMINIC_B-68316248" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5


sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/MGRF-NGS-172-DOMINIC_A-73714641" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "MGRF-NGS-172-DOMINIC_A-73714641" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5


sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/MGRF-NGS-172-DOMINIC_B-73909837" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "MGRF-NGS-172-DOMINIC_B-73909837" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5

conda deactivate
sleep 5
