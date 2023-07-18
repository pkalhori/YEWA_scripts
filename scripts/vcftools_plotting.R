setwd("/home/pkalhori/vcftools_Fst")

#####YEWA All Contigs High vs Low Elevation, by Island

SantaCruz_Fst <- read.table("yewa_alignment/Santa_Cruz_Highland_vs_Lowland.windowed.weir.fst", header=T)
SantaCruz_Fst$Position <- paste(SantaCruz_Fst$CHROM, ".", SantaCruz_Fst$BIN_START, sep="")

SanCristobal_Fst <- read.table("yewa_alignment/San_Cristobal_Highland_vs_Lowland.windowed.weir.fst", header=T)
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








