#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

contig_file=/home/pkalhori/mywa_geo_chromosomes_split_regions_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated


#cd /home/pkalhori/mpileup/calls_geothlypis_alignment
cd $wd

for contig in $(cat  $contig_file)
do
input=${wd}/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_HWE_strict.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_HWE_strict.vcf.gz
output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE_strict.vcf


MISS=0.9
QUAL=30
MIN_DEPTH=4
MAX_DEPTH=20

##Invariant Sites
vcftools --gzvcf $input --remove-indels --max-missing $MISS --minQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maxDP $MAX_DEPTH --max-alleles 2 --max-maf 0  --recode --stdout | bgzip -c >  ${output_Monomorphic} &

##SNPs (biallelic only)
vcftools --gzvcf $input --remove-indels --max-missing $MISS --minQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maf 0.05 --maxDP $MAX_DEPTH --min-alleles 2 --max-alleles 2 --hwe 0.1 --recode --stdout | bgzip -c >  ${output_SNP} &

done 

wait

for contig in $(cat $contig_file)
do
input=${wd}/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_HWE_strict.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_HWE_strict.vcf.gz
output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE_strict.vcf

tabix $output_SNP &
tabix $output_Monomorphic &

done

wait

for contig in $(cat $contig_file)
do
input=${wd}/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_HWE_strict.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_HWE_strict.vcf.gz
output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE_strict.vcf

bcftools concat --allow-overlaps $output_SNP $output_Monomorphic -Ov -o $output_all &

done

wait

for contig in $(cat $contig_file)
do
input=${wd}/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_HWE_strict.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_HWE_strict.vcf.gz
output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE_strict.vcf

sed -i '/Variant Distance Bias/d' $output_all &

done 
wait
for contig in $(cat $contig_file)
do
input=${wd}/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_HWE_strict.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_HWE_strict.vcf.gz
output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE_strict.vcf

bcftools convert -Oz -o ${output_all}.gz $output_all &
done
wait
for contig in $(cat $contig_file)
do
input=${wd}/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_HWE_strict.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_HWE_strict.vcf.gz
output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE_strict.vcf

tabix ${output_all}.gz &

done
