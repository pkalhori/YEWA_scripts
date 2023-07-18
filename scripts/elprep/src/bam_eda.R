# ################################################################################
# this R script will take .bam files from elprep and do some basic stats on them
#
# 19 April 2022 Jack Dumbacher
# run by typing:
# Rscript --verbose --vanilla elprep2.R

# ################################################################################

setwd("/home/jdumbacher/pyrocephalus")
# library(tidyverse)
library(fs)
library(here)
library(stringr)
# library(ips) # for reading fasta, trees and nexus 
library(parallel) # allows you to execute jobs - takes lists and assigns processoers to items in lisr

# ################################################################################
# step #1: get names and full paths of .sam alignment files
# ################################################################################

setwd("/home/jdumbacher/pyrocephalus/elprep/")
fn_bam <- list.files(getwd(), ".bam$", recursive=TRUE, full.names=TRUE)

fn_pe <- list.files(getwd(), "_pe_out.bam$", recursive=TRUE, full.names=TRUE)
fn_se <- list.files(getwd(), "_se_out.bam$", recursive=TRUE, full.names=TRUE)
fn_mrg <- list.files(getwd(), "_mrg_out.bam$", recursive=TRUE, full.names=TRUE)

fn_bam <- gsub("home3", "home",fn_bam, fixed=FALSE)
fn_pe <- gsub("home3", "home",fn_pe, fixed=FALSE)
fn_se <- gsub("home3", "home",fn_se, fixed=FALSE)
fn_mrg <- gsub("home3", "home",fn_mrg, fixed=FALSE)

cmd <- paste0("samtools view -c ", fn_bam)
read_tot <- system(cmd, intern=TRUE)
