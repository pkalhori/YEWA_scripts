#! /bin/bash


source ~/.bashrc

source /home/pkalhori/bin/miniconda3/etc/profile.d/conda.sh

conda init bash

conda activate easySFS
#bgzip=/u/home/a/ab08028/klohmueldata/annabel_data/bin/tabix-0.2.6/bgzip
#todaysdate=20240829
todaysdate=`date +%Y%m%d`


vcfdir=/home/pkalhori/Pooneh_data
scriptdir=/home/pkalhori/github_repos/YEWA_scripts/scripts
#vcfdir=/u/project/rwayne/software/rails/VCF_FILES
#pops=/u/home/p/pkalhori/project-klohmueldata/pooneh_data/github_repos/otter_exome/galapagos_rails/pinta.PCA.txt
pops="SAN, CRUZ, ISA"
#pops="ALL"
popFile=/home/pkalhori/easySFS/pops_file.txt
# this has admixed in it , but they aren't in pop file
easySFS=/home/pkalhori/bin/easySFS/easySFS.py

#gitdir=/u/home/p/pkalhori/project-klohmueldata/pooneh_data/github_repos/otter_exome/galapagos_rails



#easySFS=$scriptdir/easySFS.abModified.3.noInteract.Exclude01Sites.HetFiltering.20181121.py  # this is my modification
# this version of script excludes sites that are 0-1 across all populations (maybe) -- not sure if it does yet. 

## choose your projections: choosing for no
projections='30,30,30'
#projections='30'
### NOTE: projection values must be in same order as populations are in your popFile (this isn't ideal -- at some point I am going to modify the easySFS script)
# note that order is CA,AK,AL,COM,KUR 

outdir=/home/pkalhori/easySFS/projection-${todaysdate}
#snpVCFdir=/u/scratch/pkalhori/rails/snpVCFs
mkdir -p $outdir
#mkdir -p $snpVCFdir
# had to modify easySFS so that it wouldn't prompt a "yes/no" response about samples that are missing from VCF file
# write projection choices into a readme

#echo "SAN, CRUZ, ISA" < : $projections  > $outdir/projectionValues.txt
echo "ALL" < : $projections  > $outdir/projectionValues.txt
# make sure vcf isn't zipped

#allVCF=autosomes_filtered_allsites_no_triallelic.vcf
#extract only SNPs
#snpVCF=all_chroms_filtered_SNPs_allHets_removed.vcf.gz

##LD pruned vcf
snpVCF=autosomes_noindels_minGQ_minDP5_miss0.9_SNPs_LD50kbR0.8.vcf.gz  
#bcftools view -c 1:minor ${vcfdir}/${allVCF} > ${snpVCFdir}/${snpVCF}


### NOTE: projection values must be in same order as populations are in your popFile (this isn't ideal -- at some point I am going to modify the easySFS script)
# note that order is CA,AK,AL,COM,KUR 

##add in -l option for monomprphic bin
$easySFS -i $vcfdir/${snpVCF} -p $popFile -a -v --proj 30,30,30 -f --total-length  271851851 -o $outdir

#Preview
#$easySFS -i $vcfdir/${snpVCF} -p $popFile -a -v --preview --total-length 159494419 -o $outdir
# -f forces overwrite of outdir
# $bgzip ${vcf}
# then do for SYN and MIS (eventually)
########## get counts of monomorphic sites to add to the SFSes ############
#python $scriptdir/getMonomorphicProjectionCounts.1D.2DSFS.py --vcf $vcfdir/${allVCF} --popMap $popFile --proj 30,30,30 --popIDs SAN,CRUZ,ISA --outdir $outdir
