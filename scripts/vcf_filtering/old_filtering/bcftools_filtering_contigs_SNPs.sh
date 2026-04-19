

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

wd=/home/pkalhori/mpileup/calls_yewa_alignment_reseq

# set the batch size
batch_size=49

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
input=${wd}/all_samples_calls_contig_${contig}.vcf.gz
output=${wd}/all_samples_calls_contig_${contig}_filtered.vcf.gz


bcftools filter -i 'TYPE=="snp" && MIN(DP)>100 && MAX(DP)<1500 && QUAL>30' -Ou ${input}|bcftools filter -e 'F_MISSING>0.1' -Ou|bcftools view -m2 -M2 -Ou |bcftools view -q 0.05:minor -Ov|cat|perl /home/pkalhori/bin/vcf2minmq.pl 20|bcftools convert -Oz -o $output &

done
  # wait for all processes in this batch to finish

wait
done

