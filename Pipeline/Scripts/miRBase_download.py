"""

Download miRBase databases.

"""

import subprocess

# Download miRBase reference databases for downstream extraction of genome specific microRNAs
def download_miRBase(mature_output, hairpin_output):    
    mature_miRNA = "./" + mature_output
    hairpin_miRNA = "./" + hairpin_output
    
    cmd_list = [["wget", "https://www.mirbase.org/ftp/CURRENT/mature.fa.gz"],
                ["gunzip", "mature.fa.gz"],
                ["mv", "mature.fa", mature_miRNA]]
        
    for cmd_var in cmd_list:
        process = subprocess.run(cmd_var)

    cmd_list = [["wget", "https://www.mirbase.org/ftp/CURRENT/hairpin.fa.gz"],
                ["gunzip", "hairpin.fa.gz"],
                ["mv", "hairpin.fa", hairpin_miRNA]]
    
    for cmd_var in cmd_list:
        process = subprocess.run(cmd_var)
            
download_miRBase(snakemake.output["mature_miR"], snakemake.output["hairpin_miR"])