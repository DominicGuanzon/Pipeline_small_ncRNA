#!/bin/bash

cd ../Pipeline/

rm -r Final_outputs/
rm -r Unitas_annotated_reads/
rm -r miRDeep2_output/
rm -r Trimmed_reads/
rm -r Adaptor_removed/
rm -r Data/
rm -r .snakemake/

mkdir Data