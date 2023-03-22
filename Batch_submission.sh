#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=45G
#SBATCH --job-name=Test
#SBATCH --time=24:00:00
#SBATCH --partition=general
#SBATCH --account=a_salomon
#SBATCH -o slurm.output
#SBATCH -e slurm.error

module load r/4.2.1-foss-2021a

# Loading the above modules, loads a lot of peripheral modules including python etc... unload these
module unload python/3.9.5-gcccore-10.3.0 
module unload scipy-bundle/2021.05-foss-2021a

conda activate Pipeline_small_ncRNA

sh Helper_scripts/Retrieve.sh "/QRISdata/Q4967/Archive/FASTQ_data/230314_NS500239_0532_AH73T5BGXN" "/QRISdata/Q4967/Archive/Analysed_data/Sample_sheets/"
sleep 5

cd Pipeline
snakemake --cores 8 --set-threads annotate_read=8
sleep 5
cd ..

sh Helper_scripts/Backup.sh "230314_NS500239_0532_AH73T5BGXN" "/QRISdata/Q4967/Archive/Analysed_data/"
sleep 5
sh Helper_scripts/Cleanup.sh
sleep 5

conda deactivate
sleep 5
