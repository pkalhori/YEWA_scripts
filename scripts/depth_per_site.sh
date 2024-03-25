#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

contig_file=/home/pkalhori/mywa_geo_chromosomes_split_regions_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq


#cd /home/pkalhori/mpileup/calls_geothlypis_alignment
cd $wd

for contig in $(cat $contig_file)
do
input=${wd}/all_samples_reseq_chromosome_${contig}_filtered_with_Monomorphic.vcf.gz
output=${wd}/depths/chromosome_${contig}_total_site_depth
bcftools query -f '%CHROM\t%POS\t%DP\n' $input > $output &


done




