#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate mosdepth

# set the directory path
dir_path=/home/pkalhori/fastp/2023-01-25
bwa_dir=/home/pkalhori/bwa
logdir=/home/pkalhori/logs/samtools

# set the batch size
batch_size=11

# get the total number of files in the directory
total_files=$(ls $dir_path | wc -l)

# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))

# loop through each batch
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for bird in $(ls $dir_path | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
  # launch a separate process for each file
id=${bird}_CKDL220033076-1A_HTH3NDSX5_L3

cd ${bwa_dir}/${bird}

mosdepth -n ${id}_all_sorted ${bwa_dir}/${bird}/${id}_all_sorted.bam &

#samtools index ${bwa_dir}/${bird}/${id}_paired_sorted.bam &

#samtools sort -@ 4 ${bwa_dir}/${bird}/${id}_paired.bam -o ${bwa_dir}/${bird}/${id}_paired_sorted.bam &

#samtools view -@ 4 -b ${bwa_dir}/${bird}/${id}.sam > ${bwa_dir}/${bird}/${id}_paired.bam &
done
  # wait for all processes in this batch to finish
wait
done
#In this script, we first set the path to the directory that contains the files and the batch size. Then, we calculate the total number of files in the directory and use that to determine the number of batches.
#In each iteration of the outer loop, we launch a separate process for each file in the batch and wait for all processes in that batch to finish before moving on to the next batch.


