#!/bin/bash

# First move into directory of script
cd $(dirname $0)

cd ..

# Add tar file extension to parameter and untar.
cp "${1}.tar.gz" .
tar xvf "`basename $1`.tar.gz"

# Move FASTQ to data folder
find `basename $1` -type f \( -iname "*.fastq.gz" ! -iname "Undetermined_*" \) -exec mv {} Pipeline/Data/  \;

# Untar FASTQ files
gzip -d -r Pipeline/Data/

# Replace sample file
rm Config/Sample_file.tsv
cp "${2}`basename $1`.tsv" Config/Sample_file.tsv

# Remove unsed files
rm -r `basename $1`
rm -r "`basename $1`.tar.gz"