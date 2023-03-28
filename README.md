# Pipeline_small_ncRNA

This is a pipeline to analyse small RNA sequencing data using Unitas and miRDeep2.
Only single end read supported at the moment.

## Description

The pipeline uses cutadapt to remove adapter sequences. The cleaned reads are analysed using unitas and miRDeep2.

## Getting Started

### Dependencies

* miniconda 23.1.0 Python 3.10.9 released February 7, 2023
    * bioconda::snakemake=7.25.0
    * bioconda::mirdeep2=2.0.1.2
    * bioconda::cutadapt=4.3
    * conda-forge::r-base=4.2.3
    * conda-forge::r-reshape2=1.4.4
    * conda-forge::r-ggplot2=3.4.1
    * conda-forge::perl=5.32.1
	* conda-forge::r-stringi=1.7.12
    * bioconda::perl-lwp-simple=6.39
    * bioconda::perl-archive-extract=0.88
    * bioconda::perl-archive-zip=1.68
    * bioconda::perl-lwp-protocol-https=6.10 

* unitas_1.7.0
    * Install any perl module requirements. For me it was:
        * cpan LWP::Simple Archive::Extract Archive::Zip LWP::Protocol::https
        * Unitas doesn't produce an error, but LWP::Protocol::https is required. Without this module, Unitas can't contact and download databases from server.	

### Installing

Installation of miniconda.
```
Download miniconda source from: https://docs.conda.io/en/latest/miniconda.html#linux-installers
wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh
Specify path option: /home/uqdguanz/Programs/miniconda3
Specify conda init option: yes
```

Installation of unitas
```
Download unitas source code from: https://www.smallrnagroup.uni-mainz.de/software.html
    * wget https://www.smallrnagroup.uni-mainz.de/software/unitas_1.7.0.zip
unzip unitas_1.7.0.zip
cd unitas
chmod 755 unitas_1.7.0.pl
dos2unix unitas_1.7.0.pl
    * Produces error if not converted.
Change first line of unitas_1.7.0.pl to "#!/usr/bin/env perl"
    * Required if wanting to run unitas globally.
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/Programs/unitas"	
```

Clone Pipeline_small_ncRNA pipline from github
```
git clone https://github.com/DominicGuanzon/Pipeline_small_ncRNA.git
cd Pipeline_small_ncRNA
```

Create conda enviroment to install dependencies using yaml file.
```
conda install -n base conda-forge::mamba
mamba env create -n Pipeline_small_ncRNA -f Pipeline_small_ncRNA_env.yaml
cd ..
```

### Executing program

Download required files
```
mkdir -p Pipeline_small_ncRNA/Pipeline/Required_files/hg38 && cd $_
wget ftp://ftp.ccb.jhu.edu/pub/data/bowtie_indexes/GRCh38_no_alt.zip
    * Bowtie human hg38 index
for z in *.zip; do unzip "$z"; done
cd ../../../..
    
mkdir -p Pipeline_small_ncRNA/Pipeline/Required_files/hg38_miRBase && cd $_
wget https://www.mirbase.org/ftp/CURRENT/mature.fa.zip --no-check-certificate
wget https://www.mirbase.org/ftp/CURRENT/hairpin.fa.zip --no-check-certificate
for z in *.zip; do unzip "$z"; done
grep --no-group-separator -A1 "^>hsa-" mature.fa > mature_hsa.fa
grep --no-group-separator -A1 "^>hsa-" hairpin.fa > hairpin_hsa.fa
    * Extract only human miRNA's
```

* Add data and modify Sample file
```
Move FASTQ data files to Pipeline_small_ncRNA/Pipeline/Data

Open Pipeline_small_ncRNA/Config/Sample_file.tsv and modify
    * Include FASTQ file names to be analysed in the "File_name" column.
    * Include sample names corresponding to the FASTQ files. All subsequent files generated will use the sample name.
    * Include either "truseq" or "nextflex" libraries in the "Library_type" column.
```

* Run pipeline.
```
cd Pipeline_small_ncRNA/Pipeline/
source activate Pipeline_small_ncRNA
snakemake --cores 4 --set-threads annotate_read=4
    * Threads are the number of input files analysed in parrallel by Unitas.
```

## Notes

Installation of perlbrew on Bunya clusters
```
\curl -L https://install.perlbrew.pl | bash
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/perl5/perlbrew/bin"
perlbrew --notest install perl-5.36.0
    * Produces error while testing perl installation, discussed [here](https://github.com/Perl/perl5/issues/15544). Issue seems to be resolved, but still occurs for me. Skipping testing for now.
```

