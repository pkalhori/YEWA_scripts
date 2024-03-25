#######MYWA########

islands=c("isabela","santacruz","sancristobal","all_islands")


window_size="10"
date="2024-01-17"

dxy_all <- data_frame()

for (island in islands){
  wd<-(paste("/home/pkalhori/pixy/mywa_geo/",date,"/",window_size,"kb_window/",island,sep=""))
  dxy_files <- list.files(wd,pattern="*_dxy.txt", full.names=T)
  for (file in dxy_files){
    dxy_file <- read.csv(file,sep="\t")
    dxy_file$island <- island
    dxy_all <- rbind(dxy_all,dxy_file)
  }
  
}

dxy_all <- dxy_all[dxy_all$chromosome!="CM019934.1",] %>% na.omit()

dxy_all$chrOrder <- factor(dxy_all$chromosome,levels=c( "CM027507.1" ,"CM027536.1","CM027508.1" ,"CM027509.1", "CM027510.1" ,"CM027537.1","CM027511.1" ,"CM027512.1", "CM027513.1", "CM027514.1" ,"CM027515.1","CM027516.1", "CM027517.1" ,"CM027518.1" ,"CM027519.1", "CM027520.1" ,"CM027521.1", "CM027522.1", "CM027523.1" ,"CM027524.1","CM027525.1", "CM027526.1", "CM027527.1" ,"CM027528.1" ,"CM027529.1" ,"CM027530.1", "CM027531.1", "CM027532.1" ,"CM027533.1","CM027534.1", "CM027535.1"  ))


test <- dxy_all %>% filter(chromosome == "CM027508.1")#%>% filter(window_pos_1<50000001)

dxy_all[dxy_all$island=="isabela",]$island <- "Isabela"
dxy_all[dxy_all$island=="santacruz",]$island <- "Santa Cruz"
dxy_all[dxy_all$island=="sancristobal",]$island <- "San Cristobal"
dxy_all[dxy_all$island=="all_islands",]$island <- "All Islands"

#cbbPalette <- rep(c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"),4)
cbbPalette <- c(rep(c("grey50", "black","grey50", "black","grey50", "black"),5),"grey50")

ggplot(data=dxy_all, aes(x=window_pos_1, y= avg_dxy, color=chrOrder)) + 
  geom_point(show.legend = F, cex = 0.25)  + 
  ggtitle(paste("MYWA PiXY Dxy ", window_size, " Kb Windows ", sep="")) + 
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
  
  xlab("Position Along Chromosome")+
  ylab("Average Dxy")

ggplot(data=dxy_all,aes(x=no_sites,y=avg_dxy,color=island))+ geom_point(show.legend = F)+  facet_wrap(.~island)+xlab("Number of Sites in Window")+
  ylab("Average Window Dxy")


##Zoom in
chrom="CM027533.1"
ggplot(data=subset(dxy_all,chromosome==chrom), aes(x=position, y= avg_dxy)) + geom_point(show.legend = F)  + ggtitle(paste("MYWA PiXY Dxy ", window_size, " Kb Windows Chromosome ",chrom, sep="")) + facet_grid(island ~ .) + scale_colour_manual(values=cbbPalette)

###Fst

islands=c("isabela","santacruz","sancristobal","all_islands")


window_size="10"
date="2024-01-17"

fst_all <- data_frame() 
for (island in islands){
  wd<-(paste("/home/pkalhori/pixy/mywa_geo/",date,"/",window_size,"kb_window/",island,sep=""))
  fst_files <- list.files(wd,pattern="*_fst.txt", full.names=T)
  for (file in fst_files){
    fst_file <- read.csv(file,sep="\t")
    fst_file$island <- island
    fst_all <- rbind(fst_all,fst_file)
  }
  
}

fst_all <- subset(fst_all,chromosome!="CM019934.1")  %>% na.omit() 

chroms <- unique(fst_all$chromosome)

fst_all$chrOrder <- factor(fst_all$chromosome,levels=c( "CM027507.1" ,"CM027536.1","CM027508.1" ,"CM027509.1", "CM027510.1" ,"CM027537.1","CM027511.1" ,"CM027512.1", "CM027513.1", "CM027514.1" ,"CM027515.1","CM027516.1", "CM027517.1" ,"CM027518.1" ,"CM027519.1", "CM027520.1" ,"CM027521.1", "CM027522.1", "CM027523.1" ,"CM027524.1","CM027525.1", "CM027526.1", "CM027527.1" ,"CM027528.1" ,"CM027529.1" ,"CM027530.1", "CM027531.1", "CM027532.1" ,"CM027533.1","CM027534.1", "CM027535.1"  ))


