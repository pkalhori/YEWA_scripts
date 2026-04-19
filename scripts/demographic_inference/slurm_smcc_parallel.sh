#!/usr/bin/env bash
#SBATCH --job-name=smcpp_vcf2smc
#SBATCH --time=24:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=1
#SBATCH --output=smcpp_%A_%a.out
#SBATCH --error=smcpp_%A_%a.err
#SBATCH --array=1-30

set -euo pipefail

############################
# Conda
############################
source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh
conda activate smcpp

############################
# Paths
############################
chroms=/home/pkalhori/mywa_geo_autosomes_list.txt
vcf=/home/pkalhori/Pooneh_data/autosomes_noindels_minGQ_minDP5_miss0.9_SNPs.vcf.gz
mask_dir=/home/pkalhori/smcpp/uncallable_masks
workdir=/home/pkalhori/smcpp

cd "$workdir"

############################
# Chromosome for this task
############################
chrom=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$chroms")
echo "Processing chromosome: $chrom"

############################
# Populations
############################
ISA=(JC70 JC71 JC77 JC78 JC79 JC80 JC83 JC86 JC87 JC90 JC91 JC92 JC93 JC94 JC95 JC96 JC97 JC98)

SAN=(JC105 JC108 JC116 JC119 JC120 JC121 JC122 JC123 JC125 JC127 JC131 KF6149 LF6101 LF6102 LF6119 LF6146 LF6148 PK01)

CRUZ=(JC64 JC65 JC66 JC67 JC68 JC69 LF6126 LF6127 LF6128 LF6129 LF6130 LF6131 LF6132 LF6134 LF6135 LF6137 LF6138 LF6139)

ALL=("${ISA[@]}" "${SAN[@]}" "${CRUZ[@]}")
############################
# Function
############################
run_population () {
    local label=$1
    shift
    local pop=("$@")

    local pop_string
    pop_string=$(IFS=,; echo "${pop[*]}")

    for ((i=0; i<${#pop[@]}; i+=2)); do
        ind=${pop[i]}

        echo "Running $label — distinguished individual: $ind — $chrom"

        smc++ vcf2smc \
            -d "$ind" "$ind" \
            --mask "${mask_dir}/${chrom}_mask.bed.gz" \
            "$vcf" \
            "${ind}_${chrom}_${label}.smc.gz" \
            "$chrom" \
            "${label}:${pop_string}"
    done
}

############################
# Run all populations
############################
run_population ALL "${ALL[@]}"


echo "Finished chromosome $chrom"
