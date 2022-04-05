library(ggplot2)

### To do: More intelligent way to retrieve sample names from filename ###
calculate_number_of_reads <- function(file_list) {
    
    # Counts number of lines in file, then divide by 4 (Fastq)
    Raw_reads_counts = data.frame(Counts = sapply(file_list, function(x) length(count.fields(x, blank.lines.skip = FALSE))))
    Raw_reads_counts$Counts = Raw_reads_counts$Counts / 4
    
    # Rename rows
    sample_names = strsplit(basename(rownames(Raw_reads_counts)), "_L001_|_L002_|_L003_|_L004_|_cleaned.fastq|_trimmed.fastq")
    Raw_reads_counts$Sample_names = unlist(lapply(sample_names, "[[", 1))
    rownames(Raw_reads_counts) = Raw_reads_counts$Sample_names
    
    return(Raw_reads_counts)
    
}

parse_and_plot_read_loss <- function(data_path_raw, data_path_2_adaptor, data_path_3_trimmed, out_path) {

    Sample_file = read.csv("../Config/Sample_file.tsv", sep = "\t")
    
    # List raw files and calculate number of reads
    Raw_reads = list.files(data_path_raw, pattern = ".fastq$", full.names = TRUE)
    Raw_reads_count = calculate_number_of_reads(Raw_reads)
    names(Raw_reads_count)[names(Raw_reads_count) == "Counts"] <- "Raw_counts"
    
    # List adaptor processed files and calculate number of reads
    Reads_adaptor = list.files(data_path_2_adaptor, pattern = ".fastq$", full.names = TRUE)
    Reads_adaptor_count = calculate_number_of_reads(Reads_adaptor)
    names(Reads_adaptor_count)[names(Reads_adaptor_count) == "Counts"] <- "Adaptor_removal_counts"
    
    # List adaptor trimmed processed files and calculate number of reads
    Reads_trimmed = list.files(data_path_3_trimmed, pattern = ".fastq$", full.names = TRUE)
    Reads_trimmed_count = calculate_number_of_reads(Reads_trimmed)
    names(Reads_trimmed_count)[names(Reads_trimmed_count) == "Counts"] <- "Trimmed_removal_counts"
    
    # Merge dataframes
    Merged_dataframe = Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "Sample_names", all = TRUE), list(Raw_reads_count,Reads_adaptor_count,Reads_trimmed_count))
    rownames(Merged_dataframe) = Merged_dataframe$Sample_names
    
    # Sort based on sample sheet
    Merged_dataframe_sorted = Merged_dataframe[Sample_file$Sample_name, ]
    Merged_dataframe_sorted$Sample_names = factor(Merged_dataframe_sorted$Sample_names, levels = Merged_dataframe_sorted$Sample_names)
    
    # Write to file
    write.csv(Merged_dataframe_sorted, out_path[[1]])
    
    # Plot graph
    pdf(out_path[[2]], width = 11.7, height = 8.3)
    
    print(ggplot(data=Merged_dataframe_sorted, aes(x=Sample_names, y=Raw_counts)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)))

    print(ggplot(data=Merged_dataframe_sorted, aes(x=Sample_names, y=Adaptor_removal_counts)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)))
        
    print(ggplot(data=Merged_dataframe_sorted, aes(x=Sample_names, y=Trimmed_removal_counts)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)))
    
    dev.off()

}

parse_and_plot_read_loss(snakemake@params[["input_dir_raw"]], snakemake@params[["input_dir_adaptor"]], snakemake@params[["input_dir_trimmed"]], snakemake@output)