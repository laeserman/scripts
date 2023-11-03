#Script from https://github.com/lindsawi/HybSeq-SNP-Extraction modified to add memory options  

#!/bin/bash
##End of Select Varitants for GATK4

set -eo pipefail
reference=filtered_target_file.fasta #Ppyriforme-3728.supercontigs.fasta
prefix=Rchap #Physcomitrium-pyriforme
#Make Samples list
ls *-g.vcf > samples.list


/home/lauren/Programs/gatk-4.2.6.1/gatk --java-options "-Xmx14g" CombineGVCFs -R $reference --variant samples.list -O "$prefix".cohort.g.vcf

/home/lauren/Programs/gatk-4.2.6.1/gatk --java-options "-Xmx14g" GenotypeGVCFs -R $reference -V "$prefix".cohort.g.vcf -O "$prefix".cohort.unfiltered.vcf

# Keep only SNPs passing a hard filter
/home/lauren/Programs/gatk-4.2.6.1/gatk --java-options "-Xmx14g" SelectVariants -V "$prefix".cohort.unfiltered.vcf -R $reference -select-type-to-include SNP -O "$prefix".SNPall.vcf

/home/lauren/Programs/gatk-4.2.6.1/gatk --java-options "-Xmx14g" VariantFiltration -R $reference -V "$prefix".SNPall.vcf --filter-name "hardfilter" -O "$prefix".snp.filtered.vcf --filter-expression "QD < 5.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0"

/home/lauren/Programs/gatk-4.2.6.1/gatk --java-options "-Xmx14g" VariantFiltration -R $reference -V "$prefix".SNPall.vcf --filter-name "filter1" --filter-expression "QD < 5.0" --filter-name "filter2" --filter-expression "FS > 60.0" --filter-name "filter3" --filter-expression "MQ < 40.0" --filter-name "filter4" --filter-expression "MQRankSum < -12.5" --filter-name "filter5" --filter-expression "ReadPosRankSum < -8.0" -O "$prefix".snp.filtered.vcf

/home/lauren/Programs/gatk-4.2.6.1/gatk --java-options "-Xmx14g" SelectVariants -V "$prefix".snp.filtered.vcf -O "$prefix".snp.filtered.nocall.vcf --set-filtered-gt-to-nocall

/home/lauren/Programs/gatk-4.2.6.1/gatk --java-options "-Xmx14g" VariantFiltration -R $reference -V "$prefix".SNPall.vcf -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30" -filter "SOR > 3.0" --filter-name "SOR3" -filter "FS > 60.0" --filter-name "FS60" -filter "MQ < 40.0" --filter-name "MQ40" -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" -O "$prefix".snp.filtered.vcf
