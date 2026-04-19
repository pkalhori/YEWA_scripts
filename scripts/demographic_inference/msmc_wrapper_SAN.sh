
#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

vcfdir=/home/pkalhori/mpileup/calls_mywa_geo_reannotated


#SAN

samples="JC105 JC108 JC116 JC119 JC120 JC121 JC122 JC123 JC125 JC127 JC131 KF6149 LF6101 LF6102 LF6119 LF6146 LF6148 PK01"


for ind in ${samples}
do
    
    mkdir -p ${vcfdir}/${ind}
    mkdir -p /home/pkalhori/msmc/${ind}
    cd /home/pkalhori/msmc/${ind}

    for chrom in $(cat /home/pkalhori/mywa_geo_autosomes_list.txt); do
        (
        bcftools view -s ${ind} ${vcfdir}/${chrom}_filtered_noIndels.vcf.gz -Oz -o ${vcfdir}/${ind}/${ind}_${chrom}_filtered.vcf.gz
        zcat ${vcfdir}/${ind}/${ind}_${chrom}_filtered.vcf.gz | python /home/pkalhori/msmc/vcfparser.py ${chrom} mask_${ind}_${chrom}_filtered.bed.gz | gzip > vcf_${ind}_${chrom}_filtered.vcf.gz
        python /home/pkalhori/msmc/generate_multihetsep_pk.py --chr ${chrom} --mask mask_${ind}_${chrom}_filtered.bed.gz --mask /home/pkalhori/msmc/yewa_chr${chrom}.mask.bed.gz vcf_${ind}_${chrom}_filtered.vcf.gz > ${ind}_${chrom}_filtered_multihetsep.txt
        ) &
        
    done
    

wait

~/msmc2_Linux -o ${ind}_filtered_autosomes -t 2 ${ind}_*_multihetsep.txt 

done