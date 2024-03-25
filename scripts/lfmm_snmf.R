library(LEA)
project_clustering=NULL 

project_clustering=snmf("/home/pkalhori/lfmm/all_samples_no_mtDNA_filtered_maxdepth.geno", K=1:10, entropy=TRUE, repetitions=10, project="new")

