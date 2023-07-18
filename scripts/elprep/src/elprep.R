# ################################################################################
# this R script will take sorted combined .sam files and run elprep
# and outputs a sorted deduped .bam file
#
# 4 March 2022 Jack Dumbacher
# run by typing:
# Rscript --verbose --vanilla elprep.R

# notes from Jim:
# There is a script that does the basic coordinate sort, removes recs with quality lt 20, marks and removes duplicates and creates the metrics file for this. The script is set to use 10 threads.
# After doing a map and creating a file mymappedreads.sam you can run this:
#      elprep.sh mymappedreads.sam mymappedreads_srt_dedup.bam
# and you'll get the sorted deduped recs in bam format.
# Also we often use elprep outside the script with a few more options to add ReadGroups when we are doing multiple batches of reads.
# elprep is much faster and more so when doing all these steps together, since it only writes the file out once.

# ################################################################################

setwd("/home/jdumbacher/pyrocephalus")
# library(tidyverse)
library(fs)
# library(here)
# library(ips) # for reading fasta, trees and nexus 
library(parallel) # allows you to execute jobs - takes lists and assigns processoers to items in lisr


# ################################################################################
# step one: get names and full paths of .sam alignment files
# ################################################################################

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



