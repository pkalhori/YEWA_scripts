#!/bin/bash
set -euo pipefail

source ~/.bashrc
source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh
conda activate bwa_samtools_env

reference_genome=/home/pkalhori/reference_genomes/mywa_geo_W_mtDNA_yewa_ref/mywa_geo_W_yewa_mtna.fna
dir_path=/home/pkalhori/fastp_nodedup/2025-08-12
bwa_dir=/home/pkalhori/bwa_mywa_geo_W_yewa_mtDNA_alignment
logdir=/home/pkalhori/logs/$(date +'%Y-%m-%d')

mkdir -p "$logdir" "$bwa_dir"

max_parallel=10
pids=()   # Array to track background job PIDs

shopt -s nullglob
for fwd in "${dir_path}"/*/*_1_clean.fq.gz; do
    filename=$(basename "$fwd")
    sample="${filename%%_*}"
    lane_id="${filename#${sample}_}"
    lane_id="${lane_id%%_1_clean.fq.gz}"
    rev="${fwd/_1_clean.fq.gz/_2_clean.fq.gz}"

    mkdir -p "${bwa_dir}/${sample}"

    RG="@RG\tID:${lane_id}\tSM:${sample}\tPL:ILLUMINA\tLB:lib1\tPU:${lane_id}"

    echo "Aligning ${lane_id} for sample ${sample} with read group ${RG}..."

    (
        bwa mem -M -t 6 -R "$RG" "$reference_genome" "$fwd" "$rev" 2> "${logdir}/bwa_${lane_id}.err" \
        | samtools sort -@ 4 -o "${bwa_dir}/${sample}/${sample}_${lane_id}_sorted.bam"
        samtools index "${bwa_dir}/${sample}/${sample}_${lane_id}_sorted.bam"
    ) &

    pids+=($!)   # Store PID of this background job

    # Wait for all running jobs if max_parallel is reached
    if (( ${#pids[@]} >= max_parallel )); then
        for pid in "${pids[@]}"; do wait "$pid"; done
        pids=()   # Reset array
    fi
done

# Wait for any remaining background jobs
for pid in "${pids[@]}"; do wait "$pid"; done

# Merge BAMs per sample
echo "Merging BAMs per sample..."
for sample_dir in "${bwa_dir}"/*; do
    sample=$(basename "$sample_dir")
    bam_files=("${sample_dir}"/*_sorted.bam)

    if (( ${#bam_files[@]} > 1 )); then
        samtools merge -@ 4 "${bwa_dir}/${sample}/${sample}_merged.bam" "${bam_files[@]}"
        samtools index "${bwa_dir}/${sample}/${sample}_merged.bam"
    else
        mv "${bam_files[0]}" "${bwa_dir}/${sample}/${sample}_merged.bam"
        mv "${bam_files[0]}.bai" "${bwa_dir}/${sample}/${sample}_merged.bam.bai"
    fi
done

echo "All done!"


for sample_dir in "${bwa_dir}"/*
do     
sample=$(basename "$sample_dir")
bam_files=("${sample_dir}"/*_sorted.bam)
if (( ${#bam_files[@]} > 1 )); then
echo "there are multiple bams: ${bam_files[@]}"
else 
echo "this is the only bam: ${bam_files[0]}"
fi
done