#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

# set the directory path
contig_file=/home/pkalhori/mywa_geo_chromosomes_split_regions_list.txt
all_contigs=()
#while read p
#do
#all_contigs+=("${p}")
#done < ~/cut_contigs.txt

#contig_list=`echo ${all_contigs[*]}`


bwa_dir=/home/pkalhori/bwa

today_date=$(date +'%Y-%m-%d')

#ref_fasta=/home/pkalhori/ncbi_dataset/data/GCA_024362935.1/GCA_024362935.1_bSetPet1.0.p_genomic.fna
#ref_fasta=/home/pkalhori/reference_genomes/coronata_reference_genome/ncbi_dataset/data/GCA_001746935.2/GCA_001746935.2_mywa_2.1_genomic.fna
#ref_fasta=/home/pkalhori/reference_genomes/geothlypis_reference_genome/ncbi_dataset/data/GCA_009764595.1/GCA_009764595.1_bGeoTri1.pri_genomic.fna
ref_fasta=/home/pkalhori/reference_genomes/mywa_geo_W_reference_genome/mywa_geo_W_combined_genomic.fna 
#all_bams=/home/pkalhori/mpileup/all_bams_mywa_geo_alignment.list
all_bams=/home/pkalhori/mpileup/all_bams_mywa_geo_alignment_reseq.list
# set the batch size
batch_size=39

# get the total number of files in the directory
#total_files=$(ls $dir_path | wc -l)
total_files=$(cat $contig_file | wc -l)
# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))

# loop through each batch
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for contig in $(cat $contig_file | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
  # launch a separate process for each file
#mpileup -Ou -f /home/pkalhori/ncbi_dataset/data/GCA_024362935.1/GCA_024362935.1_bSetPet1.0.p_genomic.fna -r JANCRA010000001.1 -o /home/pkalhor/mpileup/chr1_test.bcf -b some_bams.list

bcftools mpileup -Ou -f $ref_fasta -a FORMAT/AD,FORMAT/DP,FORMAT/SP,INFO/AD -r $contig -b $all_bams | bcftools call -m -Oz -o /home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/all_samples_reseq_chromosome_${contig}.vcf.gz &

#bcftools mpileup -Ou -f $ref_fasta -r $chr_id -b $all_bams | bcftools call -m -Ou -o /home/pkalhori/mpileup/calls/all_samples_calls_contig_${chr_name}.bcf &
#echo $contig

done
  # wait for all processes in this batch to finish
#echo "batch"
wait
done
