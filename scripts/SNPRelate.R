library(SNPRelate)
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

chromosome="CM027535.1"

vcf_dir="/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated"

#vcf.fn=paste(vcf_dir,"/all_samples_chromosome_",chromosome,"_filtered_max_depth.vcf.gz", sep="")

vcf.fn="/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/SNPs_only_2025_with_MAF/all_autosomes_filtered_SNPs_2025.vcf.gz"

#snpgdsVCF2GDS(vcf.fn, paste("/home/pkalhori/SNPRelate/",chromosome,"._max_depth.gds",sep=""), method="biallelic.only")

snpgdsVCF2GDS(vcf.fn, "/home/pkalhori/SNPRelate/autosomes_20250617.gds", method="biallelic.only")

#genofile <- snpgdsOpen(paste("/home/pkalhori/SNPRelate/",chromosome,"._max_depth.gds",sep=""))
genofile <- snpgdsOpen("/home/pkalhori/SNPRelate/autosomes_20250617.gds")

pruned <- snpgdsLDpruning(genofile,ld.threshold = 5,autosome.only = F)

snpset.id <- unlist(unname(pruned))

pca<- snpgdsPCA(genofile, autosome.only=F, num.thread=8,snp.id=snpset.id)
pca <- snpgdsPCA(genofile, autosome.only=F, num.thread=8)


# make a data.frame
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)


##Plotting

pca_plot<- cbind(tab, sample_info)

ggplot(pca_plot, aes(x=EV1, y=EV2, col=Island, label=sample.id))+
  geom_point() + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)+
  ggtitle("SNPRelate PCA Autosomes")
  #ggtitle(paste("SNPRelate PCA, ", chromosome, "Post Filtering")) 

##Calculate Loadings

snps <- snpgdsPCASNPLoading(pca, genofile)









