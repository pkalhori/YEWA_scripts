setwd("/home/pkalhori/vcftools_Fst")

#####YEWA All Contigs High vs Low Elevation, by Island

SantaCruz_Fst <- read.table("yewa_alignment/SantaCruz_Highland_vs_Lowland.windowed.weir.fst", header=T)
SantaCruz_Fst$Position <- paste(SantaCruz_Fst$CHROM, ".", SantaCruz_Fst$BIN_START, sep="")

SanCristobal_Fst <- read.table("yewa_alignment/SanCristobal_Highland_vs_Lowland.windowed.weir.fst", header=T)
SanCristobal_Fst$Position <- paste(SanCristobal_Fst$CHROM, ".", SanCristobal_Fst$BIN_START, sep="")


Isabela_Fst <- read.table("yewa_alignment/Isabela_Highland_vs_Lowland.windowed.weir.fst", header=T)
Isabela_Fst$Position <- paste(Isabela_Fst$CHROM, ".", Isabela_Fst$BIN_START, sep="")


library(ggplot2)

santa_cruz_fst <- ggplot(data=SantaCruz_Fst, aes(x=Position, y= WEIGHTED_FST)) + geom_point() + ggtitle("Santa Cruz Highland vs Lowland Fst, 10kb Windows")


san_cristobal_fst <- ggplot(data=SanCristobal_Fst, aes(x=Position, y= WEIGHTED_FST)) + geom_point() + ggtitle("San Cristobal Highland vs Lowland Fst, 10kb Windows")

isabela_fst <- ggplot(data=Isabela_Fst, aes(x=Position, y= WEIGHTED_FST)) + geom_point() + ggtitle("Isabela Highland vs Lowland Fst, 10kb Windows")

ggsave("Santa_Cruz_10kb_Windows_fst.pdf", santa_cruz_fst)

ggsave("San_Cristobal_10kb_Windows_fst.pdf", san_cristobal_fst)

ggsave("Isabela_10kb_Windows_fst.pdf", isabela_fst)

#####MYWA Chromosome Aligment

###Males vs Females Fst, All Autosomes
Males_Females_Fst <- read.table("mywa_alignment/autosomes_only/males_vs_females.windowed.weir.fst", header=T)
Males_Females_Fst$Position <- paste(Males_Females_Fst$CHROM, ".", Males_Females_Fst$BIN_START, sep="")

ggplot(data = Males_Females_Fst, aes(x=1:nrow(Males_Females_Fst), y=WEIGHTED_FST)) + geom_point()

#Males vs Females Fst, Z chromosome
Males_Females_Z_Fst <- read.table("mywa_alignment/autosomes_only/males_vs_females_Z_chr.windowed.weir.fst", header=T)

ggplot(data = Males_Females_Z_Fst, aes(x=1:nrow(Males_Females_Z_Fst), y=WEIGHTED_FST)) + geom_point()

high_fst<-Males_Females_Fst[Males_Females_Fst$WEIGHTED_FST>0.1,]

unique(high_fst$CHROM)

#####GEO Chromosome Alignment
##Males vs Females Fst, Autosomes
Males_Females_Autosomes_Fst <- read.table("geo_alignment/Males_vs_Females_Autosomes.windowed.weir.fst", header=T)

ggplot(data = Males_Females_Autosomes_Fst, aes(x=1:nrow(Males_Females_Autosomes_Fst), y=WEIGHTED_FST)) + geom_point()


##Males vs Females Fst, Z Chromosome
Males_Females_Z_Fst <- read.table("geo_alignment/Males_vs_Females_Z_Chr.windowed.weir.fst", header=T)

ggplot(data = Males_Females_Z_Fst, aes(x=1:nrow(Males_Females_Z_Fst), y=WEIGHTED_FST)) + geom_point()

##Males vs Females Fst, W Chromosome
Males_Females_W_Fst <- read.table("geo_alignment/Males_vs_Females_W_Chr.windowed.weir.fst", header=T)

ggplot(data = Males_Females_W_Fst, aes(x=1:nrow(Males_Females_W_Fst), y=WEIGHTED_FST)) + geom_point()

###MYWA with GEO W Alignment

Males_Females_Autosomes_Fst <- read.table("mywa_geo_alignment/males_vs_females_autosomes.windowed.weir.fst", header=T)

ggplot(data = Males_Females_Autosomes_Fst, aes(x=1:nrow(Males_Females_Autosomes_Fst), y=WEIGHTED_FST)) + geom_point()
