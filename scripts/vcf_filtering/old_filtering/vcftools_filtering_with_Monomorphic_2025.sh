#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

contig_file=/home/pkalhori/mywa_geo_chromosomes_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated
#mpileup/calls_mywa_geo_alignment_reseq_annotated/unfiltered_VCFs
cd $wd

for contig in $(cat  $contig_file)
do
input=${wd}/unfiltered_VCFs/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_2025.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_2025.vcf.gz


MISS=0.9
QUAL=30
MIN_DEPTH=5
MAX_DEPTH=25

##Invariant Sites
vcftools --gzvcf $input --remove-indels --max-missing $MISS --minQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maxDP $MAX_DEPTH --max-maf 0 --recode --stdout | bgzip -c >  ${output_Monomorphic} &

done

wait


for contig in $(cat  $contig_file)
do
input=${wd}/unfiltered_VCFs/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_2025.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_2025.vcf.gz

MISS=0.9 
QUAL=30
MIN_DEPTH=5
MAX_DEPTH=25

##SNPs (biallelic only)
vcftools --gzvcf $input --remove-indels --max-missing $MISS --minQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maxDP $MAX_DEPTH --min-alleles 2 --max-alleles 2 --recode --stdout | bgzip -c >  ${output_SNP} &

done 

wait

for contig in $(cat  $contig_file)
do

output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_2025.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_2025.vcf.gz

tabix $output_SNP &

wait 

tabix $output_Monomorphic &

done

wait

for contig in $(cat  $contig_file)
do

output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_2025.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_2025.vcf.gz
output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_2025.vcf.gz

bcftools concat --allow-overlaps $output_SNP $output_Monomorphic -Oz -o $output_all &

done

#wait

#for contig in $(cat  $contig_file)
#do
#output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE.vcf
#sed -i '/Variant Distance Bias/d' $output_all &
#done 

#wait

#for contig in $(cat $contig_file)
#do
#output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE.vcf
#bcftools convert -Oz -o ${output_all}.gz $output_all &
#done

#wait

#for contig in $(cat $contig_file)
#do
#output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE.vcf
#tabix ${output_all}.gz
#done


