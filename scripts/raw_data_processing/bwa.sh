#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bwaenv

# set the directory path
reference_genome=/home/pkalhori/reference_genomes/yewa_reference_genome/ncbi_dataset/data/GCA_024362935.1/GCA_024362935.1_bSetPet1.0.p_genomic.fna
#reference_genome=/home/pkalhori/reference_genomes/mywa_reference_genome/ncbi_dataset/data/GCA_001746935.2/GCA_001746935.2_mywa_2.1_genomic.fna
#reference_genome=/home/pkalhori/reference_genomes/geothlypis_reference_genome/ncbi_dataset/data/GCA_009764595.1/GCA_009764595.1_bGeoTri1.pri_genomic.fna
#reference_genome=/home/pkalhori/reference_genomes/mywa_geo_W_reference_genome/mywa_geo_W_combined_genomic.fna
dir_path=/home/pkalhori/fastp/2023-11-06
bwa_dir=/home/pkalhori/bwa_yewa_alignment
today_date=$(date +'%Y-%m-%d')
logdir=/home/pkalhori/logs/${today_date}
mkdir -p $logdir
mkdir -p $bwa_dir


#bwa index $reference_genome &
#wait

# set the batch size
batch_size=2

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
mkdir -p ${bwa_dir}/${bird}
id=${bird}_CKDL230032797-1A_HGNKFDSX7_L2

ionice -c 3 bwa mem -M -t 8 \
$reference_genome \
${dir_path}/${bird}/${id}_1_clean.fq.gz ${dir_path}/${bird}/${id}_2_clean.fq.gz \
2> ${logdir}/bwa_${id}.err \
> $bwa_dir/${bird}/${id}_mywa_geo.sam &

done
  # wait for all processes in this batch to finish
wait
done

