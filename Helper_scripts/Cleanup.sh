#!/bin/bash

# First move into directory of script
cd $(dirname $0)

cd ../Pipeline/

rm -r Final_outputs/
rm -r miRDeep2_output/
rm -r Trimmed_reads/
rm -r Adaptor_removed/
rm -r Data/
rm -r .snakemake/
find Unitas_annotated_reads/ -type d -name "*.fastq_*" -exec rm -r "{}" \;
find Unitas_annotated_reads/ -type d -name "Log" -exec rm -r "{}" \;
find Unitas_annotated_reads/ -type f -name "*.unitas_pid" -exec rm "{}" \;

mkdir Data
