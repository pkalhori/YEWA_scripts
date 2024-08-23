
#chrom_list=/home/pkalhori/mywa_geo_chromosomes_list.txt
chrom_list=/home/pkalhori/mywa_geo_chromosomes_list.txt
for chrom in $(cat $chrom_list)
do

bash /home/pkalhori/window_depth_with_header.sh $chrom > ${chrom}_filtered_with_Monomorphic_3_windowed_mean.depth &

done
