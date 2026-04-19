#!/bin/bash
source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate smcpp

chroms=/home/pkalhori/mywa_geo_autosomes_list.txt
vcf=/home/pkalhori/Pooneh_data/autosomes_noindels_minGQ_minDP4_miss0.9_SNPs.recode.vcf
#vcf=/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/SNPs_no_MAF_VCFs/all_samples_autosomes_filtered_SNPs_2025.vcf.gz
##ISA
pop=(JC70 JC71 JC77 JC78 JC79 JC80 JC83 JC86 JC87 JC90 JC91 JC92 JC93 JC94 JC95 JC96 JC97 JC98)

cd /home/pkalhori/smcpp

printf -v joined '%s,' "${pop[@]}"
pop_list="echo "${joined%,}""

#loop through every other individual as distinguished individual to get 9
for i in {0..17..2}

do

ind=${pop[i]}

for chrom in $(cat $chroms)

do


smc++ vcf2smc -d ${ind} ${ind} --mask ~/smcpp/uncallable_masks/${chrom}_mask.bed.gz ${vcf} ${ind}_${chrom}_ISA.smc.gz $chrom ISA:JC70,JC71,JC77,JC78,JC79,JC80,JC83,JC86,JC87,JC90,JC91,JC92,JC93,JC94,JC95,JC96,JC97,JC98 &
done

wait

done

wait

##SAN
pop2=(JC105 JC108 JC116 JC119 JC120 JC121 JC122 JC123 JC125 JC127 JC131 KF6149 LF6101 LF6102 LF6119 LF6146 LF6148 PK01)

printf -v joined '%s,' "${pop2[@]}"
pop_list2="echo "${joined%,}""

##loop through every other individual as distinguished individual to get 9
for i in {0..17..2}

do

ind=${pop2[i]}

for chrom in cat $(cat $chroms)

do


smc++ vcf2smc -d ${ind} ${ind} --mask ~/smcpp/uncallable_masks/${chrom}_mask.bed.gz ${vcf} ${ind}_${chrom}_SAN.smc.gz $chrom SAN:JC105,JC108,JC116,JC119,JC120,JC121,JC122,JC123,JC125,JC127,JC131,KF6149,LF6101,LF6102,LF6119,LF6146,LF6148,PK01 &
done

wait

done

wait

#CRUZ
pop3=(JC64 JC65 JC66 JC67 JC68 JC69 LF6126 LF6127 LF6128 LF6129 LF6130 LF6131 LF6132 LF6134 LF6135 LF6137 LF6138 LF6139)

printf -v joined '%s,' "${pop3[@]}"
pop_list3="echo "${joined%,}""

##loop through every other individual as distinguished individual to get 9
for i in {0..17..2}

do

ind=${pop3[i]}

for chrom in cat $(cat $chroms)

do


smc++ vcf2smc -d ${ind} ${ind} --mask ~/smcpp/uncallable_masks/${chrom}_mask.bed.gz ${vcf} ${ind}_${chrom}_CRUZ.smc.gz $chrom CRUZ:JC64,JC65,JC66,JC67,JC68,JC69,LF6126,LF6127,LF6128,LF6129,LF6130,LF6131,LF6132,LF6134,LF6135,LF6137,LF6138,LF6139 &
done

wait

done
