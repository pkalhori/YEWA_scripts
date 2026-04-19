#!/usr/bin/env bash
set -euo pipefail

# CRUZ

samples=(JC64 JC65 JC66 JC67 JC68 JC69 LF6126 LF6127 LF6128 LF6129 LF6130 LF6131 LF6132 LF6134 LF6135 LF6137 LF6138 LF6139)

vcfdir=/home/pkalhori/Pooneh_data
chrom_list=/home/pkalhori/mywa_geo_autosomes_list.txt
msmc_bin=~/msmc2_Linux

for ind in "${samples[@]}"; do

    echo "Processing ${ind}"

    mkdir -p "${vcfdir}/${ind}"
    workdir="/home/pkalhori/msmc/${ind}"
    mkdir -p "${workdir}"
    cd "${workdir}"

    multihetsep_files=()

    while read -r chrom; do
        echo "  Chromosome ${chrom}"

        # Step 1: subset VCF to individual
        bcftools view \
          -s "${ind}" \
          "${vcfdir}/${chrom}_noindels_minGQ_minDP4_miss0.8.vcf.gz" \
          -Oz -o "${vcfdir}/${ind}/${ind}_${chrom}_filtered.vcf.gz"

        # Step 2: parse VCF
        bcftools view "${vcfdir}/${ind}/${ind}_${chrom}_filtered.vcf.gz" | \
          python /home/pkalhori/msmc/vcfparser.py \
            "${chrom}" \
            "mask_${ind}_${chrom}_filtered.bed.gz" | \
          gzip > "vcf_${ind}_${chrom}_filtered.vcf.gz"

        # Step 3: generate multihetsep
        python /home/pkalhori/msmc/generate_multihetsep_pk.py \
          --chr "${chrom}" \
          --mask "mask_${ind}_${chrom}_filtered.bed.gz" \
          --mask "/home/pkalhori/msmc/yewa_chr${chrom}.mask.bed.gz" \
          "vcf_${ind}_${chrom}_filtered.vcf.gz" \
          > "${ind}_${chrom}_filtered_multihetsep.txt"

        multihetsep_files+=("${ind}_${chrom}_filtered_multihetsep.txt")

    done < "${chrom_list}"

    # Step 4: run MSMC2 (ordered chromosomes!)
    echo "Running MSMC2 for ${ind}"

    "${msmc_bin}" \
      -t 2 \
      -o "${ind}_filtered_autosomes" \
      "${multihetsep_files[@]}"

done
