#!/bin/bash

# First move into directory of script
cd $(dirname $0)

cd ../../

# Tar directory and move
# Note: Scratch is too small to create archive in the same directory then move to destination if lots of data.
# Although not ideal, create the archive in the destination RDM directory.
tar zcvf $2$1.tar.gz --exclude="Pipeline_small_ncRNA/Pipeline/Required_files" Pipeline_small_ncRNA/
