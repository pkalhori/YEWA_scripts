#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate elprep
# set the directory path
dir_path=/home/pkalhori/fastp/2023-01-25
bwa_dir=/home/pkalhori/bwa
logdir=/home/pkalhori/logs/elprep
today_date=$(date +'%Y-%m-%d')
mkdir -p $logdir/${today_date}
wd=/home/pkalhori/elprep
ref_fasta=/home/pkalhori/ncbi_dataset/data/GCA_024362935.1/GCA_024362935.1_bSetPet1.0.p_genomic.elfasta
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

mkdir -p $wd/$bird
cd $wd/$bird

input=${bwa_dir}/${bird}/${id}_paired_sorted_readgroups.bam
output=$wd/$bird/${id}_paired_filtered.bam
metrics=${id}.metrics
recal=${id}.recal
vcf=${id}.vcf

nohup elprep filter $input $output --mark-duplicates -mark-optical-duplicates $metrics --sorting-order coordinate --bqsr $recal --reference $ref_fasta --haplotypecaller $vcf > $logdir/${today_date}/${bird}_output.txt 2>&1 &
#elprep filter $input output.bam --mark-duplicates -mark-optical-duplicates output.metrics --sorting-order coordinate --bqsr output.recal --reference $elfasta --haplotypecaller output.vcf
done
  # wait for all processes in this batch to finish
wait
done
#In this script, we first set the path to the directory that contains the files and the batch size. Then, we calculate the total number of files in the directory and use that to determine the number of batches.
#In each iteration of the outer loop, we launch a separate process for each file in the batch and wait for all processes in that batch to finish before moving on to the next batch.


