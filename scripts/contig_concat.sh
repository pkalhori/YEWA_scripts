wd=/home/pkalhori/mpileup/calls_yewa_alignment
for i in {0..48} 
do
chunk=$(expr $i + 1)
bcftools concat -f ${w}/batch_${i}.txt -Oz -o ${wd}/all_samples_chunk_${chunk}.vcf.gz &
done
