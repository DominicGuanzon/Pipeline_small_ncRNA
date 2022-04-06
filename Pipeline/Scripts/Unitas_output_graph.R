library(ggplot2)
library(reshape2)


# This plots a summary of the RNA species present in the samples.    
plot_summary_graphs <- function(data_path, out_path) {
    # Read in data
    Input_file <- read.csv(data_path)

    # Extract total_counts for plotting.
    Total_reads = Input_file[grep("^RNA_species|^Raw_counts", colnames(Input_file))]
    Total_reads = Total_reads[Total_reads$RNA_species == "Total_counts", ]
    
    # Extract percentage columns and extract only rows of interest (major RNA species).
    Percentage_data = Input_file[grep("^RNA_species|^Percentages", colnames(Input_file))]
    rows_to_extract = !grepl(paste0("miRNA:homo_sapiens$|miRNA:other$|genomic_rRNA$|Mt_rRNA$|",
         "^tRNA$|5'tR-halves_gtRNA$|5'tRFs_gtRNA$|3'tR-halves_gtRNA$|",
         "3'tRFs_gtRNA$|3'CCA-tRFs_gtRNA$|tRF-1_gtRNA$|tRNA-leader_gtRNA$|",
         "misc-tRFs_gtRNA$|5'tR-halves_mtRNA$|5'tRFs_mtRNA$|3'tR-halves_mtRNA$|",
         "3'tRFs_mtRNA$|3'CCA-tRFs_mtRNA$|tRF-1_mtRNA$|tRNA-leader_mtRNA$|",
         "misc-tRFs_mtRNA$|Total_counts$"), Percentage_data$RNA_species)
    Percentage_data = Percentage_data[rows_to_extract, ]
    
    # Rename
    Percentage_data[grep("mapped to piRNA producing loci", Percentage_data$RNA_species), "RNA_species"] = "piRNA producing loci"
    colnames(Percentage_data) = gsub("^Percentages_", "", colnames(Percentage_data))
    colnames(Total_reads) = gsub("^Raw_counts_", "", colnames(Total_reads))

    #Remove whitespace
    Percentage_data$RNA_species = trimws(Percentage_data$RNA_species, "left")

    # Convert from wide to long format
    Percentage_data_long = melt(Percentage_data, id.vars = "RNA_species")
    Total_count_data = melt(Total_reads, id.vars = "RNA_species")

    pdf(out_path, width = 11.7, height = 8.3)
    
    print(ggplot(Total_count_data, aes(x=variable, y=value)) +
    geom_bar(stat = "identity", position=position_dodge()) + theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), plot.title = element_text(hjust = 0.5)) + 
    labs(y = "Total counts after pre-processing", x = "Samples"))
    
    print(ggplot(Percentage_data_long, aes(x=RNA_species, y=value, fill=RNA_species)) +
        geom_bar(stat = "identity", position=position_dodge()) + theme_bw() + 
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position="top") + 
        labs(y = "Percentage") + facet_wrap( ~ variable))
        
    for (RNA_species_var in unique(Percentage_data_long$RNA_species)) {
        temp_df = Percentage_data_long[Percentage_data_long$RNA_species == RNA_species_var, ]
        print(ggplot(temp_df, aes(x=variable, y=value)) +
            geom_bar(stat = "identity", position=position_dodge()) + theme_bw() + 
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), plot.title = element_text(hjust = 0.5)) + 
            labs(y = "Percentage", x = "Samples") + ggtitle(RNA_species_var))
    }
    
    dev.off()
}

plot_summary_graphs(snakemake@input[[1]], snakemake@output[[1]])