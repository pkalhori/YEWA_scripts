#!/usr/bin/env bash
#SBATCH --job-name=smcpp_vcf2smc
#SBATCH --time=24:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=1
#SBATCH --output=smcpp_%A_%a.out
#SBATCH --error=smcpp_%A_%a.err
#SBATCH --array=1-30

set -euo pipefail

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh
conda activate smcpp

chroms=/home/pkalhori/mywa_geo_autosomes_list.txt
vcf=/home/pkalhori/Pooneh_data/autosomes_noindels_minGQ_minDP5_miss0.9_SNPs.vcf.gz
mask_dir=/home/pkalhori/smcpp/uncallable_masks
workdir=/home/pkalhori/smcpp

cd "$workdir"

chrom=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$chroms")
echo "Processing chromosome: $chrom"

############################################################
# 1. DEFINE FULL POPULATIONS (Background Panels)
############################################################
ISA=(JC70 JC71 JC77 JC78 JC79 JC80 JC83 JC86 JC87 JC90 JC91 JC92 JC93 JC94 JC95 JC96 JC97 JC98)
SAN=(JC105 JC108 JC116 JC119 JC120 JC121 JC122 JC123 JC125 JC127 JC131 KF6149 LF6101 LF6102 LF6119 LF6146 LF6148 PK01)
CRUZ=(JC64 JC65 JC66 JC67 JC68 JC69 LF6126 LF6127 LF6128 LF6129 LF6130 LF6131 LF6132 LF6134 LF6135 LF6137 LF6138 LF6139)

############################################################
# 2. DEFINE DISTINGUISHED INDIVIDUALS PER POPULATION
# (Pick your 3-5 best depth samples from each group)
############################################################
ISA_DL=(JC98 JC96 JC94)
SAN_DL=(JC119)
CRUZ_DL=(JC69 LF6131 JC67 LF6137)

############################################################
# 3. MODIFIED FUNCTION
############################################################
# $1: Label (e.g., SAN)
# $2: Space-separated string of Distinguished IDs
# $3: Space-separated string of ALL IDs (Background)
run_population_split () {
    local label=$1
    local dl_list=($2)
    local full_pop=($3)

    # Convert full pop array to comma-separated for SMC++
    local pop_string
    pop_string=$(IFS=,; echo "${full_pop[*]}")

    for ind in "${dl_list[@]}"; do
        echo "Running $label — DL: $ind — $chrom"

        smc++ vcf2smc \
            -d "$ind" "$ind" \
            --mask "${mask_dir}/${chrom}_mask.bed.gz" \
            "$vcf" \
            "${ind}_${chrom}_${label}.smc.gz" \
            "$chrom" \
            "${label}:${pop_string}"
    done
}

############################################################
# 4. EXECUTION
############################################################
# We pass the Label, the DL list, and then the Full list
#run_population_split "ISA" "${ISA_DL[*]}" "${ISA[*]}"
run_population_split "SAN" "${SAN_DL[*]}" "${SAN[*]}"
#run_population_split "CRUZ" "${CRUZ_DL[*]}" "${CRUZ[*]}"

echo "Finished chromosome $chrom"