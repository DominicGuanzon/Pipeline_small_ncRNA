"""

Parse Unitas outputs to combine all samples into one file.


"""

import glob
import pandas as pd
import os
from functools import reduce
import matplotlib.pyplot as plt


def parse_unitas(out_path, myparam):
    
    # Find paths for files needing to be parsed.
    Annotation_summary_paths = glob.glob(myparam + "*/unitas.annotation_summary.txt", recursive=True)
    Hit_target_paths = glob.glob(myparam + "*/unitas.hits_per_target.txt", recursive=True)
    TRF_simplified_paths = glob.glob(myparam + "*/unitas.tRF-table.simplified.txt", recursive=True)
    TRF_table_paths = glob.glob(myparam + "*/unitas.tRF-table.txt", recursive=True)
    Full_annotation_paths = glob.glob(myparam + "*/unitas.full_annotation_matrix.txt", recursive=True)
    
    # Merge unitas.annotation_summary.txt output data and also calculate RNA specie percentages.
    data = []
    
    for csv in Annotation_summary_paths:
        frame = pd.read_csv(csv, sep = "\t", names=["RNA_species", "Counts"])
        
        # Read in counts file. Error produced when engine not used. 
        # For index_col there is an issue where if rows of later lines is greater than (first line which has more rows than header).
        # Specify number of columns directly with names.
        full_annotation_temp = [s for s in Full_annotation_paths if os.path.dirname(csv) in s]
        full_annotation_temp = pd.read_csv(full_annotation_temp[0], sep = "\t", engine="python", index_col=False, names = ["Temp_1", "Temp_2", "Temp_3"])
        
        # Rename heading and remove first row containing headings. Convert reads to numeric.
        df_names = list(full_annotation_temp.iloc[0,::])
        full_annotation_temp.rename(columns={"Temp_1": df_names[0], "Temp_2": df_names[1], "Temp_3": df_names[2]}, inplace=True)
        full_annotation_temp = full_annotation_temp.drop([0])
        full_annotation_temp["reads"] = pd.to_numeric(full_annotation_temp["reads"])
        
        # This extracts the filename from the folder name generated by Unitas and renames counts column
        file_name = os.path.basename(os.path.dirname(csv).split("_", 2)[2]).rsplit("_", 1)[0].split("_", 2)[2].rsplit(".", 1)[0].rsplit("_", 1)[0]
        frame = frame.rename(columns = {"Counts": "Raw_counts_" + file_name})
        
        # Calculate percentage of each species.
        percentage_species = frame["Raw_counts_" + file_name] / full_annotation_temp["reads"].sum() * 100
        frame["Percentages_" + file_name] = percentage_species
        
        # Add row with total count details
        new_row = pd.DataFrame([{"RNA_species": "Total_counts", ("Raw_counts_" + file_name): full_annotation_temp["reads"].sum(), ("Percentages_" + file_name): 100}])
        frame = pd.concat([frame, new_row], ignore_index=True)
        
        # Find index of genomic_tRNA and mitochondrial tRNA
        genomic_tRNA = frame.RNA_species[frame.RNA_species.str.contains("genomic_tRNA")].index
        mitochondrial_tRNA = frame.RNA_species[frame.RNA_species.str.contains("Mt_tRNA")].index
        
        # Extract N + positions and add prefix to make unique.
        if len(genomic_tRNA) > 0:
            range_mod = range(genomic_tRNA[0] + 1, genomic_tRNA[0] + 9)
            tag_name = frame["RNA_species"].iloc[range_mod].tolist()
            tag_name = [s + "_gtRNA" for s in tag_name]
            frame.loc[range_mod, "RNA_species"] = tag_name
        
        if len(mitochondrial_tRNA) > 0:
            range_mod = range(mitochondrial_tRNA[0] + 1, mitochondrial_tRNA[0] + 9)
            tag_name = frame["RNA_species"].iloc[range_mod].tolist()
            tag_name = [s + "_mtRNA" for s in tag_name]
            frame.loc[range_mod, "RNA_species"] = tag_name
        
        data.append(frame)
    
    df_merged = reduce(lambda  left,right: pd.merge(left,right,on=["RNA_species"], how="outer"), data)
    df_merged.to_csv(out_path[0], index = False, na_rep = "NA")
    
    
    # Merge hits_per_target.txt output files
    data = []
    
    for csv in Hit_target_paths:
        frame = pd.read_csv(csv, sep = "\t")
        
        # This extracts the filename from the folder name generated by Unitas and renames counts column
        file_name = os.path.basename(os.path.dirname(csv).split("_", 2)[2]).rsplit("_", 1)[0].split("_", 2)[2].rsplit(".", 1)[0].rsplit("_", 1)[0]
        frame = frame.rename(columns = {"READ_COUNT": "READ_COUNT_" + file_name})
        
        data.append(frame)
    
    df_merged = reduce(lambda  left,right: pd.merge(left,right,on=["TRANSCRIPT_NAME", "TRANSCRIPT_CLASS"], how="outer"), data)
    df_merged.to_csv(out_path[1], index = False, na_rep = "NA")
    
    
    # Merge tRF-table.simplified.txt output files
    data = []
    
    for csv in TRF_simplified_paths:
        frame = pd.read_csv(csv, sep = "\t")
        
        # This extracts the filename from the folder name generated by Unitas and renames counts column
        file_name = os.path.basename(os.path.dirname(csv).split("_", 2)[2]).rsplit("_", 1)[0].split("_", 2)[2].rsplit(".", 1)[0].rsplit("_", 1)[0]
        frame = frame.rename(columns = {"absolute_counts": "absolute_counts_" + file_name, 
                "absolute_counts_including_trailer_and_leader_of_pre-tRNA": "absolute_counts_including_trailer_and_leader_of_pre-tRNA_" + file_name})
        
        data.append(frame)
    
    df_merged = reduce(lambda  left,right: pd.merge(left,right,on=["tRNA_name"], how="outer"), data)
    df_merged.to_csv(out_path[2], index = False, na_rep = "NA")
    
    
    # Merge full tRF-table output files. Seperate into absolute and fractionated counts.
    data = []
    
    for csv in TRF_table_paths:
        frame = pd.read_csv(csv, sep = "\t", skiprows = 2)
        
        # This extracts the filename from the folder name generated by Unitas and renames counts column
        file_name = os.path.basename(os.path.dirname(csv).split("_", 2)[2]).rsplit("_", 1)[0].split("_", 2)[2].rsplit(".", 1)[0].rsplit("_", 1)[0]
        
        frame = frame.add_suffix("_" + file_name)
        frame = frame.rename(columns = {"source_tRNA_" + file_name: "source_tRNA"})
        
        data.append(frame)
    
    df_merged = reduce(lambda  left,right: pd.merge(left,right,on=["source_tRNA"], how="outer"), data)
    
    # Write absolute and franctionated counts to file.
    temp = df_merged.filter(regex="source_tRNA|(absolute)", axis=1)
    temp.to_csv(out_path[3], index = False, na_rep = "NA")
    
    temp = df_merged.filter(regex="source_tRNA|(fractionated)", axis=1)
    temp.to_csv(out_path[4], index = False, na_rep = "NA")
    
parse_unitas(snakemake.output, snakemake.params["input_dir"])