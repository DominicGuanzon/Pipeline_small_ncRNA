library(ggplot2)
library(reshape2)

calculate_number_of_reads <- function(file_list, sample_file_input) {
    
    # Counts number of lines in file, then divide by 4 (Fastq)
    Raw_reads_counts = data.frame(Counts = sapply(file_list, function(x) length(count.fields(x, blank.lines.skip = FALSE))))
    Raw_reads_counts$Counts = Raw_reads_counts$Counts / 4
    
    # Look for sample name in file name using sample sheet
	Sample_names_var = paste0("^", sample_file_input$Sample_name, "_")
	
	Sample_names_var_position = c()
	for (sample_var_id in Sample_names_var) {
		Sample_names_var_position = c(Sample_names_var_position, grep(sample_var_id, basename(rownames(Raw_reads_counts))))
	}
	
	# If no matches, use the file name in sample sheet and determine sample name
	if (length(Sample_names_var_position) == 0) {
		Sample_names_var = paste0("^", sample_file_input$File_name, "$")
		
		Sample_names_var_position = c()
		for (sample_var_id in Sample_names_var) {
			Sample_names_var_position = c(Sample_names_var_position, grep(sample_var_id, basename(rownames(Raw_reads_counts))))
		}
	}
	
	Raw_reads_counts$Sample_names = sample_file_input[order(Sample_names_var_position), "Sample_name"]
    rownames(Raw_reads_counts) = Raw_reads_counts$Sample_names
    
    return(Raw_reads_counts)
    
}

parse_and_plot_read_loss <- function(data_path_raw, genome_folder, adaptor_files, trimmed_files, out_path) {

    Sample_file = read.csv("../Config/Sample_file.tsv", sep = "\t")
	
	# Subset Sample_file for genomes of interest
    Sample_file = Sample_file[Sample_file["Genome"] == genome_folder, ]
    
    # List raw files and calculate number of reads
	Raw_reads = list.files(data_path_raw, pattern = ".fastq$", full.names = TRUE)
	Raw_reads = Raw_reads[grep(paste0(Sample_file$File_name, "$", collapse = "|"), Raw_reads)]
    Raw_reads_count = calculate_number_of_reads(Raw_reads, Sample_file)
    names(Raw_reads_count)[names(Raw_reads_count) == "Counts"] <- "Raw_counts"
    
    # List adaptor processed files and calculate number of reads
	Reads_adaptor = adaptor_files[grep(paste0(Sample_file$Sample_name, "_", collapse = "|"), adaptor_files)]
    Reads_adaptor_count = calculate_number_of_reads(Reads_adaptor, Sample_file)
    names(Reads_adaptor_count)[names(Reads_adaptor_count) == "Counts"] <- "Adaptor_removal_counts"
    
    # List adaptor trimmed processed files and calculate number of reads
	Reads_trimmed = trimmed_files[grep(paste0(Sample_file$Sample_name, "_", collapse = "|"), trimmed_files)]
    Reads_trimmed_count = calculate_number_of_reads(Reads_trimmed, Sample_file)
    names(Reads_trimmed_count)[names(Reads_trimmed_count) == "Counts"] <- "Trimmed_removal_counts"
    
    # Merge dataframes
    Merged_dataframe = Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "Sample_names", all = TRUE), list(Raw_reads_count,Reads_adaptor_count,Reads_trimmed_count))
    rownames(Merged_dataframe) = Merged_dataframe$Sample_names
    
    # Sort based on sample sheet
    Merged_dataframe_sorted = Merged_dataframe[Sample_file$Sample_name, ]
    Merged_dataframe_sorted$Sample_names = factor(Merged_dataframe_sorted$Sample_names, levels = Merged_dataframe_sorted$Sample_names)
    
    # Write to file
    write.csv(Merged_dataframe_sorted, out_path[["summary_data"]])
    
    # Convert to long format
    Merged_dataframe_sorted_long = melt(Merged_dataframe_sorted, id.vars = "Sample_names")
    
    # Plot graph
    pdf(out_path[["summary_plots"]], width = 11.7, height = 8.3)
    
    print(ggplot(data=Merged_dataframe_sorted, aes(x=Sample_names, y=Raw_counts)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)))
        
    print(ggplot(data=Merged_dataframe_sorted, aes(x=Sample_names, y=Adaptor_removal_counts)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)))
        
    print(ggplot(data=Merged_dataframe_sorted, aes(x=Sample_names, y=Trimmed_removal_counts)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)))
        
    print(ggplot(data=Merged_dataframe_sorted_long, aes(x=variable, y=value, fill = variable)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_blank(), legend.position="top") + facet_wrap( ~ Sample_names))
        
    print(ggplot(data=Merged_dataframe_sorted_long, aes(x=variable, y=value, fill = variable)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_blank(), legend.position="top") + facet_wrap( ~ Sample_names, scales = "free_y"))
    
    dev.off()

}

parse_and_plot_read_loss(snakemake@params[["raw_data_folder"]], snakemake@params[["genome_folder_var"]], snakemake@input[["adaptor_data"]], snakemake@input[["trimmed_data"]], snakemake@output)