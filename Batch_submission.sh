#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=100G
#SBATCH --job-name=smallRNA
#SBATCH --time=24:00:00
#SBATCH --partition=general
#SBATCH --account=a_salomon
#SBATCH -o slurm.output
#SBATCH -e slurm.error

conda activate Pipeline_small_ncRNA 


sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/221005_NS500239_0517_AH3TVYBGXL" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "221005_NS500239_0517_AH3TVYBGXL" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5

#######

sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/230227_NS500239_0529_AH75T7BGXN" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "230227_NS500239_0529_AH75T7BGXN" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5

#######

sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/230314_NS500239_0532_AH73T5BGXN" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 24 --set-threads annotate_read=24
sleep 5
cd ..

sh Helper_scripts/Backup.sh "230314_NS500239_0532_AH73T5BGXN" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5


conda deactivate
sleep 5
