

parse_and_plot_read_loss <- function(data_path_raw, data_path_2_adaptor, data_path_3_trimmed, out_path) {

    Raw_reads = list.files(data_path_raw, pattern = ".fastq$", full.names = TRUE)
    Raw_reads_counts = data.frame(sapply(Raw_reads[1:3], function(x) length(count.fields(x, blank.lines.skip = FALSE))))
    Raw_reads_counts$Sample_names = paste0(
    
    Reads_adaptor = list.files(data_path_2_adaptor, pattern = ".fastq$", full.names = TRUE)
    Reads_adaptor_count = data.frame(sapply(Raw_reads, function(x) length(count.fields(x, blank.lines.skip = FALSE))))
    
    Reads_trimmed = list.files(data_path_3_trimmed, pattern = ".fastq$", full.names = TRUE)
    Reads_trimmed_counts = data.frame(sapply(Raw_reads, function(x) length(count.fields(x, blank.lines.skip = FALSE))))
    
    

