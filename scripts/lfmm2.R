#devtools::install_github("bcm-uga/LEA")

library(lfmm)
library(LEA)

#setwd("/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/")

#vcf2lfmm("all_samples_reseq_chromosome_CM027521.1_filtered_SNPs_HWE.vcf","/home/pkalhori/all_samples_reseq_chromosome_CM027521.1_filtered_SNPs_HWE.lfmm")

#vcf_files <- list.files(path = "/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated", pattern = "*_filtered_SNPs_HWE\\.vcf$", full.names = TRUE)

#lfmm_files <- gsub("vcf","lfmm", vcf_files)




#cmd<-paste0("vcf2lfmm(", shQuote(vcf_files), ",", shQuote(lfmm_files), ")")


# Load the necessary R package
#library(parallel)

# Define your function to be parallelized
#vcf2lfmm_wrapper <- function(input1, input2) {
  # Call vcf2lfmm with the two inputs
  #vcf2lfmm(input1, input2)
#}


# Call mclapply to apply the wrapper function in parallel
#mclapply(seq_along(vcf_files), function(i) vcf2lfmm_wrapper(vcf_files[[i]], lfmm_files[[i]]), mc.cores = 8)

setwd("/home/pkalhori/lfmm")

pc = pca("all_chroms_filtered_SNPs_HWE.lfmm", scale = TRUE) 
tw = tracy.widom(pc)

plot(tw$percentage, pch = 19, col = "darkblue", cex = .8)
gen <- read.lfmm("all_chroms_filtered_SNPs_HWE.lfmm")
gen.imp <- apply(gen, 2, function(x) replace(x, 9, as.numeric(names(which.max(table(x))))))

gen_imp_2 <- apply(gen, 2, function(x) {
  freq_table <- table(x)
  most_freq <- names(sort(freq_table, decreasing = TRUE)[1])
  if (as.numeric(most_freq) == 9) {
    second_most_freq <- names(sort(freq_table, decreasing = TRUE)[2])
    replace(x, 9, as.numeric(second_most_freq))
  } else {
    replace(x, 9, as.numeric(most_freq))
  }
})

sum(is.na(gen)) # No NAs


#project.missing = snmf("all_chroms_filtered_SNPs_HWE.lfmm", K = 3, entropy = TRUE, repetitions = 5, project = "new")

#best = which.min(cross.entropy(project.missing, K = 3)) # Impute the missing genotypes 
#impute(project.missing, "all_chroms_filtered_SNPs_HWE.lfmm", method = 'mode', K = 3, run = best) ## Missing genotype imputation for K = 4 ## Missing genotype imputation for run = 9 ## Results are written in the file: genoM.lfmm_imputed.lfmm # Proportion of correct imputation results 
dat.imp = read.lfmm("all_chroms_filtered_SNPs_HWE.lfmm_imputed.lfmm") 




env <- read.env("/home/pkalhori/lfmm/elevations.env")
yewa.lfmm <- lfmm_ridge(Y=dat.imp, X=env, K=3) ## c.ange K as you see fit

yewa.pv <- lfmm_test(Y=dat.imp, X=env, lfmm=yewa.lfmm, calibrate="gif")

names(yewa.pv) # this object includes raw z-scores and p-values, as well as GIF-calibrated scores and p-values

yewa.pv$gif

yewa.qv <- qvalue(yewa.pv$calibrated.pvalue)$qvalues

length(which(yewa.qv < .1)) ## h.w many SNPs have an FDR < 10%?


yewa.lfmm2 <- lfmm2(dat.imp, env, K=3) ## c.ange K as you see fit

yewa.pv2 <- lfmm2.test(input=dat.imp, env =env, object=yewa.lfmm2)


plot(-log10(yewa.pv2$pvalues),col="grey",cex=.5,pch=19) 
abline(h=-log10(0.1/510),lty=2,col="orange")

# main options # K = number of ancestral populations # entropy = TRUE computes the cross-entropy criterion, # CPU = 4 is the number of CPU used (hidden input) 
project = NULL 
project = snmf("all_chroms_filtered_SNPs_HWE.geno", K = 1:6, entropy = TRUE, repetitions = 1, project = "new",CPU=16)

best = which.min(cross.entropy(project.missing, K = 3)) 
my.colors <- c("tomato", "lightblue", "olivedrab")
barchart(project.missing, K = 3, run = best, border = NA, space = 0, col = my.colors, xlab = "Individuals", ylab = "Ancestry proportions", main = "Ancestry matrix")-> bp 
axis(1, at = 1:length(bp$order), labels = bp$order, las=1, cex.axis = .4)

####using algtr

library(algatr)
ridge_results <- lfmm_run(dat.imp, env, K = 6, lfmm_method = "ridge")
