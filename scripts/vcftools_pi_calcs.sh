
#vcf=/home/pkalhori/mpileup/calls_coronata_alignment/all_samples_autosomes_filtered_maxdepth.vcf.gz
vcf=/home/pkalhori/mpileup/calls_mywa_geo_alignment/SNPs_only/all_chromosomes_filtered.vcf.gz
popdir=/home/pkalhori/sample_info

pop=$1

pop_file=$popdir/${pop}.txt


window_size=$2

window_step=$3

outdir=/home/pkalhori/vcftools_Fst/mywa_geo_alignment

output=${pop}_${window_size}

cd $outdir

vcftools --gzvcf $vcf --keep $pop_file --window-pi $window_size --window-pi-step $window_step --out $output
