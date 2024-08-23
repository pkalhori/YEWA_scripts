#!/bin/bash

chrom=$1
wd="/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq/depths"  # replace with your actual directory path

# Read the CSV file and calculate the number of iterations
num_iter=$((($(awk -F '\t' '{print $2}' "${wd}/chromosome_${chrom}_total_site_depth" | sort -nu | tail -n 1) + 9999) / 10000))

# Output column names
output_column_names=("window_pos_1" "window_pos_2" "mean_depth")

# Process each window using Awk
awk -v num_iter="$num_iter" -v window_size=10000 '
    BEGIN {
        OFS="\t"
        print "'$(IFS=,; echo "${output_column_names[*]}")'"
    }
    {
        pos = $2
        window_start = int((pos - 1) / window_size) * window_size + 1
        window_end = window_start + window_size - 1
        sum[window_start] += $3
        count[window_start]++
    }
    END {
        for (i = 0; i < num_iter; i++) {
            window_start = i * window_size + 1
            window_end = window_start + window_size - 1
            mean_depth = (count[window_start] > 0) ? sum[window_start] / count[window_start] : 0
            print window_start, window_end, mean_depth
        }
    }
' "${wd}/chromosome_${chrom}_total_site_depth"
