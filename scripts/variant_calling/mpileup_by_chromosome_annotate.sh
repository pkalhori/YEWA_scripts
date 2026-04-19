#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

# set the directory path
contig_file=/home/pkalhori/mywa_geo_chromosomes_list.txt


today_date=$(date +'%Y-%m-%d')


ref_fasta=/home/pkalhori/reference_genomes/mywa_geo_W_ref/mywa_geo_W_combined_genomic.fna 

all_bams=/home/pkalhori/mpileup/all_bams_mywa_geo_alignment_reseq.list
# set the batch size
batch_size=32

# get the total number of files in the directory

total_files=$(cat $contig_file | wc -l)
# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))

# loop through each batch
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for contig in $(cat $contig_file | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
  # launch a separate process for each file



#old calling
##bcftools mpileup -Ou -f $ref_fasta -a FORMAT/AD,FORMAT/DP,FORMAT/SP,INFO/AD -r $contig -b $all_bams | bcftools call -m -Oz -o /home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/all_samples_reseq_chromosome_${contig}.vcf.gz &

#calling with mapping quality filter
bcftools mpileup -Ou -f $ref_fasta -a FORMAT/AD,INFO/AD,FORMAT/ADF,INFO/ADF,FORMAT/ADR,INFO/ADR,FORMAT/DP,FORMAT/SP --threads 2 -r $contig -b $all_bams  -d 250 -q 20 -Q 20|bcftools call --samples-file /home/pkalhori/sample_info/samples_sex_bcftools.txt --ploidy-file ~/ploidy_file.txt -m -a FORMAT/GQ,FORMAT/GP -Oz -o /home/pkalhori/mpileup/calls_mywa_geo_reannotated/${contig}.vcf.gz &


done
  # wait for all processes in this batch to finish
#echo "batch"
wait
done
