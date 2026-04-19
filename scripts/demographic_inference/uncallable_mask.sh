#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

vcf_dir=~/mpileup/calls_mywa_geo_alignment_reseq_annotated/unfiltered_VCFs

ref=~/smcpp/mywa_geo_W_combined_genomic.fna.fai

chroms=~/mywa_geo_autosomes_list.txt

mkdir -p ~/smcpp/uncallable_masks


for chrom in $(cat $chroms)
do

bedtools complement -i  ${vcf_dir}/all_samples_reseq_chromosome_${chrom}.vcf.gz -g ~/smcpp/mywa_geo_W_combined_genomic.fna.fai -L >  ~/smcpp/uncallable_masks/${chrom}_mask.bed 

done
