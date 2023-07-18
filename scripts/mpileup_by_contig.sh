#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

# set the directory path
contig_file=/home/pkalhori/cut_contigs.txt
all_contigs=()
while read p
do
all_contigs+=("${p}")
done < ~/cut_contigs.txt

contig_list=`echo ${all_contigs[*]}`


bwa_dir=/home/pkalhori/bwa
logdir=/home/pkalhori/logs/elprep
today_date=$(date +'%Y-%m-%d')

ref_fasta=/home/pkalhori/ncbi_dataset/data/GCA_024362935.1/GCA_024362935.1_bSetPet1.0.p_genomic.fna
all_bams=/home/pkalhori/mpileup/all_bams.list
# set the batch size
batch_size=20

# get the total number of files in the directory
#total_files=$(ls $dir_path | wc -l)
total_files=$(echo $contig_list | wc -w)
# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))

# loop through each batch
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for contig in $(cat $contig_file | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
  # launch a separate process for each file
#mpileup -Ou -f /home/pkalhori/ncbi_dataset/data/GCA_024362935.1/GCA_024362935.1_bSetPet1.0.p_genomic.fna -r JANCRA010000001.1 -o /home/pkalhor/mpileup/chr1_test.bcf -b some_bams.list
#bcftools mpileup -Ou -f $ref_fasta -r $contig -b $all_bams -o /home/pkalhori/mpileup/all_samples_contig_${contig}.bcf &
bcftools mpileup -Ou -f $ref_fasta -r $contig -b $all_bams | bcftools call -m -Ou -o /home/pkalhori/mpileup/calls/all_samples_calls_contig_${contig}.bcf &

done
  # wait for all processes in this batch to finish

wait
done
