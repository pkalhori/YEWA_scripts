#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

# set the directory path
contig_file=/home/pkalhori/yewa_contigs_list.txt
all_contigs=()
while read p
do
all_contigs+=("${p}")
done < ~/yewa_contigs_list.txt

contig_list=`echo ${all_contigs[*]}`


today_date=$(date +'%Y-%m-%d')
ref_fasta=/home/pkalhori/reference_genomes/yewa_reference_genome/ncbi_dataset/data/GCA_024362935.1/GCA_024362935.1_bSetPet1.0.p_genomic.fna
all_bams=/home/pkalhori/mpileup/all_bams_yewa_alignment.list
# set the batch size
batch_size=30

# get the total number of files in the directory
#total_files=$(ls $dir_path | wc -l)
total_files=$(echo $contig_list | wc -w)
# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))

# loop through each batch
#for ((batch=0; batch<num_batches; batch++))
#do
  # loop through each file in the batch
#for contig in $(cat $contig_file | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
  # launch a separate process for each file

#bcftools mpileup -Ou -f $ref_fasta -r $contig -b $all_bams | bcftools call -m -Oz -o /home/pkalhori/mpileup/calls_yewa_alignment_reseq/all_samples_calls_contig_${contig}.vcf.gz &
bcftools mpileup -Ou -f $ref_fasta -a FORMAT/AD,FORMAT/DP,FORMAT/SP,INFO/AD -r CM044545.1 -b $all_bams | bcftools call -m -ploidy 1 -Oz -o /home/pkalhori/mpileup/calls_yewa_alignment_reseq/all_samples_mt_dna.vcf.gz
#done
  # wait for all processes in this batch to finish

#wait
#done
