setwd("/home/pkalhori/vcftools_Fst/mywa_geo_alignment")
library(tidyverse)
library(ggplot2)
#####Fst High vs Low Elevation, by Island
window="10"

SantaCruz_Fst <- read.table(paste(window,"kb_window/Santa_Cruz_",window,"000.windowed.weir.fst",sep=""), header=T)
SantaCruz_Fst$Island <- "Santa_Cruz"
SantaCruz_Fst$Position <- paste(SantaCruz_Fst$CHROM, ".", SantaCruz_Fst$BIN_START, sep="")
SantaCruz_Fst_top <- SantaCruz_Fst[order(SantaCruz_Fst$WEIGHTED_FST,decreasing = T),][1:round(dim(SantaCruz_Fst)[1]*.05),]

SanCristobal_Fst <- read.table(paste(window,"kb_window/San_Cristobal_",window,"000.windowed.weir.fst",sep=""), header=T)
SanCristobal_Fst$Island <- "San_Cristobal"
SanCristobal_Fst$Position <- paste(SanCristobal_Fst$CHROM, ".", SanCristobal_Fst$BIN_START, sep="")
SanCristobal_Fst_top <- SanCristobal_Fst[order(SanCristobal_Fst$WEIGHTED_FST,decreasing = T),][1:round(dim(SanCristobal_Fst)[1]*.05),]

Isabela_Fst <- read.table(paste(window,"kb_window/Isabela_",window,"000.windowed.weir.fst",sep=""), header=T)
Isabela_Fst$Island <- "Isabela"
Isabela_Fst$Position <- paste(Isabela_Fst$CHROM, ".", Isabela_Fst$BIN_START, sep="")
Isabela_Fst_top <- Isabela_Fst[order(Isabela_Fst$WEIGHTED_FST,decreasing = T),][1:round(dim(Isabela_Fst)[1]*.05),]

all_top <- rbind(Isabela_Fst_top, SantaCruz_Fst_top, SanCristobal_Fst_top)
all_top_counts <- all_top %>% count(Position) 

#write.csv(all_top_counts, paste("/home/pkalhori/vcftools_Fst/mywa_geo_alignment/top_5percent_",window,"kb_windows.csv",sep = ""))

##PLotting
all_islands_fst <- rbind(SantaCruz_Fst, SanCristobal_Fst, Isabela_Fst) %>% subset(WEIGHTED_FST>0.1) %>% subset(CHROM!="CM019934.1") 

cbbPalette <- rep(c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"),4)
ggplot(data=all_islands_fst, aes(x=Position, y= WEIGHTED_FST, color=CHROM)) + geom_point(show.legend = F) + scale_colour_manual(values=cbbPalette) + ggtitle(paste("All Islands Highland vs Lowland Fst, ",window,"kb Windows, MYWA Chromosomes",sep="")) + facet_grid(Island~.) + geom_hline(yintercept = .4, color="red")

#####pi########

window="10"

Overall_pi <- read.table(paste("all_samples_",window,"000.windowed.pi",sep=""), header=T)

Overall_pi$Position <- paste(Overall_pi$CHROM, ".", Overall_pi$BIN_START, sep="")

Overall_pi <- Overall_pi %>% subset(Overall_pi$CHROM!='CM19934.1') %>% subset(Overall_pi$PI>0.005)

ggplot(data=Overall_pi, aes(x=Position, y= PI, color=CHROM)) + geom_point(show.legend = F) + scale_colour_manual(values=cbbPalette) + ggtitle(paste("All Islands Pi, ",window,"kb Windows, MYWA Chromosomes",sep=""))

#####Scratch####
Overall_Fst <- read.table("yewa_alignment/Highland_vs_Lowland.windowed.weir.fst", header=T)
Overall_Fst$Position <- paste(Overall_Fst$CHROM, ".", Overall_Fst$BIN_START, sep="")
Overall_Fst$Island <- "All_Islands"
ggplot(data=Overall_Fst, aes(x=Position, y= WEIGHTED_FST, color=CHROM)) + geom_point(show.legend = F) + ggtitle("All Islands Highland vs Lowland Fst, 10kb Windows, YEWA Contigs") + geom_hline(yintercept = .4, color="red")

all_fst <- rbind(Isabela_Fst, SanCristobal_Fst, SantaCruz_Fst, Overall_Fst) %>% subset(WEIGHTED_FST>0.1)
ggplot(data=Overall_Fst,aes(x=N_VARIANTS,y=WEIGHTED_FST)) + geom_point() + geom_point(aes(x=N_VARIANTS,y=MEAN_FST,col="red"))
