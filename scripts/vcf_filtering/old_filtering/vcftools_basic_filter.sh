source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

contig_file=/home/pkalhori/mywa_geo_chromosomes_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_reannotated


cd $wd

##basic filters
for contig in $(cat $contig_file)
do

#bcftools +setGT ${contig}.vcf.gz -- -t q -n . -i 'FMT/DP<5'| bcftools filter -e 'QUAL<20.0 || FORMAT/SP>60.0 || FORMAT/GQ<20.0 || F_MISSING>0.1'  -Oz -o ${contig}_filtered.vcf.gz &

MISS=0.9
QUAL=20
MIN_DEPTH=5
MAX_DEPTH=25

input=${contig}.vcf.gz
output_filtered=${contig}_filtered_vcftools.vcf.gz

vcftools --gzvcf $input  --max-missing $MISS --minQ $QUAL --minGQ $QUAL --min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH --minDP $MIN_DEPTH --maxDP $MAX_DEPTH --recode --stdout | bgzip -c >  ${output_filtered} &


done
wait
