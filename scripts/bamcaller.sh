
chrom_file=/home/pkalhori/mywa_geo_chromosomes_list.txt
bams_list=/home/pkalhori/mpileup/all_bams_mywa_geo_alignment_reseq.list  
for bam in $(head -n27 $bams_list)
ind=$(echo "$bam" | awk -F'/' '{print $(NF-1)}')
do
depth_file=${ind}_depth.txt
for chrom in $(cat $chrom_file)
do
samtools depth -r $chrom $bam | awk '{sum += $3} END {print sum / NR}' >> depth_file
done

for 