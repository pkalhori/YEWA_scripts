# ################################################################################
# this R script will read information about raw reads, set up directories for QC reports,
# and initiate fastp analyses on raw read files.
# 22 December 2021 Jack Dumbacher
# run by typing:
# Rscript --verbose --vanilla fastp.R
# ################################################################################

setwd("/home/jdumbacher/pyrocephalus")
# library(tidyverse)
library(fs)
library(here)
# library(ips) # for reading fasta, trees and nexus 
library(parallel) # allows you to execute jobs - takes lists and assigns processoers to items in lisr


# ################################################################################
# step one: get names and full paths of raw read files
# ################################################################################

# dir.create("clean") #do once  - like mkdir and can overwrite, so BE CAREFUL!

# create subdirectories for cleaned illumina output from fastp:
d1 <- list.files("/home3/jdumbacher/pyrocephalus/Illumina_data/21_dec_2021/usftp21.novogene.com/raw_data/")
d2 <- list.files("/home3/jdumbacher/pyrocephalus/Illumina_data/15_nov_2021/raw_data/")
d3 <- list.files("/home3/jdumbacher/pyrocephalus/Illumina_data/14_jan_2022/usftp21.novogene.com/raw_data/")

d1 <- d1[-39] # these will be the directory names; the last element is a filename, and should be deleted
d2 <- d2[-8]  # these will be the directory names; the last element is a filename, and should be deleted
d3 <- d3[-13] # these will be the directory names; the last element is a filename, and should be deleted

intersect(d1,d2)
intersect(d1,d3)  # before running the following steps, we want to ensure that we will not be overwriting previous datasets
intersect(d2,d3)  # before running the following steps, we want to ensure that we will not be overwriting previous datasets

# these suggest that there is already an A1 dataset, so we will rename this one A1_2
# d3[1] <- "A1_2"  # this was done manually for the source directory in the raw_reads folder so that downstream steps would work smoothly

#create the directories here - do this only once (but make sure that all are present)
setwd("/home/jdumbacher/pyrocephalus/clean/")
getwd()
# dir_create(d1)  # do this only once so that it does not overwrite previous outputs
# dir_create(d2)  # do this only once so that it does not overwrite previous outputs
# dir_create(d3)  # do this only once so that it does not overwrite previous outputs
# note that I am getting an error at this step...


# build the scripts:

# note - by setting the directory to only one folder of illumina 
# data here (eg "/home/jdumbacher/pyrocephalus/Illumina_data/14_jan_2022")
# it will only process that folder of data.  To run fastp on ALL of the data, 
# use a shallower folder (eg "/home/jdumbacher/pyrocephalus/Illumina_data/") that 
# includes all of the illumina data in its subfolders
setwd("/home/jdumbacher/pyrocephalus/Illumina_data/14_jan_2022")


# Then, get a list of all raw read files to process: f1 are forward reads, f2 are reverse reads:
f1 = list.files(getwd(), ".*_1.fq.gz", recursive=TRUE, full.names=TRUE)
f2 = list.files(getwd(), ".*_2.fq.gz", recursive=TRUE, full.names=TRUE)

# correct the names for the root pathname:
f1 <- gsub("/home3/", "/home/",f1, fixed=TRUE)
f2 <- gsub("/home3/", "/home/",f2, fixed=TRUE)

# Create names for various output files:
c1 <- gsub("/pyrocephalus/Illumina_data/15_nov_2021/raw_data/", "/pyrocephalus/clean/", f1, fixed=TRUE)
c1 <- gsub("/pyrocephalus/Illumina_data/21_dec_2021/usftp21.novogene.com/raw_data/", "/pyrocephalus/clean/", c1, fixed=TRUE )
c1 <- gsub("/pyrocephalus/Illumina_data/14_jan_2022/usftp21.novogene.com/raw_data/", "/pyrocephalus/clean/", c1, fixed=TRUE )

c2 <- gsub("/pyrocephalus/Illumina_data/15_nov_2021/raw_data/", "/pyrocephalus/clean/", f2, fixed=TRUE )
c2 <- gsub("/pyrocephalus/Illumina_data/21_dec_2021/usftp21.novogene.com/raw_data/", "/pyrocephalus/clean/", c2, fixed=TRUE )
c2 <- gsub("/pyrocephalus/Illumina_data/14_jan_2022/usftp21.novogene.com/raw_data/", "/pyrocephalus/clean/", c2, fixed=TRUE )

 
c1u <-  gsub(".fq.gz", ".unpaired.fq.gz", c1, fixed=TRUE)
c2u <-  gsub(".fq.gz", ".unpaired.fq.gz", c2, fixed=TRUE)

m <- gsub(".unpaired.fq.gz", ".merged.fq.gz", c1u, fixed=TRUE)

htmlrep <-  gsub(".unpaired.fq.gz",".html",c1u)

cmd  <-  paste("fastp --in1 ", f1, " --in2 ", f2, " --out1 ", c1," --out2 ", c2, " --unpaired1 ", c1u, " --unpaired2 ", c2u, " --merge --merged_out ", m, " --thread 16 --adapter_sequence=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA --adapter_sequence_r2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT --html ", htmlrep, sep="") # --detect_adapter_for_pe

cmd[1]

# mclapply is like lapply, but mcl applies for multiple cores and for a list all at the same time
mclapply(cmd, system, mc.cores=getOption("mc.cores", 4)) # do only once - will use 16 cores for each, but it only allows 4 processes to run simultaneously


