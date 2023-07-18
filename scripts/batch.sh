#!/bin/bash

# set the directory path
dir_path=/home/pkalhori/fastp/2023-01-25

# set the batch size
batch_size=11

# get the total number of files in the directory
total_files=$(ls $dir_path | wc -l)

# calculate the number of batches
num_batches=$(( (total_files + batch_size - 1) / batch_size ))

# loop through each batch
for ((batch=0; batch<num_batches; batch++)); do
  # loop through each file in the batch
  for file in $(ls $dir_path | head -n $((batch_size * (batch + 1))) | tail -n $batch_size); do
    # launch a separate process for each file
    (./process "$dir_path/$file") &
  done
  # wait for all processes in this batch to finish
  wait
done
