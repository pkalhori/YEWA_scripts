#!/usr/bin/env bash
#SBATCH --job-name=msmc
#SBATCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --mem=64G
#SBATCH --output=/home/pkalhori/logs/msmc_%x_%A_%a.out
#SBATCH --error=/home/pkalhori/logs/msmc_%x_%A_%a.err

set -euo pipefail

############################
# INPUT (Handled by Array)
############################
# Path to your existing sample list (54 individuals)
SAMPLE_FILE="/home/pkalhori/sample_info/all_samples.txt"

# Grabs the specific individual for THIS array task ID
ind=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_FILE}")

# Quick exit if the line is empty (prevents crashes on blank lines)
if [[ -z "${ind}" ]]; then
    echo "Error: No individual found for Array ID ${SLURM_ARRAY_TASK_ID}"
    exit 1
fi

############################
# USER SETTINGS
############################
vcfdir="/home/pkalhori/Pooneh_data"
chrom_list="/home/pkalhori/mywa_geo_autosomes_list.txt"
workroot="/home/pkalhori/msmc"
vcf_header="noindels_minGQ_minDP5_miss0.9"
msmc2=~/msmc2_Linux

# RESOURCE BALANCING
# We have 16 CPUS. 'parallel' launches several pipes (bcftools + python).
# JOBS=6 uses ~12-15 active threads, leaving 1-4 for system I/O.
JOBS=6 
MSMC_THREADS=16

############################
# FUNCTIONS
############################
process_chrom() {
    local ind="$1"
    local chrom="$2"
    local vcfdir="$3"
    local workdir="$4"
    local vcf_header="$5"

    set -euo pipefail

    echo "[${ind}] chr${chrom} starting..."

    vcf_in="${vcfdir}/${chrom}_${vcf_header}.vcf.gz"
    vcf_out="${vcfdir}/${vcf_header}/${ind}/${ind}_${chrom}_filtered.vcf.gz"
    parsed_vcf="${workdir}/vcf_${ind}_${chrom}_filtered.vcf.gz"
    mask1="${workdir}/mask_${ind}_${chrom}_filtered.bed.gz"
    mask2="/home/pkalhori/msmc/yewa_chr${chrom}.mask.bed.gz"
    multihet="${workdir}/${ind}_${chrom}_filtered_multihetsep.txt"

    # 1. Subset VCF for this individual
    if [[ ! -f "${vcf_out}" ]]; then
        mkdir -p "$(dirname "${vcf_out}")"
        bcftools view -s "${ind}" "${vcf_in}" -Oz -o "${vcf_out}"
    fi

    # 2. Parse VCF (Generates individual mask1)
    if [[ ! -f "${parsed_vcf}" ]]; then
        bcftools view "${vcf_out}" | \
          python /home/pkalhori/msmc/vcfparser.py "${chrom}" "${mask1}" | \
          gzip > "${parsed_vcf}"
    fi

    # 3. Generate Multihetsep (Uses mask1 and reference mask2)
    if [[ ! -f "${multihet}" ]]; then
        python /home/pkalhori/msmc/generate_multihetsep_pk.py \
          --chr "${chrom}" \
          --mask "${mask1}" \
          --mask "${mask2}" \
          "${parsed_vcf}" > "${multihet}"
    fi
}
export -f process_chrom

############################
# MAIN EXECUTION
############################
echo "Processing individual: ${ind} (Array Task ID: ${SLURM_ARRAY_TASK_ID})"

workdir="${workroot}/${vcf_header}/${ind}"
mkdir -p "${workdir}" logs

# Run Chromosome processing in Parallel
# Limits to 6 concurrent chromosomes to stay within 16-core allocation
parallel -j "${JOBS}" \
  process_chrom "${ind}" {} "${vcfdir}" "${workdir}" "${vcf_header}" \
  :::: "${chrom_list}"

# --- SANITY CHECK ---
# Build file list and ensure they are NOT empty to prevent Floating Point Exception
multihetsep_files=""
while read -r chrom; do
    f="${workdir}/${ind}_${chrom}_filtered_multihetsep.txt"
    if [[ ! -s "$f" ]]; then
        echo "ERROR: ${f} is missing or empty! Multihetsep generation failed."
        exit 1
    fi
    multihetsep_files+="${f} "
done < "${chrom_list}"

################################
# MSMC2 CALCULATION
################################
echo "Running MSMC2 for ${ind} using 16 threads"

# Stable pattern for 300k year colonization events
time_pattern="1*2+12*2+1*2"
pattern_label=$(echo "$time_pattern" | sed 's/\*/x/g; s/+/_/g')
outprefix="${workdir}/${ind}_p${pattern_label}_$(date +%Y%m%d)"

# Final MSMC2 run
"${msmc2}" \
  -t "${MSMC_THREADS}" \
  -p "${time_pattern}" \
  -o "${outprefix}" \
  ${multihetsep_files}

echo "Finished ${ind} successfully."