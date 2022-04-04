
calculate_number_of_reads <- function(file_list) {
    
    # Counts number of lines in file, then divide by 4 (Fastq)
    Raw_reads_counts = data.frame(Counts = sapply(file_list, function(x) length(count.fields(x, blank.lines.skip = FALSE))))
    Raw_reads_counts$Counts = Raw_reads_counts$Counts / 4
    
    # Rename rows
    sample_names = strsplit(basename(rownames(Raw_reads_counts)), "_L001_|_L002_|_L003_|_L004_")
    Raw_reads_counts$Sample_names = unlist(lapply(sample_names, "[[", 1))
    rownames(Raw_reads_counts) = Raw_reads_counts$Sample_names
    
    return(Raw_reads_counts)
    
}

parse_and_plot_read_loss <- function(data_path_raw, data_path_2_adaptor, data_path_3_trimmed, out_path) {

    # List raw files and calculate number of reads
    Raw_reads = list.files(data_path_raw, pattern = ".fastq$", full.names = TRUE)
    Raw_reads_count = calculate_number_of_reads(Raw_reads)
    
    # List adaptor processed files and calculate number of reads
    Reads_adaptor = list.files(data_path_2_adaptor, pattern = ".fastq$", full.names = TRUE)
    Reads_adaptor_count = calculate_number_of_reads(Reads_adaptor)
    
    # List adaptor trimmed processed files and calculate number of reads
    Reads_trimmed = list.files(data_path_3_trimmed, pattern = ".fastq$", full.names = TRUE)
    Reads_trimmed_count = calculate_number_of_reads(Reads_trimmed)