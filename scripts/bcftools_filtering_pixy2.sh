#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

contig_file=/home/pkalhori/mywa_geo_chromosomes_split_regions_autosomes_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_alignment


#cd /home/pkalhori/mpileup/calls_geothlypis_alignment
cd $wd

for contig in $(cat $contig_file)
do
input=${wd}/all_samples_chromosome_${contig}.vcf.gz
output=${wd}/all_samples_chromosome_${contig}_filtered_with_Monomorphic_temp.vcf.gz
#bcftools filter -i 'TYPE=="snp" && MIN(DP)>5 && QUAL>30' -Ou all_samples_chromosome_${contig}.vcf.gz|bcftools filter -e 'F_MISSING>0.1' -Ou|bcftools view -m2 -M2 -Oz -o all_samples_chromosome_${contig}_filtered_biallelic.vcf.gz &



#bcftools filter -i 'TYPE=="snp" && MIN(DP)>100 && MAX(DP)<1500 && QUAL>30' -Ou ${input}|bcftools filter -e 'F_MISSING>0.1' -Ou|bcftools view -m2 -M2 -Ou |bcftools view -q 0.05:minor -Oz -o ${output} &

bcftools filter -i 'MIN(DP)>100 && MAX(DP)<1500 && QUAL>30' ${input} -Ou|bcftools filter -e 'F_MISSING>0.1' -Ou|bcftools filter -e 'TYPE=="indel"' -Ou|bcftools view -m1 -M2 -Oz -o ${output} &

done

wait

for contig in $(cat $contig_file)
do


output=${wd}/all_samples_chromosome_${contig}_filtered_with_Monomorphic_temp.vcf.gz
output_MQ=${wd}/all_samples_chromosome_${contig}_filtered_with_Monomorphic_MQ20.vcf

zcat $output | perl /home/pkalhori/bin/vcf2minmq.pl 20 > $output_MQ &


done



#for contig in $(cat $contig_file)
#do


#output=${wd}/all_samples_chromosome_${contig}_filtered_with_Monomorphic_MQ20.vcf.gz
#input_MQ=${wd}/all_samples_chromosome_${contig}_filtered_with_Monomorphic_MQ20.vcf

#bcftools convert $input_MQ -Oz -o $output &

#done
