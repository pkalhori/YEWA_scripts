#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash
conda activate bcftools

contig_file=/home/pkalhori/mywa_geo_chromosomes_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated
mkdir -p $wd/SNPs_MAF


for contig in $(cat  $contig_file)
do
#input=${wd}/unfiltered_VCFs/all_samples_reseq_chromosome_${contig}.vcf.gz
input=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_2025.vcf.gz
output_SNP=${wd}/SNPs_MAF/all_samples_reseq_chromosome_${contig}_filtered_SNPs_MAF.vcf.gz
output_LD=${wd}/SNPs_MAF/all_samples_reseq_chromosome_${contig}_filtered_SNPs_MAF_LD.vcf.gz

MISS=0.9
QUAL=30
MIN_DEPTH=5
MAX_DEPTH=25
MIN_MAF=0.05

##SNPs (biallelic only)
#vcftools --gzvcf $input --remove-indels --maf $MIN_MAF --max-missing $MISS --minQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maxDP $MAX_DEPTH --min-alleles 2 --max-alleles 2 --recode --stdout | bgzip -c >  ${output_SNP} &

#vcftools --gzvcf $input --maf $MIN_MAF --recode --stdout | bgzip -c >  ${output_SNP} &

#wait

bcftools +prune -m 0.8 -w 50kb $output_SNP -Oz -o $output_LD

done

