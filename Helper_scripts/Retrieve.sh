#!/bin/bash

cd ..

# Add tar file extension to parameter and untar.
cp "${1}.tar.gz" .
tar xvf "`basename $1`.tar.gz"

# Move FASTQ to data folder
find `basename $1` -type f \( -iname "*.fastq.gz" ! -iname "Undetermined_*" \) -exec mv {} Pipeline/Data/  \;

# Untar FASTQ files
gzip -d -r Pipeline/Data/

# Remove unsed files
rm -r `basename $1`
rm -r "`basename $1`.tar.gz"