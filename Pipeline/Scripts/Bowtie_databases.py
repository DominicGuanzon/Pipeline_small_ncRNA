"""

Download the necessary bowtie indexes, or build bowtie indexes if download isn't available.

"""

import subprocess


# Download or install bowtie indexes.
def databases_bowtie(genome_var):
    genome_folder = "./Required_files/" + genome_var + "/"
    
    # GRCh38 database
    if genome_var == "human":
        cmd_list = [["wget", "-q", "ftp://ftp.ccb.jhu.edu/pub/data/bowtie_indexes/GRCh38_no_alt.zip"],
                    ["unzip", "GRCh38_no_alt.zip", "-d", genome_folder],
                    ["rm", "GRCh38_no_alt.zip"]]
        
        for cmd_var in cmd_list:
            process = subprocess.run(cmd_var)
    
    # Pig database
    if genome_var == "pig":
        cmd_list = [["wget", "-q", "http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Sus_scrofa/Ensembl/Sscrofa11.1/Sus_scrofa_Ensembl_Sscrofa11.1.tar.gz"],
                    ["tar", "-xvzf", "Sus_scrofa_Ensembl_Sscrofa11.1.tar.gz", "Sus_scrofa/Ensembl/Sscrofa11.1/Sequence/BowtieIndex"]]
        
        for cmd_var in cmd_list:
            process = subprocess.run(cmd_var)
            
        process = subprocess.run(("mv ./Sus_scrofa/Ensembl/Sscrofa11.1/Sequence/BowtieIndex/*.ebwt " + genome_folder), shell = True)
        
        cmd_list = [["rm", "Sus_scrofa_Ensembl_Sscrofa11.1.tar.gz"],
                    ["rm", "-r", "Sus_scrofa"]]            
        
        for cmd_var in cmd_list:
            process = subprocess.run(cmd_var)
    
    # Chinese hamster database
    if genome_var == "chinese_hamster":
        cmd_list = [["wget", "-q", "https://ftp.ensembl.org/pub/release-109/fasta/cricetulus_griseus_chok1gshd/dna/Cricetulus_griseus_chok1gshd.CHOK1GS_HDv1.dna.toplevel.fa.gz"],
                    ["gunzip", "Cricetulus_griseus_chok1gshd.CHOK1GS_HDv1.dna.toplevel.fa.gz"],
                    ["bowtie-build", "--threads", "4", "Cricetulus_griseus_chok1gshd.CHOK1GS_HDv1.dna.toplevel.fa", (genome_folder + "chok1gshd")],
                    ["rm", "-r", "Cricetulus_griseus_chok1gshd.CHOK1GS_HDv1.dna.toplevel.fa"]]
        
        for cmd_var in cmd_list:
            process = subprocess.run(cmd_var)


databases_bowtie(snakemake.wildcards.genome_folder)