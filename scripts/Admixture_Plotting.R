setwd("/home/pkalhori/plink/mywa_geo_alignment/reseq/admixture")
#MYWA Autosomes, K=2

sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")


tbl=read.table("all_autosomes.2.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Island, tbl$V1),]

tbl2 <- cbind(newdata$V1,newdata$V2)

barplot(t(as.matrix(tbl2)),col=rainbow(3), xlab="Individual#",ylab="Ancestry",border=NA)

##Using PopHelper
library(pophelper)
library(gridExtra)
wd<-"/home/pkalhori/plink/mywa_geo_alignment/reseq/admixture"
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

#sfiles <- list.files(path=system.file("files/structure-ci",package="pophelper"),full.names=TRUE)
sfiles <- list.files(wd,pattern="*.Q", full.names=T)

slist <- readQ(files=sfiles, indlabfromfile=F)
if(length(unique(sapply(slist,nrow)))==1) slist <- lapply(slist,"rownames<-",sample_info$ID)
head(slist[[1]])
tr1 <- tabulateQ(qlist=slist)
sr1 <- summariseQ(tr1)
slist1 <- alignK(slist)

groups <- data.frame(sample_info$Island,sample_info$Elevation)

names(groups) <- c("Island","Elevation")


#groups$Island <- NA

groups[groups$Island=="Isabela",]$Island <- "1)Isabela"
groups[groups$Island=="Santa Cruz",]$Island <- "2)Santa Cruz"
groups[groups$Island=="San Cristobal",]$Island <- "3)San Cristobal"

groups <- data.frame(groups$Island)
names(groups) <- "Island"

# modified for this document
p1 <- plotQ(slist1[c(2,3,4)],imgoutput="join",returnplot=T,exportplot=F,basesize=11,
            grplab=groups,ordergrp = T,showgrplab =F,grplabsize=4,linesize=0.8,pointsize=3,sharedindlab=F,sortind="all",showindlab=F,useindlab = T,splab = c("K=2","K=3","K=4"))
grid.arrange(p1$plot[[1]])

p2 <- plotQ(slist1[2],returnplot=T,exportplot=F,basesize=11,
            grplab=groups,selgrp="Island",ordergrp = T,grplabsize=4,linesize=0.8,pointsize=3,sharedindlab=F,sortind="Cluster1",showindlab=F,useindlab = T,splab = "K=2",showgrplab =F)
grid.arrange(p2$plot[[1]])

p3 <- plotQ(slist1[3],returnplot=T,exportplot=F,basesize=11,
            grplab=groups,selgrp="Island",ordergrp = T,grplabsize=4,linesize=0.8,pointsize=3,sharedindlab=F,sortind="all",showindlab=F,useindlab = T,splab = "K=3",showgrplab =F)
grid.arrange(p3$plot[[1]])

p4 <- plotQ(slist1[4],returnplot=T,exportplot=F,basesize=11,
            grplab=groups,selgrp="Island",ordergrp = T,grplabsize=4,linesize=0.8,pointsize=3,sharedindlab=F,sortind="all",showindlab=F,useindlab = T,splab = "K=4",showgrplab =F)
grid.arrange(p4$plot[[1]])
