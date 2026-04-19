#!/bin/bash
#set -euo pipefail

source ~/.bashrc
source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh
conda activate bwa_samtools_env

dir_path="/home/pkalhori/bwa_mywa_geo_W_yewa_mtDNA_alignment"

shopt -s nullglob
for file in "${dir_path}"/*/*_sorted.bam; do
    file_name=$(basename "$file")
    file_root="${file_name%.bam}"
    sample=$(basename "$(dirname "$file")")

    # Skip if already processed
    [[ -f "${dir_path}/${sample}/${file_root}_markdup.bam" ]] && continue

    sambamba markdup -t 16 "$file" "${dir_path}/${sample}/${file_root}_markdup.bam"
    sambamba flagstat -t 16 "${dir_path}/${sample}/${file_root}_markdup.bam" \
        > "${dir_path}/${sample}/${file_root}_markdup.flagstat"
done


