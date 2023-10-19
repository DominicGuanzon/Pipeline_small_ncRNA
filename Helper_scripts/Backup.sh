#!/bin/bash

# First move into directory of script
cd $(dirname $0)

cd ../../

# Tar directory and move
tar --use-compress-program="pigz" -cvf $1.tar.gz Pipeline_small_ncRNA
mv $1.tar.gz $2