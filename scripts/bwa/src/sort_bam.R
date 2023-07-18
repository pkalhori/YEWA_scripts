# ################################################################################
# this R script will sort .bam files, so that picard can mark the duplicates
# or so that duplicates can be marked in Samtools...
# 
# 1 March 2022 Jack Dumbacher
# run by typing:
# Rscript --verbose --vanilla sort_bam.R
# ################################################################################

setwd("/home/jdumbacher/pyrocephalus/aligned/")
# library(tidyverse)
library(fs)
# library(here)
# library(ips) # for reading fasta, trees and nexus 
library(parallel) # allows you to execute jobs - takes lists and assigns processoers to items in lisr
# library(rlist)
# library(pipeR)


# ################################################################################
# step one: get names and full paths of aligned BAM files
# ################################################################################


# get a list of directories with cleaned data:
setwd("/home/jdumbacher/pyrocephalus/aligned/")
d1 <-  list.files(getwd())
d1 <- d1[-3]
d1_path <- paste0("/home/jdumbacher/pyrocephalus/aligned/",d1,"/")

#get a list of files in each directory - these will have the full path included:
f1 <- list.files(paste0("/home/jdumbacher/pyrocephalus/aligned/",d1), full.names=TRUE)
# filter for only the combined bam files:  
f1_bam <- f1[grepl("combined.bam", f1, fixed=TRUE)]

# Then, get a list of all raw read files to process: f1 are forward reads, f2 are reverse reads:
setwd("/home/jdumbacher/pyrocephalus/aligned/")
f2 <- list.files(getwd(), ".*combined.bam", recursive=TRUE, full.names=TRUE)
f2 <- gsub("home3", "home",f2, fixed=FALSE)


# build the output filenames - this gives full long filenames
# f2_out <- gsub("_combined.bam", "_combined_sorted.bam",f2, fixed=FALSE)

# this is preferred if everything lines up
f2_out <- paste0(getwd(),"/",d1,"/",d1, "_combined_sorted.bam")

############################################################################
# sort bamfile
###########################################################################
# samtools sort [-l level] [-u] [-m maxMem] [-o out.bam] [-O format] [-M] [-K kmerLen] [-n] [-t tag] [-T tmpprefix] [-@ threads] [in.sam|in.bam|in.cram]



cmd <- paste0("samtools sort -o ",f2_out, " -O BAM -@ 4 ", f2)

# run this for all samples
lapply(cmd[1:2], system)

# or to speed up and run several at a time, can use mclapply:
# mclapply(cmd, system, mc.cores=getOption("mc.cores", 8))  # do only once; it only allows 8 processes to run simultaneously
