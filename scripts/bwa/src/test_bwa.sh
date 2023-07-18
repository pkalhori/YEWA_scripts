#!/bin/bash

# this script will run an alignment with our reference genome using bwa-mem version 2.XXXX
# Usage: bwa-mem2 mem [options] <idxbase> <in1.fq> [in2.fq]

idxbase="/home/jdumbacher/pyrocephalus/hic_scaffold/hifiasm_tst1/vf_asm.bp.p_ctg.FINAL.fasta"

echo idxbase

in1="~/pyrocephalus⁩/Illumina_data⁩/15_nov_2021/raw_data/BL1_CKDL210023087-1a_HYG7LDSX2_L1_1"

in2="~/pyrocephalus⁩/Illumina_data⁩/15_nov_2021/raw_data/BL1_CKDL210023087-1a_HYG7LDSX2_L1_2.fq.gz"

bwa-mem2 mem -o test_run -t 64 $idxbase \
   <(gunzip2 -c $in1) \
   <(gunzip2 -c  $in2)

