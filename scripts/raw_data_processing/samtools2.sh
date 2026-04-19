#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate samtools

dir_path=/home/pkalhori/fastp/2023-11-06

bwa_dir=/home/pkalhori/bwa_yewa_alignment
today_date=$(date +'%Y-%m-%d')
logdir=/home/pkalhori/logs/${today_date}
mkdir -p $logdir

batch_size=2
total_files=$(ls --ignore=A5 $dir_path | wc -l)
# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))


####Convert Sam to Bam Files
# loop through each batch
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for bird in $(ls --ignore=A5 $dir_path | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do

id=${bird}_CKDL230032797-1A_HGNKFDSX7_L2_mywa_geo
#JC105_CKDL220033076-1A_HTH3NDSX5_L3_mywa_geo_readgroups.sam
samtools view -@ 4 -b ${bwa_dir}/${bird}/${id}_readgroups.sam > ${bwa_dir}/${bird}/${id}.bam &

done
wait

done


####Sort Bam Files
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for bird in $(ls --ignore=A5 $dir_path | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do

id=${bird}_CKDL230032797-1A_HGNKFDSX7_L2_mywa_geo

samtools sort -@ 4 ${bwa_dir}/${bird}/${id}.bam -o ${bwa_dir}/${bird}/${id}_sorted.bam &

done
wait

done


###Index Files
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for bird in $(ls --ignore=A5 $dir_path | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do

id=${bird}_CKDL230032797-1A_HGNKFDSX7_L2_mywa_geo

samtools index ${bwa_dir}/${bird}/${id}_sorted.bam &

done
wait


done
