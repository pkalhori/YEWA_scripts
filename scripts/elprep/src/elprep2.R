# ################################################################################
# this R script will take .sam files and run elprep
# to:
# 1) add readgroup labels,
# 2) dedupe reads,
# 3) combine multiple sam files into one combined, and
# 4) sort and prepare them for creating vcf files
# and provides the output as a sorted deduped .bam file
#
# 30 March 2022 Jack Dumbacher
# run by typing:
# Rscript --verbose --vanilla elprep2.R

# notes from Jim:
# There is a script that does the basic coordinate sort, 
# removes recs with quality lt 20, marks and removes duplicates, and 
# creates the metrics file for this. The script is set to use 10 threads.
# After doing a map and creating a file mymappedreads.sam you can run this:
#      elprep.sh mymappedreads.sam mymappedreads_srt_dedup.bam
# and you'll get the sorted deduped recs in bam format.
# Also we often use elprep outside the script with a few more options to add ReadGroups 
# when we are doing multiple batches of reads.
# elprep is much faster and more so when doing all these steps together, 
# since it only writes the file out once.

# The basic elprep comman structure and workflow is:
# 
# elprep sfm NA12878.input.bam NA12878.output.bam
# --mark-duplicates --mark-optical-duplicates NA12878.output.metrics
# --sorting-order coordinate
# --bqsr NA12878.output.recal --known-sites dbsnp_138.hg38.elsites,Mills_and_1000G_gold_standard.indels.hg38.elsites
# --reference hg38.elfasta
# --haplotypecaller NA128787.output.vcf.gz
#

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

setwd("/home/jdumbacher/pyrocephalus/aligned/")
fn_pe <- list.files(getwd(), "_pe_out.sam$", recursive=TRUE, full.names=TRUE)
fn_se <- list.files(getwd(), "_se_out.sam$", recursive=TRUE, full.names=TRUE)
fn_mrg <- list.files(getwd(), "_mrg_out.sam$", recursive=TRUE, full.names=TRUE)

fn_pe <- gsub("home3", "home",fn_pe, fixed=FALSE)
fn_se <- gsub("home3", "home",fn_se, fixed=FALSE)
fn_mrg <- gsub("home3", "home",fn_mrg, fixed=FALSE)

# output files:
fn_pe_elprep <- gsub("aligned", "elprep", fn_pe, fixed = FALSE)
fn_se_elprep <- gsub("aligned", "elprep", fn_se, fixed = FALSE)
fn_mrg_elprep <- gsub("aligned", "elprep", fn_mrg, fixed = FALSE)

fn_pe_elprep <- gsub(".sam", ".bam", fn_pe_elprep, fixed = FALSE)
fn_se_elprep <- gsub(".sam", ".bam", fn_se_elprep, fixed = FALSE)
fn_mrg_elprep <- gsub(".sam", ".bam", fn_mrg_elprep, fixed = FALSE)

#################################################################################
# Step #2. create elprep folder
#################################################################################

setwd("/home/jdumbacher/pyrocephalus/")
# dir.create("elprep") #do once  - like mkdir and can overwrite, so BE CAREFUL!
# Creating directories if not already created ----------------
if ((dir.exists("elprep")) == FALSE) {
  dir.create("elprep")
}

d1 <-  list.files("/home/jdumbacher/pyrocephalus/clean/") # lists directories in /clean

# create subdirectories for aligned illumina output from bwa-mem:
# do this only once (but make sure that all are present)
setwd("/home/jdumbacher/pyrocephalus/elprep/")
# dir_create(d1)  # do this only once so that it does not overwrite previous outputs




#################################################################################
# Step #3. run elprep, and include add readgroup labels
#################################################################################
# Create readgroup string, in the format: 
# --replace-read-group "ID:group1 LB:lib1 PL:illumina PU:unit1 SM:sample1"

d1 <-  list.files("/home/jdumbacher/pyrocephalus/clean/") # lists directories in /clean
read_group_se <- paste0("ID:", d1, "_SE PL:illumina SM:",d1)
read_group_pe <- paste0("ID:", d1, "_PE PL:illumina SM:",d1)
read_group_mrg <- paste0("ID:", d1, "_MRG PL:illumina SM:",d1)

check <- Map(c, fn_pe, read_group_pe)

# elprep input.sam output.sam --filter-unmapped-reads --replace-reference-sequences $gatkdict --replace-read-group "ID:group1 LB:lib1 PL:illumina PU:unit1 SM:sample1" --mark-duplicates --sorting-order coordinate --nr-of-threads $threads

