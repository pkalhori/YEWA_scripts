#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate samtools

# set the directory path
dir_path=/home/pkalhori/fastp/2023-01-25
bwa_dir=/home/pkalhori/bwa_mywa_geo_W_alignment
#ref_fasta=/home/pkalhori/ncbi_dataset/data/GCA_024362935.1/GCA_024362935.1_bSetPet1.0.p_genomic.elfasta
# set the batch size
batch_size=9

# get the total number of files in the directory
#total_files=$(ls $dir_path | wc -l)
total_files=$(ls --ignore=A5 $dir_path | wc -l)
# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))

# loop through each batch
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for bird in $(ls --ignore=A5 $dir_path | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
  # launch a separate process for each file
id=${bird}_CKDL220033076-1A_HTH3NDSX5_L3

cd ${bwa_dir}/${bird}
#JC70_CKDL220033076-1A_HTH3NDSX5_L3_chr_sorted.bam
input=${bwa_dir}/${bird}/${id}_mywa_geo_sorted.bam   

output_idx=${bwa_dir}/$bird/${id}.idxstats
output_flagstat=${bwa_dir}/$bird/${id}_flagstat.txt

samtools idxstats $input > $output_idx &
samtools flagstat $input > $output_flagstat &
#samtools flagstat JC119_CKDL220033076-1A_HTH3NDSX5_L3_paired_sorted.bam > JC119_paired_flagstat.txt
#nohup COMMAND > output_file 2>&1 &

done
  # wait for all processes in this batch to finish
wait
done
#In this script, we first set the path to the directory that contains the files and the batch size. Then, we calculate the total number of files in the directory and use that to determine the number of batches.
#In each iteration of the outer loop, we launch a separate process for each file in the batch and wait for all processes in that batch to finish before moving on to the next batch.


