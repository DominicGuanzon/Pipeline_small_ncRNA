# Pipeline_small_ncRNA

This is a pipeline to analyse small RNA sequencing data using Unitas.

## Description

The pipeline uses trimmomatic to remove adapter sequences. The cleaned reads are analysed using unitas.

## Getting Started

### Dependencies

* trimmomatic 0.39
* unitas_1.7.0

### Installing

* Install latest version of perl on PBS clusters using perlbrew
```
\curl -L https://install.perlbrew.pl | bash
Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/perl5/perlbrew/bin"
perlbrew install perl-5.34.0
```

* Installation of unitas
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

### Executing program

* Run unitas.
```
perlbrew switch perl-5.34.0
unitas_1.7.0.pl -input T2-3_S3_L001_R1_001_trimmed.fastq -species homo_sapiens
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