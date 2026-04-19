#!/usr/bin/env bash
set -euo pipefail

############################
# USER SETTINGS
############################

# Individuals
samples=(JC70 JC71 JC77 JC78 JC79 JC80 JC83 JC86 JC87 JC90 JC91 JC92 JC93 JC94 JC95 JC96 JC97 JC98)

# Paths
vcfdir=/home/pkalhori/Pooneh_data
chrom_list=/home/pkalhori/mywa_geo_autosomes_list.txt
workroot=/home/pkalhori/msmc
vcf_header=noindels_minGQ_minDP5_miss0.9

# Programs
msmc2=~/msmc2_Linux

# Parallelization
JOBS=8
MSMC_THREADS=4

############################
# FUNCTIONS
############################

process_chrom() {
    ind="$1"
    chrom="$2"
    vcfdir="$3"
    workdir="$4"
    vcf_header="$5"

    set -euo pipefail

    echo "[${ind}] chr${chrom} start"

    # Input / output paths
    vcf_in="${vcfdir}/${chrom}_${vcf_header}.vcf.gz"
    vcf_out="${vcfdir}/${vcf_header}/${ind}/${ind}_${chrom}_filtered.vcf.gz"
    parsed_vcf="${workdir}/vcf_${ind}_${chrom}_filtered.vcf.gz"
    mask1="${workdir}/mask_${ind}_${chrom}_filtered.bed.gz"
    mask2="/home/pkalhori/msmc/yewa_chr${chrom}.mask.bed.gz"
    multihet="${workdir}/${ind}_${chrom}_filtered_multihetsep.txt"

    echo "[${ind}] chr${chrom} reading ${vcf_in}"

    # Subset VCF to individual
    bcftools view \
      -s "${ind}" \
      "${vcf_in}" \
      -Oz -o "${vcf_out}"

    # Parse VCF and generate mask
    bcftools view "${vcf_out}" | \
      python /home/pkalhori/msmc/vcfparser.py \
        "${chrom}" \
        "${mask1}" | \
      gzip > "${parsed_vcf}"

    # Generate MSMC2 input
    python /home/pkalhori/msmc/generate_multihetsep_pk.py \
      --chr "${chrom}" \
      --mask "${mask1}" \
      --mask "${mask2}" \
      "${parsed_vcf}" \
      > "${multihet}"

    echo "[${ind}] chr${chrom} done"
}

export -f process_chrom

############################
# MAIN LOOP
############################

for ind in "${samples[@]}"; do

    echo "=============================="
    echo "Processing individual ${ind}"
    echo "=============================="

    # Output directories
    mkdir -p "${vcfdir}/${vcf_header}/${ind}"
    workdir="${workroot}/${vcf_header}/${ind}"
    mkdir -p "${workdir}"

    # Run chromosomes in parallel
    parallel -j "${JOBS}" \
      process_chrom "${ind}" {} "${vcfdir}" "${workdir}" "${vcf_header}" \
      :::: "${chrom_list}"

    # Build ordered MSMC2 input list
    multihetsep_files=$(awk '{print "'"${workdir}"'/'"${ind}"'_"$1"_filtered_multihetsep.txt"}' \
      "${chrom_list}")

    # Run MSMC2
    echo "Running MSMC2 for ${ind}"
    "${msmc2}" \
      -t "${MSMC_THREADS}" \
      -o "${workdir}/${ind}_filtered_autosomes" \
      ${multihetsep_files}

done

echo "ALL DONE"
