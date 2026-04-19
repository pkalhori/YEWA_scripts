#ISA

samples=(JC70 JC71 JC77 JC78 JC79 JC80 JC83 JC86 JC87 JC90 JC91 JC92 JC93 JC94 JC95 JC96 JC97 JC98)




for ind in ${samples}

do

for chrom in $(cat /home/pkalhori/mywa_geo_autosomes_list.txt)

do

mkdir -p ${vcfdir}/${ind}

bcftools view -s ${ind} ${vcfdir}/${chrom}_filtered_noIndels.vcf.gz -Oz -o ${vcfdir}/${ind}/${ind}_${chrom}_filtered.vcf.gz &

done

wait

for chrom in $(cat /home/pkalhori/mywa_geo_autosomes_list.txt)
do

mkdir -p /home/pkalhori/msmc/${ind}

cd /home/pkalhori/msmc/${ind}

zcat ${vcfdir}/${ind}/${ind}_${chrom}_filtered.vcf.gz | python /home/pkalhori/msmc/vcfparser.py ${chrom} mask_${ind}_${chrom}_filtered.bed.gz | gzip > vcf_${ind}_${chrom}_filtered.vcf.gz &

done

wait

for chrom in $(cat /home/pkalhori/mywa_geo_autosomes_list.txt)
do

python /home/pkalhori/msmc/generate_multihetsep_pk.py --chr ${chrom} --mask mask_${ind}_${chrom}_filtered.bed.gz --mask /home/pkalhori/msmc/yewa_chr${chrom}.mask.bed.gz vcf_${ind}_${chrom}_filtered.vcf.gz > ${ind}_${chrom}_filtered_multihetsep.txt &

done

wait

~/msmc2_Linux -o ${ind}_filtered_autosomes -t 2 ${ind}_*_multihetsep.txt &

wait

done

wait