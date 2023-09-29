#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=300G
#SBATCH --job-name=smallRNA
#SBATCH --time=48:00:00
#SBATCH --partition=general
#SBATCH --account=a_salomon
#SBATCH -o slurm.output
#SBATCH -e slurm.error

conda activate Pipeline_small_ncRNA 


sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/230920_NS500239_0551_AHTYLCBGXT" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "230920_NS500239_0551_AHTYLCBGXT" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5

##########

sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/230927_NS500239_0553_AHWW3GBGXT" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "230927_NS500239_0553_AHWW3GBGXT" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5

##########

sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/230927_NS500239_0553_AHWW3GBGXT" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "230927_NS500239_0553_AHWW3GBGXT" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5


conda deactivate
sleep 5
