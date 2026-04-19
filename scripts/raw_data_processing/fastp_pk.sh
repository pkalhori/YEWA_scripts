#!/bin/bash

source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash
conda activate fastpenv
wd=/home/pkalhori/fastp
data_dir=/home/pkalhori/yewa_reseq_data/usftp21.novogene.com/01.RawData
cd $data_dir
#samples=`ls --ignore=*Undetermined`
#samples='JC77 JC78'
#samples='JC79 JC80'
#samples='JC105 JC108 JC116 JC119 JC120 JC121 JC122 JC123 JC125 JC127 JC131 JC64 JC65 JC66 JC67 JC68 JC69 JC70'
#samples='JC83 JC86 JC87 JC90 JC91 JC92 JC93 JC94 JC95 JC96 JC97 JC98 LF6135 LF6137 LF6138 LF6139 LF6146 LF6148 PK01'
#samples='KF6149 LF6101 LF6102 LF6119 LF6126 LF6127 LF6128 LF6129 LF6130 LF6131 LF6132 LF6134 JC71'
samples='JC94 JC125'
forward_adapter='AGATCGGAAGAGCACACGTCTGAACTCCAGTCA'
reverse_adapter='AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT'
cd $wd
rundate=`date +'%Y-%m-%d'`
mkdir -p $rundate
cd $wd/$rundate

for bird in $samples
do
forward_input=${data_dir}/${bird}/${bird}_CKDL230032797-1A_HGNKFDSX7_L2_1.fq.gz
reverse_input=${data_dir}/${bird}/${bird}_CKDL230032797-1A_HGNKFDSX7_L2_2.fq.gz
outdir=$wd/$rundate/$bird
outfile=$wd/$rundate/$bird/${bird}_output.txt
mkdir -p $outdir
forward_output=${outdir}/${bird}_CKDL230032797-1A_HGNKFDSX7_L2_1_clean.fq.gz
reverse_output=${outdir}/${bird}_CKDL230032797-1A_HGNKFDSX7_L2_2_clean.fq.gz
html_output=${outdir}/${bird}_CKDL230032797-1A_HGL2FDSX7_L2.html
unpaired_forward=${outdir}/${bird}_CKDL230032797-1A_HGNKFDSX7_L2_unpaired1.fq.gz
unpaired_reverse=${outdir}/${bird}_CKDL230032797-1A_HGNKFDSX7_L2_unpaired2.fq.gz
nohup fastp --in1 $forward_input --in2 $reverse_input --out1 $forward_output --out2 $reverse_output --unpaired1 $unpaired_forward --unpaired2 $unpaired_reverse --dedup --thread 16 --adapter_sequence=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA --adapter_sequence_r2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT --html $html_output > $outfile 2>&1 & 
done
