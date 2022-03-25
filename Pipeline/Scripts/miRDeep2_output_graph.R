library(ggplot2)

plot_summary_graphs <- function(data_path, out_path) {
    # Read in data
    Input_file = read.csv(data_path)

    # Calculate total counts and rename samples
    Subset_data = data.frame(Total_counts = colSums(Filter(is.numeric, Input_file)))
    Subset_data$Sample_names = gsub("^Raw_counts_", "", rownames(Subset_data))

    # FInd number of miRNA species (counts > 0) and rename samples
    miRNA_species = data.frame(Total_miRNA_species = t(data.frame(lapply(Input_file[colnames(Input_file) != "miRNAs"], function(x) sum(x > 0)))))
    miRNA_species$Sample_names = gsub("^Raw_counts_", "", rownames(miRNA_species))

    pdf(out_path, width = 11.7, height = 8.3)
    print(ggplot(data=Subset_data, aes(x=Sample_names, y=Total_counts, fill=Sample_names)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)))

    print(ggplot(data=miRNA_species, aes(x=Sample_names, y=Total_miRNA_species, fill=Sample_names)) +
        geom_bar(stat="identity", position=position_dodge()) + theme_bw() +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)))
    
    dev.off()
}

plot_summary_graphs(snakemake@input[[1]], snakemake@output[[1]])