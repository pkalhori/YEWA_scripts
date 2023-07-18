wd=/home/pkalhori/bwa

all_birds=$(ls $wd)

all_bams=()

for bird in $all_birds
do
bam=${wd}/${bird}/${bird}_CKDL220033076-1A_HTH3NDSX5_L3_paired_sorted_readgroups.bam
echo ${bam}\ >> all_bams.list
#all_bams+=("${bam}")
done

#bam_list=`echo ${all_bams[*]}`

#echo $bam_list

#for i in ${all_bams[*]}
#do
#echo $i 
#done



