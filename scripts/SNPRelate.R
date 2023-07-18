library(SNPRelate)
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

chromosome="CM027535.1"

vcf_dir="/home/pkalhori/mpileup/calls_yewa_alignment"

#vcf.fn=paste(vcf_dir,"/all_samples_chromosome_",chromosome,"_filtered_MQ20.vcf", sep="")
vcf.fn=paste(vcf_dir,"/all_samples_mtDNA_regions_filtered.vcf.gz", sep="")
#snpgdsVCF2GDS(vcf.fn, paste("/home/pkalhori/SNPRelate/",chromosome,".gds",sep=""), method="biallelic.only")
snpgdsVCF2GDS(vcf.fn, "/home/pkalhori/SNPRelate/mtDNA_filtered3.gds", method="biallelic.only")
genofile <- snpgdsOpen("/home/pkalhori/SNPRelate/mtDNA_filtered3.gds")

pca <- snpgdsPCA(genofile, autosome.only=F, num.thread=8)


# make a data.frame
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)


#write.table(tab, paste("/home/pkalhori/SNPRelate/",Island,"_pca.txt",sep=""))
write.table(tab, "/home/pkalhori/SNPRelate/mtDNA_filtered_PCA.txt")

##Plotting

sample_info_Santa_Cruz <- sample_info[sample_info$Island=="Santa Cruz",]
pca_plot<- cbind(tab, sample_info)

ggplot(pca_plot, aes(x=EV1, y=EV2, col=Island, label=sample.id))+
  geom_point() + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)+
  ggtitle("SNPRelate PCA mtDNA")
  #ggtitle(paste("SNPRelate PCA, ", chromosome, "Post Filtering")) 










