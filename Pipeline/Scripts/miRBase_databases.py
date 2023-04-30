"""

Create genome specific miRBase databases.

"""

import subprocess

# Check if miRBase reference files exist, else download.
def databases_miRBase(miRBase_var):

    # Extract genomic specific mature and hairpin miRNA sequences.
    miRBase_file_prefix = "./Required_files/miRBase/" + miRBase_var
    
    file1 = open((miRBase_file_prefix + "_mature.fa"), "wb")
    
    cmd_list = ["grep --no-group-separator -A1 " + ("\"^>" + miRBase_var + "-\"") + " ./Required_files/miRBase/mature.fa"]
    process = subprocess.run(cmd_list, shell=True, capture_output=True)
    
    file1.write(process.stdout)
    file1.close()
    
    file1 = open((miRBase_file_prefix + "_hairpin.fa"), "wb")
    
    cmd_list = ["grep --no-group-separator -A1 " + ("\"^>" + miRBase_var + "-\"") + " ./Required_files/miRBase/hairpin.fa"]
    process = subprocess.run(cmd_list, shell=True, capture_output=True)
    
    file1.write(process.stdout)
    file1.close()


databases_miRBase(snakemake.wildcards.miRBase_name)