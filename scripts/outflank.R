library(vcfR)
library(OutFLANK)
vcf.path <- "/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/all_autosomes_filtered_SNPs_HWE.vcf.gz"
meta <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")
data <- read.vcfR(vcf.path)
geno <- extract.gt(data)
position <- getPOS(data) # Positions in bp
chromosome <- getCHROM(data)
G <- geno 
G[geno %in% c("0/0")] <- 0
G[geno  %in% c("0/1")] <- 1
G[geno %in% c("1/1")] <- 2
G[is.na(G)] <- 9
tG <- t(G)

##All islands
subpops <- c("lowland","highland")
subgen <- tG[meta$Elevation%in%subpops,]
submeta <- subset(meta,Elevation%in%subpops)
fst <- MakeDiploidFSTMat(subgen,locusNames=colnames(tG),popNames=submeta$Elevation)
write.csv(fst,"/home/pkalhori/outflank_fst_HWE_allislands.csv")
#fst<-read.csv("/home/pkalhori/outflank_fst_HWE_allislands.csv")

##Isabella
subpops_isabela <- c("Isabella_Lowland","Isabella_Highland")
subgen_isabela <- tG[meta$Island_Elevation%in%subpops_isabela,]
submeta_isabela <- subset(meta,Island_Elevation%in%subpops_isabela)
fst_isabela <- MakeDiploidFSTMat(subgen_isabela,locusNames=colnames(tG),popNames=submeta_isabela$Island_Elevation)

#write.csv(fst_isabela,"/home/pkalhori/outflank_fst_HWE_isabela.csv")
#fst_isabela<-read.csv("/home/pkalhori/outflank_fst_HWE_isabela.csv")

##SantaCruz
subpops_santacruz <- c("SantaCruz_Lowland","SantaCruz_Highland")
subgen_santacruz <- tG[meta$Island_Elevation%in%subpops_santacruz,]
submeta_santacruz <- subset(meta,Island_Elevation%in%subpops_santacruz)
fst_santacruz <- MakeDiploidFSTMat(subgen_santacruz,locusNames=colnames(tG),popNames=submeta_santacruz$Island_Elevation)
#write.csv(fst_santacruz,"/home/pkalhori/outflank_fst_HWE_santacruz.csv")
##SanCristobal
subpops_sancristobal <- c("SanCristobal_Lowland","SanCristobal_Highland")
subgen_sancristobal <- tG[meta$Island_Elevation%in%subpops_sancristobal,]
submeta_sancristobal <- subset(meta,Island_Elevation%in%subpops_sancristobal)
fst_sancristobal <- MakeDiploidFSTMat(subgen_sancristobal,locusNames=colnames(tG),popNames=submeta_sancristobal$Island_Elevation)
#write.csv(fst,"/home/pkalhori/outflank_fst_HWE_sancristobal.csv")


hist(fst$FST,breaks=50)
summary(fst$FST)

fst_outflank <- fst
island="All Islands"

OF <- OutFLANK(fst_outflank,LeftTrimFraction=0.1,RightTrimFraction=0.1,
               Hmin=0.1,NumberOfSamples=54,qthreshold=0.05)
OutFLANKResultsPlotter(OF,withOutliers=T,
                       NoCorr=T,Hmin=0.1,binwidth=0.005,
                       Zoom=F,RightZoomFraction=0.05,titletext=NULL)
P1 <- pOutlierFinderChiSqNoCorr(fst_outflank,Fstbar=OF$FSTNoCorrbar,
                                dfInferred=OF$dfInferred,qthreshold=0.05,Hmin=0.1)
outliers <- P1$OutlierFlag==TRUE #which of the SNPs are outliers?
table(outliers)

P1_mutated <- P1 %>%
  mutate(chromosome = sapply(strsplit(as.character(LocusName), "_"), "[[", 1),
         position = sapply(strsplit(as.character(LocusName), "_"), "[[", 2) %>% as.numeric())

hits <- filter(P1_mutated,OutlierFlag==T)

P1_mutated$chrOrder <- factor(P1_mutated$chromosome,levels=c( "CM027507.1" ,"CM027536.1","CM027508.1" ,"CM027509.1", "CM027510.1" ,"CM027537.1","CM027511.1" ,"CM027512.1", "CM027513.1", "CM027514.1" ,"CM027515.1","CM027516.1", "CM027517.1" ,"CM027518.1" ,"CM027519.1", "CM027520.1" ,"CM027521.1", "CM027522.1", "CM027523.1" ,"CM027524.1","CM027525.1", "CM027526.1", "CM027527.1" ,"CM027528.1" ,"CM027529.1" ,"CM027530.1", "CM027531.1", "CM027532.1" ,"CM027533.1","CM027534.1", "CM027535.1"  ))


cbbPalette <- c(rep(c("grey50", "black","grey50", "black","grey50", "black"),5),"grey50")



ggplot(data=subset(P1_mutated,OutlierFlag==F), aes(x=position, y= FST,color=chrOrder)) + 
  geom_point(show.legend = F, cex = 0.5)  + 
  ggtitle(paste0("OutFLANK Fst,",island)) + 
  ggh4x::facet_grid2(island ~ chrOrder,
                     scales = "free_x", switch = "x", space = "free_x") +
  scale_colour_manual(values=cbbPalette) +
  
  theme_classic()+
  theme(axis.text.x = element_blank(),
        strip.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.spacing = unit(0.01, "cm"),
        strip.background = element_blank(),
        strip.placement = "outside",
        legend.position ="none")+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,NA))+
  geom_point(data=subset(P1_mutated,OutlierFlag==T), aes(x=position, y= FST),color="salmon",cex = 0.5)+
  ggh4x::facet_grid2(. ~ chrOrder,
                     scales = "free_x", switch = "x", space = "free_x")+
  
  xlab("Position Along Chromosome")+
  ylab("Weir & Cockerham's Fst")


plot(1:nrow(P1),P1$FST,xlab="Position",ylab="FST",col=rgb(0,0,0,alpha=0.1))
points((1:nrow(P1))[outliers],P1$FST[outliers],col="magenta")


#plot(P1$LocusName,P1$FST,xlab="Position",ylab="FST",col=rgb(0,0,0,alpha=0.1))
#points(P1$LocusName[outliers],P1$FST[outliers],col="magenta")


###pcaadapt
vcf.path <- "/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/isabela_autosomes_filtered_SNPs_HWE.vcf.gz"
library(pcadapt)
library(qvalue)
filename <- read.pcadapt(vcf.path, type = "vcf")

x <- pcadapt(input = filename, K = 10) 
plot(x, option = "screeplot")
plot(x,option="scores",pop=submeta_isabela$Elevation)
plot(x,option="manhattan")
?plot.pcadapt

qval <- qvalue(x$pvalues)$qvalues
outliers <- which(qval<0.01)
length(outliers)

