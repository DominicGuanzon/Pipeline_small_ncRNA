# Pipeline_small_ncRNA

This is a pipeline to analyse small RNA sequencing data using Unitas and miRDeep2.

## Description

The pipeline uses cutadapt to remove adapter sequences. The cleaned reads are analysed using unitas and miRDeep2.

## Getting Started

### Dependencies

* cutadapt 1.18
* unitas_1.7.0
* miRDeep2.0.0.7

### Installing

* Install latest version of perl on PBS clusters using perlbrew
```
\curl -L https://install.perlbrew.pl | bash
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/perl5/perlbrew/bin"
perlbrew install perl-5.34.0
```

* Installation of unitas on PBS clusters
```
Download source code from: https://www.smallrnagroup.uni-mainz.de/software.html
unzip unitas_1.7.0.zip
cd unitas
chmod 755 unitas_1.7.0.pl
dos2unix unitas_1.7.0.pl
    * Produces error if not converted.
Change first line of unitas_1.7.0.pl to "#!/usr/bin/env perl"
    * Required if wanting to run unitas globally.
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/Programs/unitas"
perlbrew switch perl-5.34.0
unitas_1.7.0.pl
    * Install any perl module requirements using cpan. I believe one of the requirements is LWP::Simple.
Install perl module Crypt::SSLeay using cpan.
    * Say yes to all tests. This module is required, unitas produces an error because it can't contact the server.
```

* Installation of miniconda on PBS clusters
```
Follow this guide: https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html
```

### Executing program

* Clone the pipeline from git

* Download required files
```
mkdir Pipeline_small_ncRNA/Pipeline/Required_files/hg38 && cd $_
wget ftp://ftp.ccb.jhu.edu/pub/data/bowtie_indexes/GRCh38_no_alt.zip
    * Bowtie human hg38 index
cd ../../../..
    
mkdir Pipeline_small_ncRNA/Pipeline/Required_files/hg38_miRBase && cd $_
wget https://www.mirbase.org/ftp/CURRENT/mature.fa.zip --no-check-certificate
wget https://www.mirbase.org/ftp/CURRENT/hairpin.fa.zip --no-check-certificate
for z in *.zip; do unzip "$z"; done
grep -A1 "^>hsa-" mature.fa > mature_hsa.fa
grep -A1 "^>hsa-" hairpin.fa > hairpin_hsa.fa
    * Extract only human miRNA's
```

* Create conda instance
```
conda create -c conda-forge -n Pipeline_small_ncRNA mamba
conda activate Pipeline_small_ncRNA
mamba install -c bioconda -c conda-forge snakemake
conda deactivate
```

* Run unitas.
```
module load cutadapt
module load miRDeep2

cd Pipeline_small_ncRNA/Pipeline/
conda activate Pipeline_small_ncRNA
snakemake --cores 4 --set-threads annotate_read=4
    * Threads are the number of input files analysed in parrallel by Unitas.
```

## Help

## Authors

Dominic Guanzon

## Version History

* 0.1
    * Initial Release

## License

## Acknowledgments

* [unitas](https://www.smallrnagroup.uni-mainz.de/software.html)
    * Gebert, D., Hewel, C. & Rosenkranz, D. unitas: the universal tool for annotation of small RNAs. BMC Genomics 18, 644 (2017). https://doi.org/10.1186/s12864-017-4031-9
* [miRDeep2](https://www.mdc-berlin.de/content/mirdeep2-documentation?mdcbl%5B0%5D=/n-rajewsky%23t-data%2Csoftware%26resources&mdctl=0&mdcou=20738&mdcot=6&mdcbv=71nDTh7VzOJOW6SFGuFySs4mus4wnovu-t2LZzV2dL8)
    * Marc R. Friedländer, Sebastian D. Mackowiak, Na Li, Wei Chen, Nikolaus Rajewsky, miRDeep2 accurately identifies known and hundreds of novel microRNA genes in seven animal clades, Nucleic Acids Research, Volume 40, Issue 1, 1 January 2012, Pages 37–52, https://doi.org/10.1093/nar/gkr688