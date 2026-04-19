contig_file=/home/pkalhori/mywa_geo_chromosomes_list.txt

wd=/home/pkalhori/mpileup/calls_mywa_geo_reannotated


cd $wd

##basic filters
for contig in $(cat $contig_file)
do
reference=/home/pkalhori/reference_genomes/mywa_geo_W_ref/mywa_geo_W_combined_genomic.fna



file=${contig}_filtered_vcftools.vcf.gz  


bcftools stats -F $reference -s- $file  > ${contig}_filtered_bcftoolsStats.vchk &

done
