#!/usr/bin/env bash
#SBATCH --job-name=msmc
#SBATCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --mem=40G
#SBATCH --output=/home/pkalhori/logs/msmc_%x_%j.out
#SBATCH --error=/home/pkalhori/logs/msmc_%x_%j.err

set -euo pipefail

############################
# INPUT
############################

ind="$1"

############################
# USER SETTINGS
############################

vcfdir=/home/pkalhori/Pooneh_data
chrom_list=/home/pkalhori/mywa_geo_autosomes_list.txt
workroot=/home/pkalhori/msmc
vcf_header=noindels_minGQ_minDP5_miss0.9

msmc2=~/msmc2_Linux

JOBS=12
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

    vcf_in="${vcfdir}/${chrom}_${vcf_header}.vcf.gz"
    vcf_out="${vcfdir}/${vcf_header}/${ind}/${ind}_${chrom}_filtered.vcf.gz"
    parsed_vcf="${workdir}/vcf_${ind}_${chrom}_filtered.vcf.gz"
    mask1="${workdir}/mask_${ind}_${chrom}_filtered.bed.gz"
    mask2="/home/pkalhori/msmc/yewa_chr${chrom}.mask.bed.gz"
    multihet="${workdir}/${ind}_${chrom}_filtered_multihetsep.txt"

    ############################
    # Subset VCF
    ############################

    if [[ -f "${vcf_out}" ]]; then
        echo "[${ind}] chr${chrom} subset VCF exists, skipping"
    else
        bcftools view \
          -s "${ind}" \
          "${vcf_in}" \
          -Oz -o "${vcf_out}"
    fi

    ############################
    # Parse VCF
    ############################

    if [[ -f "${parsed_vcf}" ]]; then
        echo "[${ind}] chr${chrom} parsed VCF exists, skipping"
    else
        bcftools view "${vcf_out}" | \
          python /home/pkalhori/msmc/vcfparser.py \
            "${chrom}" \
            "${mask1}" | \
          gzip > "${parsed_vcf}"
    fi

    ############################
    # MSMC input
    ############################

    if [[ -f "${multihet}" ]]; then
        echo "[${ind}] chr${chrom} multihetsep exists, skipping"
    else
        python /home/pkalhori/msmc/generate_multihetsep_pk.py \
          --chr "${chrom}" \
          --mask "${mask1}" \
          --mask "${mask2}" \
          "${parsed_vcf}" \
          > "${multihet}"
    fi

    echo "[${ind}] chr${chrom} done"
}

export -f process_chrom

############################
# MAIN
############################

echo "Processing individual ${ind}"

mkdir -p logs
mkdir -p "${vcfdir}/${vcf_header}/${ind}"

workdir="${workroot}/${vcf_header}/${ind}"
mkdir -p "${workdir}"

################################
# Skip chromosome work if done
################################

all_multihet_exist=true

while read chrom; do
    f="${workdir}/${ind}_${chrom}_filtered_multihetsep.txt"
    if [[ ! -f "$f" ]]; then
        all_multihet_exist=false
        break
    fi
done < "${chrom_list}"

if [[ "$all_multihet_exist" = true ]]; then
    echo "All multihetsep files exist for ${ind}, skipping chromosome processing"
else
    parallel -j "${JOBS}" \
      process_chrom "${ind}" {} "${vcfdir}" "${workdir}" "${vcf_header}" \
      :::: "${chrom_list}"
fi

################################
# MSMC2
################################

multihetsep_files=$(awk '{print "'"${workdir}"'/'"${ind}"'_"$1"_filtered_multihetsep.txt"}' \
"${chrom_list}")

echo "Running MSMC2 for ${ind}"


# Convert -p pattern into a filename-safe string
time_pattern="1*2+12*2+1*2"
pattern_label=$(echo "$time_pattern" | sed 's/\*/x/g; s/+/_/g')

# Include date in the output prefix (optional, useful for multiple reruns)
run_date=$(date +%Y%m%d)

# Final MSMC output prefix
outprefix="${workdir}/${ind}_p${pattern_label}_${run_date}"

"${msmc2}" \
  -t "${MSMC_THREADS}" \
  -p "${time_pattern}" \
  -o "${outprefix}" \
  ${multihetsep_files}

echo "Finished ${ind}"