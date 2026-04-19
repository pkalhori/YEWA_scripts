#! /bin/bash


source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate easySFS
#bgzip=/u/home/a/ab08028/klohmueldata/annabel_data/bin/tabix-0.2.6/bgzip
#todaysdate=20240829
todaysdate=`date +%Y%m%d`
outdir=/home/pkalhori/easySFS/projection-${todaysdate}

vcfdir=/home/pkalhori/Pooneh_data
snpVCF=autosomes_noindels_minGQ_minDP8_miss0.9_SNPs_LD50kbR0.8.vcf.gz  
scriptdir=/home/pkalhori/github_repos/YEWA_scripts/scripts
#vcfdir=/u/project/rwayne/software/rails/VCF_FILES
#pops=/u/home/p/pkalhori/project-klohmueldata/pooneh_data/github_repos/otter_exome/galapagos_rails/pinta.PCA.txt
pops="SAN, CRUZ, ISA"
#pops="ALL"
popFile=/home/pkalhori/easySFS/pops_file.txt
# this has admixed in it , but they aren't in pop file
easySFS=/home/pkalhori/bin/easySFS/easySFS.py

#Preview
$easySFS -i $vcfdir/${snpVCF} -p $popFile -a -v --preview --total-length 878767939 -o $outdir
# -f forces overwrite of outdir
# $bgzip ${vcf}
# then do for SYN and MIS (eventually)
########## get counts of monomorphic sites to add to the SFSes ############
#python $scriptdir/getMonomorphicProjectionCounts.1D.2DSFS.py --vcf $vcfdir/${allVCF} --popMap $popFile --proj 30,30,30 --popIDs SAN,CRUZ,ISA --outdir $outdir
