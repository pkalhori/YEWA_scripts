
#vcf=/home/pkalhori/mpileup/calls_coronata_alignment/all_samples_autosomes_filtered_maxdepth.vcf.gz
vcf=/home/pkalhori/mpileup/calls_mywa_geo_alignment/SNPs_only/all_chromosomes_filtered.vcf.gz
popdir=/home/pkalhori/sample_info

pop=$1

pop1_file=$popdir/${pop}_Highland.txt


pop2_file=$popdir/${pop}_Lowland.txt

window_size=$2

window_step=$3

outdir=/home/pkalhori/vcftools_Fst/mywa_geo_alignment

output=${pop}_${window_size}

cd $outdir

vcftools --gzvcf $vcf --weir-fst-pop $pop1_file --weir-fst-pop $pop2_file --fst-window-size $window_size --fst-window-step $window_step --out $output
