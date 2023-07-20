
vcf=/home/pkalhori/mpileup/calls_mywa_geo_alignment/all_autosomes_filtered.vcf.gz

popdir=/home/pkalhori/sample_info

pop1=Santa_Cruz_Highland

pop1_file=$popdir/${pop1}.txt

pop2=Santa_Cruz_Lowland

pop2_file=$popdir/${pop2}.txt

window_size=$1

window_step=$2

outdir=/home/pkalhori/vcftools_Fst/calls_mywa_geo_alignment

output=${pop1}_vs_${pop2}

vcftools --gzvcf $vcf --weir-fst-pop $pop1_file --weir-fst-pop $pop2_file --fst-window-size $window_size --fst-window-step $window_step --out $output