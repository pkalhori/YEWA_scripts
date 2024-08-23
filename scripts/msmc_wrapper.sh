
#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

#vcfdir=/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated

vcfdir=/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/filtered_vcfs/SNPs_and_Monomorphic

samples='JC108 JC127 JC70 JC87 JC94 JC96 KF6149 LF6102 LF6126 LF6128 LF6129 LF6132 PK01'
#samples='LF6129 LF6128 LF6126 JC87 JC96 JC127 JC108 KF6149 LF6102 PK01'

for ind in ${samples}

do

for chrom in $(cat /home/pkalhori/mywa_geo_chromosomes_list.txt)

do

mkdir -p ${vcfdir}/${ind}

bcftools view -s ${ind} ${vcfdir}/all_samples_reseq_chromosome_${chrom}_filtered_2_with_Monomorphic.recode.vcf.gz -Oz -o ${vcfdir}/${ind}/${ind}_${chrom}_filtered.vcf.gz &

done

wait

for chrom in $(cat /home/pkalhori/mywa_geo_chromosomes_list.txt)
do

mkdir -p /home/pkalhori/msmc/${ind}_filteredvcf

cd /home/pkalhori/msmc/${ind}_filteredvcf

zcat ${vcfdir}/${ind}/${ind}_${chrom}_filtered.vcf.gz | python /home/pkalhori/msmc/vcfparser.py ${chrom} mask_${ind}_${chrom}_filtered.bed.gz | gzip > vcf_${ind}_${chrom}_filtered.vcf.gz &

done

wait

for chrom in $(cat /home/pkalhori/mywa_geo_chromosomes_list.txt)
do

python /home/pkalhori/msmc/generate_multihetsep_pk.py --chr ${chrom} --mask mask_${ind}_${chrom}_filtered.bed.gz  vcf_${ind}_${chrom}_filtered.vcf.gz > ${ind}_${chrom}_filtered_multihetsep.txt &

done

wait

#~/msmc2_Linux -o ${ind}_filtered -t 8 ${ind}_*_multihetsep.txt

#wait

done
