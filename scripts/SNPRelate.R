library(SNPRelate)
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

chromosome="CM027535.1"

vcf_dir="/home/pkalhori/mpileup/calls_coronata_alignment"

vcf.fn=paste(vcf_dir,"/all_samples_chromosome_",chromosome,"_filtered_max_depth.vcf.gz", sep="")

snpgdsVCF2GDS(vcf.fn, paste("/home/pkalhori/SNPRelate/",chromosome,"._max_depth.gds",sep=""), method="biallelic.only")

genofile <- snpgdsOpen(paste("/home/pkalhori/SNPRelate/",chromosome,"._max_depth.gds",sep=""))

pca <- snpgdsPCA(genofile, autosome.only=F, num.thread=8)

pca$snp.id

# make a data.frame
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)


#write.table(tab, paste("/home/pkalhori/SNPRelate/",Island,"_pca.txt",sep=""))
write.table(tab, "/home/pkalhori/SNPRelate/mtDNA_filtered_PCA.txt")

##Plotting

pca_plot<- cbind(tab, sample_info)

ggplot(pca_plot, aes(x=EV1, y=EV2, col=Sex, label=sample.id))+
  geom_point() + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)+
  ggtitle("SNPRelate PCA mtDNA")
  #ggtitle(paste("SNPRelate PCA, ", chromosome, "Post Filtering")) 

##Calculate Loadings

snps <- snpgdsPCASNPLoading(pca, genofile)









