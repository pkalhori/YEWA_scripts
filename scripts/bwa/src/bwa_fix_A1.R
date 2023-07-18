# bwa_fix_A1.R
# ################################################################################
# this R script will gather information about cleaned reads, set up directories for 
# bwa alignments,
# and initiate bwa-mem2 analyses on cleaned read files.
# 24 December 2021 Jack Dumbacher
# run by typing:
# Rscript --verbose --vanilla bwa_fix_A1.R
# ################################################################################

setwd("/home/jdumbacher/pyrocephalus")
# library(tidyverse)
library(fs)
# library(here)
# library(ips) # for reading fasta, trees and nexus 
library(parallel) # allows you to execute jobs - takes lists and assigns processoers to items in lisr


# ################################################################################
# step one: get names and full paths of raw read files
# ################################################################################

# get a list of directories with cleaned data:
d1 <- list.files("/home/jdumbacher/pyrocephalus/clean/")
d1_fn <-  list.files("/home/jdumbacher/pyrocephalus/clean", full.names= TRUE, include.dirs = TRUE)
d3 <- list.files("/home/jdumbacher/pyrocephalus/Illumina_data/14_jan_2022/usftp21.novogene.com/raw_data/")
d3 <- d3[-13]

#get a list of files in each directory
f1 <- list.files(paste0("/home/jdumbacher/pyrocephalus/clean/",d1), full.names=TRUE) 
f1 <- list.files(d1_fn, full.names=TRUE) 


# get the entire path plus the root name of each cleaned read set:
f2 <- gsub("_1\\.(.*)", "",f1, fixed=FALSE)
f2 <- gsub("_2\\.(.*)", "",f2, fixed=FALSE)
f2 <- gsub("_se\\.(.*)", "",f2, fixed=FALSE)
f3 <- unique(f2)

f3

setwd("/home/jdumbacher/pyrocephalus/")
# dir.create("aligned") #do once  - like mkdir and can overwrite, so BE CAREFUL!
# Creating directories if not already created ----------------
if ((dir.exists("aligned")) == FALSE) {
  dir.create("aligned")
}


# create subdirectories for aligned illumina output from bwa-mem:
# do this only once (but make sure that all are present)
setwd("/home/jdumbacher/pyrocephalus/aligned/")
# dir_create(d1)  # do this only once so that it does not overwrite previous outputs

# set the idxbase for bwa-mem:
idxbase <- "/home/jdumbacher/pyrocephalus/hic_scaffold/hifiasm_tst1/vf_asm.bp.p_ctg.FINAL.fasta"
# input filenames will be given by f3
# output filenames will be given by o3:
o3 <- gsub("/clean/", "/aligned/", d1_fn, fixed=TRUE)
o3

# create a command for bwa-mem for paired end read alignments:
cmd <- paste0("/home/mvandam/bwa-mem2-2.1_x64-linux/bwa-mem2.avx2 mem -t 32 -o ",o3,"/",d1,"_pe_out.sam ",idxbase," ",  
              f3,"_1.fq.gz ",f3,"_2.fq.gz")

# run this for all samples
lapply(cmd[1:2], system)

# create a command for bwa-mem for single-end reads (unpaired and merged reads)

# first we need to cat together all of the single read files:

cmd_catname <- paste0("cat ",f3,"_1.merged.fq.gz ",f3,"_1.unpaired.fq.gz ",f3,"_2.unpaired.fq.gz > ",f3,"_se.fq.gz")
lapply(cmd_catname[1:2], system)

# here is the bwa command for the se reads:
cmd2 <- paste0("/home/mvandam/bwa-mem2-2.1_x64-linux/bwa-mem2.avx2 mem -t 32 -o ",
               o3,"/",d1,"_se_out.sam ",idxbase," ",f3,"_se.fq.gz")

lapply(cmd2[1:2], system)
############################################################################
# align the se reads from each set 
###########################################################################
# build a list of files in the clean directory

listf <- list()
listf

for(i in 1:45) {
  listf[i] <- list(list.files(paste0("/home3/jdumbacher/pyrocephalus/clean/",d1[i]), full.names=FALSE))
}

listf


############################################################################
# convert bam to sam
###########################################################################

# combine both sam files:

cmd3 <- paste0("cat ",o3,"/",d1,"_pe_out.sam ",o3,"/",d1,"_se_out.sam > ",o3,"_combined.sam")

lapply(cmd3[1:2],system)

cmd4 <-  paste0("samtools view -h -b -S ",o3,"/",d1,"_combined.sam > ", o3,"/",d1,"_combined.bam")

lapply(cmd4[1:2], system)


