#Script from https://github.com/lindsawi/HybSeq-SNP-Extraction modified by Lauren Eserman-Campbell

#!/bin/bash
set -eo pipefail

## Usage: bash variantcall.sh Sporobolus_cryptandrus_ref.fasta GUMOseq-0188
## Where .fasta is reference sequence + ' ' + samplename

# Set variables
reference=../$1
prefix=$2
#read1fn="$prefix.R1.paired.fastq"
#read2fn="$prefix.R2.paired.fastq"
read1fn=../"$prefix"_paired_R1.fastq
read2fn=../"$prefix"_paired_R2.fastq

cd $prefix
if [ ! -f ../*.dict ]
then /home/lauren/Programs/gatk-4.2.6.1/gatk CreateSequenceDictionary -R $reference
fi

bwa index $reference
samtools faidx $reference

#Align read files to reference sequence and map
bwa mem $reference $read1fn $read2fn | samtools view -bS - | samtools sort - -o "$prefix.sorted.bam"
/home/lauren/Programs/gatk-4.2.6.1/gatk FastqToSam -F1 $read1fn -F2 $read2fn -O $prefix.unmapped.bam -SM $prefix.sorted.bam

#Replace read groups to mapped and unmapped bam files using library prep and sequencing information
/home/lauren/Programs/gatk-4.2.6.1/gatk AddOrReplaceReadGroups -I  $prefix.sorted.bam -O $prefix.sorted-RG.bam -RGID 2 -RGLB lib1 -RGPL illumina -RGPU unit1 -RGSM $prefix
/home/lauren/Programs/gatk-4.2.6.1/gatk AddOrReplaceReadGroups -I  $prefix.unmapped.bam -O $prefix.unmapped-RG.bam -RGID 2 -RGLB lib1 -RGPL illumina -RGPU unit1 -RGSM $prefix

#Combine mapped and unmapped BAM files
/home/lauren/Programs/gatk-4.2.6.1/gatk MergeBamAlignment --ALIGNED_BAM $prefix.sorted-RG.bam --UNMAPPED_BAM $prefix.unmapped-RG.bam -O $prefix.merged.bam -R $reference

#Remove duplicate sequences
/home/lauren/Programs/gatk-4.2.6.1/gatk MarkDuplicates -I $prefix.merged.bam -O $prefix.marked.bam -M $prefix.metrics.txt
samtools index $prefix.marked.bam

#Create GVCF
/home/lauren/Programs/gatk-4.2.6.1/gatk HaplotypeCaller -I $prefix.marked.bam -O $prefix-g.vcf -ERC GVCF -R $reference

#Remove intermediate files
rm $prefix.sorted.bam $prefix.unmapped.bam $prefix.merged.bam $prefix.unmapped-RG.bam $prefix.sorted-RG.bam
