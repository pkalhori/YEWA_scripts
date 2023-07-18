#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bwaenv

# set the directory path
#reference_genome=/home/pkalhori/coronata_genome/ncbi_dataset/data/GCA_001746935.2/GCA_001746935.2_mywa_2.1_genomic.fna
#reference_genome=/home/pkalhori/geothlypis_reference_genome/ncbi_dataset/data/GCA_009764595.1/GCA_009764595.1_bGeoTri1.pri_genomic.fna
reference_genome=/home/pkalhori/reference_genomes/mywa_geo_W_reference_genome/mywa_geo_W_combined_genomic.fna
dir_path=/home/pkalhori/fastp/2023-01-25
bwa_dir=/home/pkalhori/bwa_mywa_geo_W_alignment
today_date=$(date +'%Y-%m-%d')
logdir=/home/pkalhori/logs/${today_date}
mkdir -p $logdir


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
id=${bird}_CKDL220033076-1A_HTH3NDSX5_L3

ionice -c 3 bwa mem -M -t 6 \
$reference_genome \
${dir_path}/${bird}/${id}_1_clean.fq.gz ${dir_path}/${bird}/${id}_2_clean.fq.gz \
2> ${logdir}/bwa_${id}.err \
> $bwa_dir/${bird}/${id}_mywa_geo.sam &

done
  # wait for all processes in this batch to finish
wait
done

