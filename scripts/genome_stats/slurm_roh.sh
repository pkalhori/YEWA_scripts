#!/usr/bin/env bash
#SBATCH --job-name=roh
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=04:00:00
#SBATCH --array=1-30
#SBATCH --output=roh_%A_%a.out
#SBATCH --error=roh_%A_%a.err

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate bcftools

# or activate conda if needed
# source activate myenv

#################################
# INPUTS
#################################

chrom_list=/home/pkalhori/mywa_geo_autosomes_list.txt  
vcf_dir=/home/pkalhori/Pooneh_data

out_dir=/home/pkalhori/bcftools_roh

mkdir -p "$out_dir"

#################################
# GET CHROMOSOME FOR THIS TASK
#################################

chrom=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$chrom_list")

vcf="${vcf_dir}/${chrom}_noindels_minGQ_minDP5_miss0.9_SNPs.recode.vcf"
out="${out_dir}/${chrom}.roh.txt"

echo "Processing $chrom"
echo "VCF: $vcf"

#################################
# RUN ROH
#################################

bcftools roh \
    --AF-dflt 0.4 \
    "$vcf" \
    -o "$out"

echo "Finished $chrom"
