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
1. \curl -L https://install.perlbrew.pl | bash
2. Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/perl5/perlbrew/bin"
3. perlbrew install perl-5.34.0
```

* Installation of unitas
```
1. Download source code from: https://www.smallrnagroup.uni-mainz.de/software.html
2. unzip unitas_1.7.0.zip
3. cd unitas
4. chmod 755 unitas_1.7.0.pl
5. dos2unix unitas_1.7.0.pl
    * Produces error if not converted.
6. Change first line of unitas_1.7.0.pl to "#!/usr/bin/env perl"
    * Required if wanting to run unitas globally
7. Add path to .bashrc "export PATH=$PATH:/home/uqdguanz/Programs/unitas"
8. perlbrew switch perl-5.34.0
9. unitas_1.7.0.pl
    * Install any perl module requirements using cpan.
10. Install module Crypt::SSLeay.
    * Say yes to all tests. This module is required, unitas produces an error because it can't contact the server.
```

### Executing program

* Run the program.
```
1. perlbrew switch perl-5.34.0
2. unitas_1.7.0.pl -input T2-3_S3_L001_R1_001_trimmed.fastq -species homo_sapiens
```

## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors

Contributors names and contact info

ex. Dominique Pizzie  
ex. [@DomPizzie](https://twitter.com/dompizzie)

## Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [dbader](https://github.com/dbader/readme-template)
* [zenorocha](https://gist.github.com/zenorocha/4526327)
* [fvcproductions](https://gist.github.com/fvcproductions/1bfc2d4aecb01a834b46)