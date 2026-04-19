

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools


wd=/home/pkalhori/mpileup/calls_mywa_geo_reannotated



cd $wd

##basic filters
for contig in $(cat $contig_file)
do

bcftools filter -e 'FMT/DP<5' ${contig}.vcf.gz -S . -s LOWDP|bcftools filter -e 'FMT/DP>25' -S . -s HIGHDP|bcftools filter -e 'FMT/GQ<20.0' -S . -s LOWQUAL|bcftools filter -e 'FMT/SP>60.0' -S . -s STRANDBIAS| bcftools filter -e 'QUAL<20.0 || F_MISSING>0.1'  -Oz -o ${contig}_filtered.vcf.gz &

done


wait



##no indels
for contig in $(cat $contig_file)
do

bcftools filter ${contig}_filtered.vcf.gz -e 'TYPE=="indel"' --threads 2 -Oz -o ${contig}_filtered_noIndels.vcf.gz &

done

wait

##SNPs
for contig in $(cat $contig_file)
do

bcftools filter  ${contig}_filtered_noIndels.vcf.gz -i 'TYPE=="snp"' --threads 2 |bcftools view -e 'AC=AN' --threads 2 -Oz -o  ${contig}_filtered_SNPs.vcf.gz &

done
wait


##SNPs LD pruned
for contig in $(cat $contig_file)
do

bcftools +prune -m 0.8 -w 50kb  ${contig}_filtered_SNPs.vcf.gz  --threads 2 -Oz -o  ${contig}_filtered_SNPs_LD_pruned.vcf.gz &

done

wait

##SNPs with MAF
for contig in $(cat $contig_file)
do

bcftools view  ${contig}_filtered_SNPs.vcf.gz -q 0.05:minor -Oz -o  ${contig}_filtered_SNPs_MAF.vcf.gz &

done