cbbPalette <- rep(c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"),4)

unique(fst_all$island)
fst_all[fst_all$island=="isabela",]$island <- "Isabela"
fst_all[fst_all$island=="santacruz",]$island <- "Santa Cruz"
fst_all[fst_all$island=="sancristobal",]$island <- "San Cristobal"
fst_all[fst_all$island=="all_islands",]$island <- "All Islands"

ggplot(data=fst_all, aes(x=window_pos_1, y= avg_wc_fst, color=chromosome)) + 
  geom_point(show.legend = F, cex = 0.25)  + 
  ggtitle(paste("MYWA PiXY Fst ", window_size, " Kb Windows ", sep="")) + 
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
  xlab("Position Along Chromosome")+
  ylab("Weir & Cockerham's Fst")

fst_all$position <- paste(fst_all$chromosome,".",fst_all$window_pos_1,sep="")

fst_sancristobal <- subset(fst_all,island=="San Cristobal")
fst_top_sancristobal <- top_frac(fst_sancristobal,0.01,avg_wc_fst)


fst_santacruz <- subset(fst_all,island=="Santa Cruz")
fst_top_santacruz <- top_frac(fst_santacruz,0.01,avg_wc_fst)

fst_isabela<- subset(fst_all,island=="Isabela")
fst_top_isabela <- top_frac(fst_isabela,0.01,avg_wc_fst)

fst_allislands<- subset(fst_all,island=="All Islands")
fst_top_allislands <- top_frac(fst_allislands,0.01,avg_wc_fst)



fst_means <- fst_all %>% group_by(island) %>% summarise(mean_fst=mean(avg_wc_fst),max_fst=max(avg_wc_fst),sd_fst=sd(avg_wc_fst))

names(fst_means) <- c("Island","Mean Fst", "Maximum Fst", "Std. Dev. Fst")
fst_top <- fst_all %>% group_by(island) %>% top_frac(0.001,avg_wc_fst)
fst_top_counts_islands <- ungroup(fst_top) %>% subset(island!="All Islands") %>% count(position) 
fst_top_counts_all <- ungroup(fst_top)  %>% count(position) 
####Pi#####
pi_all <- data_frame()

for (island in islands){
  wd<-(paste("/home/pkalhori/pixy/mywa_geo/",date,"/",window_size,"kb_window/",island,sep=""))
  pi_files <- list.files(wd,pattern="*_pi.txt", full.names=T)
  for (file in pi_files){
    pi_file <- read.csv(file,sep="\t")
    pi_file$island <- island
    pi_all <- rbind(pi_all,pi_file)
  }
  
}



pi_all <- pi_all %>% subset(chromosome != "CM019934.1" | chromosome!= "CM02535.1") %>% na.omit()

pi_all$chrOrder <- factor(pi_all$chromosome,levels=c( "CM027507.1" ,"CM027536.1","CM027508.1" ,"CM027509.1", "CM027510.1" ,"CM027537.1","CM027511.1" ,"CM027512.1", "CM027513.1", "CM027514.1" ,"CM027515.1","CM027516.1", "CM027517.1" ,"CM027518.1" ,"CM027519.1", "CM027520.1" ,"CM027521.1", "CM027522.1", "CM027523.1" ,"CM027524.1","CM027525.1", "CM027526.1", "CM027527.1" ,"CM027528.1" ,"CM027529.1" ,"CM027530.1", "CM027531.1", "CM027532.1" ,"CM027533.1","CM027534.1"  ))

cbbPalette <- rep(c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"),4)



ggplot(data=pi_all, aes(x=window_pos_1, y= avg_pi, color=chrOrder)) + 
  geom_point(show.legend = F, cex = 0.25)  + 
  ggtitle(paste("MYWA PiXY Pi ", window_size, " Kb Windows ", sep="")) + 
  ggh4x::facet_grid2(pop ~ chrOrder,
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
  scale_y_continuous(expand = c(0, 0), limits = c(0,NA))



###Depths for Windows

contig_file <- read.csv("/home/pkalhori/mywa_geo_chromosomes_list.txt",header=F)

wd2 <- "/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/windowed_filtered_mean_depths/filtered_with_Monomorphic/"


depths_all <- data_frame()
for (i in seq(1,nrow(contig_file)-1)){
  chrom=contig_file[i,1]
  depth_avg <- read.csv(paste(wd2,chrom,"_filtered_with_Monomorphic_windowed_mean.depth",sep=""),sep = "\t")
  depth_avg$chromosome <- chrom
  depths_all <- rbind(depths_all, depth_avg)
}

depths_all$position <- paste(depths_all$chromosome, ".", depths_all$window_pos_1, sep="") 


merged_all <- merge(dxy_all,depths_all)



chrom <- "CM027517.1"



merged_all_subset <- merged_all   %>% subset(chromosome==chrom)  #%>% filter(window_pos_1>100000001)

ggplot(data=merged_all,aes(x=mean_depth,y=avg_dxy)) + geom_point()


ggplot(merged_all_subset,aes(x=window_pos_1,y=mean_depth/100))+geom_line() +  geom_point(data=merged_all_subset,aes(x=window_pos_1,y=avg_dxy,col="red"),show.legend = F) + ggtitle(paste(chrom," Dxy vs Mean Depth, 10kb windows")) 

ggplot(merged_all,aes(x=no_sites,y=avg_dxy))+geom_point() 

###Genotype props

wd3 <- "/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq_annotated/"


chrom <- "CM027523.1"
props_HWE <- read.csv(paste(wd3,chrom,"_filtered_allsites_HWE_strict_proportions.txt",sep=""),sep = "\t",header = F)
names(props_HWE) <- c("chrom","pos","hom_ref","hom_alt","het")

subsetted_props <- subset(props_HWE,pos>10000000)

ggplot(data=subsetted_props,aes(x=pos,y=het)) + geom_line()

props <- read.csv(paste(wd3,chrom,"_filtered_3_proportions.txt",sep=""),sep = "\t",header = F)
names(props) <- c("chrom","pos","hom_ref","hom_alt","het")



props$p <- props$hom_ref + props$het/2
props$q <- props$hom_alt + props$het/2
props$expected_het <- 2*props$p*props$q
props$het_diff <- props$het - props$expected_het


props_HWE$p <- props_HWE$hom_ref + props_HWE$het/2
props_HWE$q <- props_HWE$hom_alt + props_HWE$het/2
props_HWE$expected_het <- 2*props_HWE$p*props_HWE$q
props_HWE$het_diff <- props_HWE$het - props_HWE$expected_het

hist(props_HWE$het_diff)

props_subset <- subset(props_HWE,pos>2090001)  
props_subset <- subset(props_subset,pos<2100001)

ggplot(data=props,aes(x=pos,y=het,color="red")) + geom_line() 

dxy_subset <- subset(dxy_all,chromosome==chrom)



#####YEWA#######
islands=c("isabela","santacruz","sancristobal","all_islands")

window_size="10"

dxy_all <- data_frame()
for (island in islands){
  wd<-(paste("/home/pkalhori/pixy/yewa/",window_size,"kb_window/",island,sep=""))
  dxy_files <- list.files(wd,pattern="*_dxy.txt", full.names=T)
  for (file in dxy_files){
    dxy_file <- read.csv(file,sep="\t")
    dxy_file$island <- island
    dxy_all <- rbind(dxy_all,dxy_file)
  }
  
}

dxy_all$position <- paste(dxy_all$chromosome, ".", dxy_all$window_pos_1, sep="") 




cbbPalette <- rep(c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"),77)

ggplot(data=dxy_all, aes(x=position, y= avg_dxy, color=chromosome)) + geom_point(show.legend = F)  + ggtitle(paste("YEWA PiXY Dxy ", window_size, " Kb Windows",sep="")) + facet_grid(island~.) + scale_colour_manual(values=cbbPalette)

#dxy_top <- dxy_all[order(dxy_all$avg_dxy,decreasing = T),][1:round(dim(dxy_all)[1]*.01),]
##get top X% per island
dxy_top <- dxy_all %>% group_by(island) %>% top_frac(0.01,avg_dxy)
dxy_top_counts <- ungroup(dxy_top) %>% count(position) 


###Fst
fst_all <- data_frame()
for (island in islands){
  wd<-(paste("/home/pkalhori/pixy/yewa/",window_size,"kb_window/",island,sep=""))
  fst_files <- list.files(wd,pattern="*_fst.txt", full.names=T)
  for (file in fst_files){
    fst_file <- read.csv(file,sep="\t")
    fst_file$island <- island
    fst_all <- rbind(fst_all,fst_file)
  }
  
}

fst_all$position <- paste(fst_all$chromosome, ".", fst_all$window_pos_1, sep="") 

cbbPalette <- rep(c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"),77)

ggplot(data=fst_all, aes(x=position, y= avg_wc_fst, color=chromosome)) + geom_point(show.legend = F)  + ggtitle(paste("YEWA PiXY Fst ", window_size, " Kb Windows",sep="")) + facet_grid(island~.) + scale_colour_manual(values=cbbPalette)



fst_top <- fst_all %>% group_by(island) %>% top_frac(0.05,avg_wc_fst)
fst_top_counts <- ungroup(fst_top) %>% count(position) 


