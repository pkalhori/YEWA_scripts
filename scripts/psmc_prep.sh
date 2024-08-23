
#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

c


for chrom in $(cat mywa_geo_chromosomes_list.txt)
do
samtools mpileup -C50 -uf $ref_genome -r $chrom $bam | bcftools view -c - | /home/pkalhori/bin/samtools/bcftools/vcfutils.pl vcf2fq -d 2 -D 25 | gzip > diploid_${ind}_${chrom}.fq.gz &
done
