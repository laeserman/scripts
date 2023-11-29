#Load package dplyr
library(dplyr)

#set the working directory and load in the final filtered vcf file
setwd("C:/Users/leserman/Documents/Rhodo_chapmanii/Subsample")

#Run this loop to create N number of files where you randomly subsample one SNP per locus for each gene. Change the N in the first line below to reflect the number of files you want to create.

for (x in 1:N) {
  #Set the correct directory
  setwd("C:/Users/leserman/Documents/Rhodo_chapmanii/Subsample")
  #Read in table of SNPs
  table <- read.csv("Rchap_vcf_sites.csv")
  #Randomly select one SNP per gene
  sub <- table %>%
  group_by(table$Gene) %>%
  sample_n(1)
  #Write variable with X.CHROM and POS only
  vcftools <- sub[ , c("X.CHROM", "POS")]
  #Write each random subset of X.CHROM and POS to a unique file
  write.table(vcftools, file = paste0("subset",x,".txt"), sep = '\t', row.names = FALSE, col.names = FALSE, quote=FALSE)
  }
