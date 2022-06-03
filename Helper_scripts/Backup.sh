#!/bin/bash

cd ../../

# Copy directory for tarring
cp -r Pipeline_small_ncRNA/ ./$1
rm -r $1/Pipeline/Required_files/hg38

# Tar directory and move
tar -zcvf $1.tar.gz $1
mv $1.tar.gz $2

# Delete directory
rm -rf $1