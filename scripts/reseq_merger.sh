source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

contig_file=/home/pkalhori/mywa_geo_chromosomes_split_regions_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_alignment


#cd /home/pkalhori/mpileup/calls_geothlypis_alignment
cd $wd

for contig in $(cat $contig_file)
do
A=${wd}/reseq/all_samples_chromosome_${contig}.vcf.gz
B=${wd}/reseq/all_samples_chromosome_${contig}_reseq_removed.vcf.gz

merged=${wd}/reseq/all_samples_chromosome_${contig}_reseq_merged.vcf.gz

#bcftools view $input  -s ^JC125,JC94 -Oz -o $output &

bcftools merge $A $B -Oz -o $merged &

#bcftools index $A &
#bcftools index $B &

done
