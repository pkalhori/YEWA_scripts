#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

wd=/home/pkalhori/mpileup/calls_yewa_alignment
#for i in {0..48} 
#do
chunk=$(expr $i + 1)
#bcftools concat -f ${wd}/batch_${i}.txt -Oz -o ${wd}/all_samples_chunk_${chunk}.vcf.gz &
#done


for i in {0..48} 
do
chunk=$(expr $i + 1)

output=${wd}/all_samples_chunk_${chunk}_filtered.vcf.gz
input_MQ=${wd}/all_samples_chunk_${chunk}_filtered_MQ20.vcf

bcftools convert $input_MQ -Oz -o $output &

done
