#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

contig_file=/home/pkalhori/mywa_geo_chromosomes_split_regions_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated


#cd /home/pkalhori/mpileup/calls_geothlypis_alignment
cd $wd

for contig in $(cat $contig_file)
do
input=${wd}/all_samples_reseq_chromosome_${contig}.vcf.gz
output_SNP=${wd}/all_samples_reseq_chromosome_${contig}_filtered_SNPs_HWE.vcf.gz
output_Monomorphic=${wd}/all_samples_reseq_chromosome_${contig}_filtered_Monomorphic_HWE.vcf.gz
output_all=${wd}/all_samples_reseq_chromosome_${contig}_filtered_allsites_HWE.vcf


MISS=0.9
QUAL=30
MIN_DEPTH=4
MAX_DEPTH=20

##Invariant Sites
vcftools --gzvcf $input --remove-indels --max-missing $MISS --minQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maxDP $MAX_DEPTH --max-maf 0 --recode --stdout | bgzip -c >  ${output_Monomorphic} &

##SNPs (biallelic only)
vcftools --gzvcf $input --remove-indels --max-missing $MISS --minQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maxDP $MAX_DEPTH --min-alleles 2 --max-alleles 2 --hwe 0.001 --recode --stdout | bgzip -c >  ${output_SNP} &

wait

tabix $output_SNP &
tabix $output_Monomorphic &

wait

bcftools concat --allow-overlaps $output_SNP $output_Monomorphic -Ov -o $output_all &

wait

sed -i '/Variant Distance Bias/d' $output_all &

wait

bcftools convert -Oz -o ${output_all}.gz $output_all &

wait

tabix ${output_all}.gz

done