Attempted manual installation of miRDeep2 on Bunya clusters. make_html.pl fails, issue with cpan Compress::Zlib. Workaround is to install using bioconda.
```
Followed this guide: https://github.com/rajewsky-lab/mirdeep2

Download miRDeep2 source code from: https://github.com/rajewsky-lab/mirdeep2/releases/tag/v0.1.3
    * wget https://github.com/rajewsky-lab/mirdeep2/archive/refs/tags/v0.1.3.zip
unzip v0.1.3.zip
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/Programs/mirdeep2-0.1.3/src"

Download bowtie source code from: https://bowtie-bio.sourceforge.net/index.shtml
    * wget https://sourceforge.net/projects/bowtie-bio/files/bowtie/1.3.1/bowtie-1.3.1-linux-x86_64.zip/download -O bowtie-1.3.1-linux-x86_64.zip
unzip bowtie-1.3.1-linux-x86_64.zip
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/Programs/miRDeep2/bowtie-1.3.1-linux-x86_64"

Download Vienna source code from: https://www.tbi.univie.ac.at/RNA/
    * wget https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_5_x/ViennaRNA-2.5.1.tar.gz
tar -xf ViennaRNA-2.5.1.tar.gz
cd ViennaRNA-2.5.1
./configure --prefix=/home/uqdguanz/Programs/ViennaRNA
make install
cd ..
rm -r ViennaRNA-2.5.1
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/Programs/ViennaRNA-2.3.5/bin"

Download SQUID source code from: http://eddylab.org/software.html
    * wget http://eddylab.org/software/squid/squid.tar.gz
tar -xf squid.tar.gz
cd squid-1.9g/
./configure
make
cd ..

Download randfold source code from: http://bioinformatics.psb.ugent.be/software/details/Randfold
    * wget http://bioinformatics.psb.ugent.be/supplementary_data/erbon/nov2003/downloads/randfold-2.0.1.tar.gz
tar -xf randfold-2.0.1.tar.gz
mv randfold-2.0.1-a7feeeaeba2afe567dbd061b9f4965646386bc98 randfold-2.0.1
cd randfold-2.0.1
edit Makefile
    * change line with INCLUDE=-I. to INCLUDE=-I. -I/home/uqdguanz/Programs/squid-1.9g/ -L/home/uqdguanz/Programs/squid-1.9g/
make
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/Programs/randfold-2.0.1"
cd ..

Install PDF::API2
    * Ensure perlbrew switch perl-5.36.0 before installation
	    * cpan PDF::API2
        * cpan Compress::Zlib
Add path to .bashrc "export PERL5LIB=PERL5LIB:/home/uqdguanz/perl5/perlbrew/perls/perl-5.34.0/lib/site_perl/5.34.0"

cd mirdeep2-0.1.3
touch install_successful
```

## Authors

Dominic Guanzon

## Acknowledgments

* [unitas](https://www.smallrnagroup.uni-mainz.de/software.html)
    * Gebert, D., Hewel, C. & Rosenkranz, D. unitas: the universal tool for annotation of small RNAs. BMC Genomics 18, 644 (2017). https://doi.org/10.1186/s12864-017-4031-9
* [miRDeep2](https://www.mdc-berlin.de/content/mirdeep2-documentation?mdcbl%5B0%5D=/n-rajewsky%23t-data%2Csoftware%26resources&mdctl=0&mdcou=20738&mdcot=6&mdcbv=71nDTh7VzOJOW6SFGuFySs4mus4wnovu-t2LZzV2dL8)
    * Marc R. Friedländer, Sebastian D. Mackowiak, Na Li, Wei Chen, Nikolaus Rajewsky, miRDeep2 accurately identifies known and hundreds of novel microRNA genes in seven animal clades, Nucleic Acids Research, Volume 40, Issue 1, 1 January 2012, Pages 37–52, https://doi.org/10.1093/nar/gkr688
* [cutadapt](https://cutadapt.readthedocs.io/en/stable/)
    * MARTIN, Marcel. Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal, [S.l.], v. 17, n. 1, p. pp. 10-12, may 2011. ISSN 2226-6089. Available at: <https://journal.embnet.org/index.php/embnetjournal/article/view/200>. doi:https://doi.org/10.14806/ej.17.1.200.