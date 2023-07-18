# ################################################################################
# this R script will gather information about cleaned reads, set up directories for 
# bwa alignments,
# and initiate bwa-mem2 analyses on cleaned read files.
# 24 December 2021 Jack Dumbacher
# run by typing:
# Rscript --verbose --vanilla bwa.R

# note that if this isn't working correctly, check the bwa_fix_A1.R script
# for updates
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
d1 <-  list.files("/home/jdumbacher/pyrocephalus/clean/") # lists directories in /clean
dir_clean <-  list.files("/home/jdumbacher/pyrocephalus/clean", full.names= TRUE, include.dirs = TRUE) # lists directories with full path

#get a list of files in each directory
f1 <- list.files(paste0("/home/jdumbacher/pyrocephalus/clean/",d1), full.names=TRUE) 
f1 <- list.files(dir_clean, full.names=TRUE) # these two lines return the same things

# get the entire path plus the root name of each cleaned read set:
f2 <- gsub("_1\\.(.*)", "",f1, fixed=FALSE)
f2 <- gsub("_2\\.(.*)", "",f2, fixed=FALSE)
f2 <- gsub("_se\\.(.*)", "",f2, fixed=FALSE)
fn_reads <- unique(f2)

setwd("/home/jdumbacher/pyrocephalus/clean/")
fn_merged <- list.files(getwd(), "*.merged.fq.gz", recursive=TRUE, full.names=TRUE)

dir_aligned <- gsub("clean", "aligned",dir_clean, fixed=FALSE)

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
# input filenames will be given by fn_reads
# output directory names will be given by dir_aligned:

# create a command for bwa-mem for paired end read alignments:
cmd <- paste0("/home/mvandam/bwa-mem2-2.1_x64-linux/bwa-mem2.avx2 mem -t 32 -o ",
              dir_aligned,"/",d1,"_pe_out.sam ",idxbase," ", fn_reads,"_1.fq.gz ",fn_reads,"_2.fq.gz")

# run this for all samples
# lapply(cmd, system)

# create a command for bwa-mem for single-end reads (unpaired and merged reads)

# first we need to cat together all of the single read files:
cmd_catname <- paste0("zcat ",fn_reads,"_1.unpaired.fq.gz ",fn_reads,"_2.unpaired.fq.gz > ",fn_reads,"_se.fq.gz")
# lapply(cmd_catname, system)

# here are the twp bwa command for the se reads:
cmd1 <- paste0("/home/mvandam/bwa-mem2-2.1_x64-linux/bwa-mem2.avx2 mem -t 32 -o ",
               dir_aligned,"/",d1,"_se_out.sam ",idxbase," ",fn_reads,"_se.fq.gz")

cmd2 <- paste0("/home/mvandam/bwa-mem2-2.1_x64-linux/bwa-mem2.avx2 mem -t 32 -o ",
               dir_aligned,"/",d1,"_mrg_out.sam ",idxbase," ", fn_merged)

lapply(cmd1, system)
lapply(cmd2, system)
############################################################################
# align the se reads from each set 
###########################################################################
# build a list of files in the clean directory

listf <- list()
listf

for(i in 1:57) {
  listf[i] <- list(list.files(paste0("/home3/jdumbacher/pyrocephalus/clean/",d1[i]), full.names=FALSE))
  }

# listf


############################################################################
# combine both sam files:
###########################################################################
# first need to sort all of the sam files
# get a list of all .sam files
samfiles <- list.files(getwd(), ".sam", recursive=TRUE, full.names=TRUE)
samfiles_sorted <- gsub(".sam", "_sorted.sam",samfiles, fixed=FALSE)
cmd_sort <- paste0("samtools sort -o ",samfiles_sorted, " -O SAM -@ 4 ", samfiles)
# lapply(cmd_sort,system)

# samtools merge [options] -o out.bam [options] in1.bam ... inN.bam
setwd("/home/jdumbacher/pyrocephalus/aligned")
fn <- list.files(getwd(), "_se_out_sorted.sam", recursive=TRUE, full.names=TRUE)
# fn_done <- list.files(getwd(), "_sorted_combined.sam", recursive=TRUE, full.names=TRUE)

# get the entire path plus the root name of each sorted sam file:
f5 <- gsub("_se_out_sorted.sam", "", fn, fixed=TRUE)

cmd_merge <- paste0("samtools merge ",o3,"/",d1,"_sorted_combined.sam ",
                    f5,"_se_out_sorted.sam ",f5,"_pe_out_sorted.sam")

# lapply(cmd_merge,system)

############################################################################
# convert bam to sam
###########################################################################

cmd4 <-  paste0("samtools view -h -b -S ",o3,"_combined.sam > ", o3,"_combined.bam")

# lapply(cmd4, system)


