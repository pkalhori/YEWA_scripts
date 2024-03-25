#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate pixy

islands='isabela santacruz sancristobal'

window=10000

contigs_file=/home/pkalhori/yewa_contigs_list.txt


for island in $islands
do
batch_size=14
total_files=$(cat $contigs_file | wc -w)
num_batches=$(( (total_files + batch_size - 1) / batch_size ))
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
#for contig in $(cat $contigs_file | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
for contig in $(cat $contigs_file | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
  # launch a separate process for each file
vcf=/home/pkalhori/mpileup/calls_yewa_alignment_reseq/all_samples_calls_contig_${contig}_filtered_with_Monomorphic.vcf.gz 
pixy --stats dxy fst pi --vcf $vcf --window_size $window --output_folder /home/pkalhori/pixy/yewa --output_prefix ${island}_${window}_${contig} --populations /home/pkalhori/pixy/${island}.txt & 

done
  # wait for all processes in this batch to finish

wait
done
done
