

all_files=/home/pkalhori/mpileup/calls_yewa_alignment_reseq/all_monomorphic_SNPs.list

# set the batch size
batch_size=49

# get the total number of files in the directory
#total_files=$(ls $dir_path | wc -l)
total_files=$(cat $all_files | wc -w)
# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))

# loop through each batch
for ((batch=0; batch<num_batches; batch++))
do
  # loop through each file in the batch
for file in $(cat $all_files | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
  # launch a separate process for each file
tabix ${file}.gz &
done
  # wait for all processes in this batch to finish

wait
done