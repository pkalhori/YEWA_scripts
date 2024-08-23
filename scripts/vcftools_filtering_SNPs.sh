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
output=${wd}/all_samples_reseq_chromosome_${contig}_filtered_no_MAF
#bcftools filter -i 'TYPE=="snp" && MIN(DP)>5 && QUAL>30' -Ou all_samples_chromosome_${contig}.vcf.gz|bcftools filter -e 'F_MISSING>0.1' -Ou|bcftools view -m2 -M2 -Oz -o all_samples_chromosome_${contig}_filtered_biallelic.vcf.gz &



#bcftools filter -i 'TYPE=="snp" && MIN(DP)>100 && MAX(DP)<1500 && QUAL>30' -Ou ${input}|bcftools filter -e 'F_MISSING>0.1' -Ou|bcftools view -m2 -M2 -Ou |bcftools view -q 0.05:minor -Ov|cat|perl /home/pkalhori/bin/vcf2minmq.pl 20|bcftools convert -Oz -o $output &

#MAF=0.05
MISS=0.9
QUAL=30
MIN_DEPTH=4
MAX_DEPTH=25

vcftools --gzvcf $input --remove-indels --max-missing $MISS --minQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maxDP $MAX_DEPTH --min-alleles 2 --max-alleles 2 --recode --out $output &
done


