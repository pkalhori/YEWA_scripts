#!/bin/bash
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
# CPUs (local)
############################
NCPU=16   # set this to how many cores you want to use

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
        echo "Running $label — distinguished individual: $ind"

        export ind label pop_string vcf mask_dir

        parallel -j "$NCPU" smc++ vcf2smc \
            -d "$ind" "$ind" \
            --mask "${mask_dir}/{1}_mask.bed.gz" \
            "$vcf" \
            "${ind}_{1}_${label}.smc.gz" \
            {1} \
            "${label}:${pop_string}" \
            :::: "$chroms"
    done
}

############################
# Populations
############################
ISA=(JC70 JC71 JC77 JC78 JC79 JC80 JC83 JC86 JC87 JC90 JC91 JC92 JC93 JC94 JC95 JC96 JC97 JC98)
SAN=(JC105 JC108 JC116 JC119 JC120 JC121 JC122 JC123 JC125 JC127 JC131 KF6149 LF6101 LF6102 LF6119 LF6146 LF6148 PK01)
CRUZ=(JC64 JC65 JC66 JC67 JC68 JC69 LF6126 LF6127 LF6128 LF6129 LF6130 LF6131 LF6132 LF6134 LF6135 LF6137 LF6138 LF6139)

############################
# Run
############################
run_population ISA "${ISA[@]}"
#run_population SAN "${SAN[@]}"
#run_population CRUZ "${CRUZ[@]}"

echo "All smc++ vcf2smc jobs completed."