# cmd_pe <- paste0('elprep sfm ', fn_pe, ' ', fn_pe_elprep, ' --filter-unmapped-reads --replace-read-group \"', read_group_pe, '\" --mark-duplicates --sorting-order coordinate --nr-of-threads $16')
cmd_pe <- paste0("elprep sfm ", fn_pe, " ", fn_pe_elprep, " --filter-unmapped-reads --replace-read-group \"", read_group_pe, "\" --mark-duplicates --sorting-order coordinate --nr-of-threads 16")
cmd_se <- paste0("elprep sfm ", fn_se, " ", fn_se_elprep, " --filter-unmapped-reads --replace-read-group \"", read_group_se, "\" --mark-duplicates --sorting-order coordinate --nr-of-threads 16")
cmd_mrg <- paste0("elprep sfm ", fn_mrg, " ", fn_mrg_elprep, " --filter-unmapped-reads --replace-read-group \"", read_group_mrg, "\" --mark-duplicates --sorting-order coordinate --nr-of-threads 16")

# mclapply(cmd_pe, system, mc.cores=getOption("mc.cores", 8)) # do only once - will use 16 cores for each, but it only allows 4 processes to run simultaneously
# mclapply(cmd_se, system, mc.cores=getOption("mc.cores", 8)) # do only once - will use 16 cores for each, but it only allows 4 processes to run simultaneously
# mclapply(cmd_mrg, system, mc.cores=getOption("mc.cores", 8)) # do only once - will use 16 cores for each, but it only allows 4 processes to run simultaneously

# ######################################################
# Manually update read groups for sample A1 (which has two illumina runs)
# #######################################################
d1_A1 <-  c("A1_1", "A1_2")

read_group_se_A1 <- paste0("ID:", d1_A1, "_SE PL:illumina SM:A1")
read_group_pe_A1 <- paste0("ID:", d1_A1, "_PE PL:illumina SM:A1")
read_group_mrg_A1 <- paste0("ID:", d1_A1, "_MRG PL:illumina SM:A1")

# cmd_pe <- paste0('elprep sfm ', fn_pe, ' ', fn_pe_elprep, ' --filter-unmapped-reads --replace-read-group \"', read_group_pe, '\" --mark-duplicates --sorting-order coordinate --nr-of-threads $16')
cmd_pe[1:2] <- paste0("elprep sfm ", fn_pe[1:2], " ", fn_pe_elprep[1:2], " --filter-unmapped-reads --replace-read-group \"", read_group_pe_A1, "\" --mark-duplicates --sorting-order coordinate --nr-of-threads 16")
cmd_se[1:2] <- paste0("elprep sfm ", fn_se[1:2], " ", fn_se_elprep[1:2], " --filter-unmapped-reads --replace-read-group \"", read_group_se_A1, "\" --mark-duplicates --sorting-order coordinate --nr-of-threads 16")
cmd_mrg[1:2] <- paste0("elprep sfm ", fn_mrg[1:2], " ", fn_mrg_elprep[1:2], " --filter-unmapped-reads --replace-read-group \"", read_group_mrg_A1, "\" --mark-duplicates --sorting-order coordinate --nr-of-threads 16")

mclapply(cmd_pe, system, mc.cores=getOption("mc.cores", 8)) # do only once - will use 16 cores for each, but it only allows 4 processes to run simultaneously
mclapply(cmd_se, system, mc.cores=getOption("mc.cores", 8)) # do only once - will use 16 cores for each, but it only allows 4 processes to run simultaneously
mclapply(cmd_mrg, system, mc.cores=getOption("mc.cores", 8)) # do only once - will use 16 cores for each, but it only allows 4 processes to run simultaneously


# ################################################################################
# step #3: create the elfasta reference file
# ################################################################################
#reference genome file is here at idxbase:
idxbase <- "/home/jdumbacher/pyrocephalus/hic_scaffold/hifiasm_tst1/vf_asm.bp.p_ctg.FINAL.fasta"
elfasta <- "/home/jdumbacher/pyrocephalus/hic_scaffold/hifiasm_tst1/vf_asm.bp.p_ctg.FINAL.elfasta"
# Basic script format follows:
#   elprep fasta-to-elfasta ucsc.hg19.fasta ucsc.hg19.elfasta
# cmd <- paste0("elprep fasta-to-elfasta ", idxbase, " ", elfasta)
# lapply(cmd,system)

setwd("/home/jdumbacher/pyrocephalus/aligned/")
fn <- list.files(getwd(), "_sorted_combined.sam$", recursive=TRUE, full.names=TRUE)
fn_in <- gsub("home3", "home",fn, fixed=FALSE)

# create an out filename
fn_out <- gsub("_sorted_combined.sam", "_elprep_srt_dedup.bam",fn_in, fixed=FALSE)

# create the command
cmd <- paste0("elprep.sh ", fn_in, " ", fn_out)

#execute the command on the server
# lapply(cmd, system)

# execute for just those that weren't run in the first iteration:
# lapply(cmd[6], system)
# lapply(cmd[8], system)
# lapply(cmd[10:18], system)
# lapply(cmd[57], system)

# fn_dedup <- list.files(getwd(), "elprep_srt_dedup.bam$", recursive=TRUE, full.names=TRUE)



