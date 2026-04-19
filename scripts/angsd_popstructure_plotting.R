sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")
sample_info$Year <- as.factor(sample_info$Year)

C <- as.matrix(read.table("/home/pkalhori/angsd/mywa_geo_alignment/pcangsd/mywa_geo_autosomes_20250612.cov"))
e <- eigen(C)               

PC <- data.frame(e$vectors[,1:6]) 
names(PC) <- c("PC1","PC2","PC3","PC4","PC5","PC6")
pca_with_info <- cbind(sample_info, PC)

ggplot(pca_with_info, aes(PC1, PC6, col=Elevation,label=ID,shape=Island)) + geom_point(size = 3)  + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5) +xlab("PC1") + ylab("PC2") + ggtitle("PCANGSD PCA")

tbl2=read.table("/home/pkalhori/angsd/mywa_geo_alignment/ngsadmix/mywa_geo_autosomes_20250612_k2.qopt")
tbl2<- cbind(tbl2, sample_info)

tbl2$Island <- factor(tbl2$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata2 <- tbl2[order(tbl2$Island, tbl2$V1),]

tbl2 <- cbind(newdata2$V1,newdata2$V2)

barplot(t(as.matrix(tbl2)),col=rainbow(4), xlab="Individual#",ylab="Ancestry",border=NA,main="K=2 NGSAdmix")
##K3
tbl3=read.table("/home/pkalhori/angsd/mywa_geo_alignment/mywa_geo_autosomes_k5.qopt")
tbl3<- cbind(tbl3, sample_info)

tbl3$Island <- factor(tbl3$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata3 <- tbl3[order(tbl3$Island, tbl3$V2),]

tbl3 <- cbind(newdata3$V1,newdata3$V2,newdata3$V3,newdata3$V4,newdata3$V5)

barplot(t(as.matrix(tbl3)),col=rainbow(5), xlab="Individual#",ylab="Ancestry",border=NA,main="K=2 NGSAdmix")


##Using PopHelper
library(pophelper)
library(gridExtra)
wd<-"/home/pkalhori/angsd/mywa_geo_alignment/ngsadmix/20250612"
setwd(wd)
data<-list.files(wd, pattern = ".log", full.names = T)

bigData<-lapply(1:5, FUN = function(i) readLines(data[i]))

foundset<-sapply(1:5, FUN= function(x) bigData[[x]][which(str_sub(bigData[[x]], 1, 1) == 'b')])
as.numeric( sub("\\D*(\\d+).*", "\\1", foundset) )
logs<-data.frame(K = rep(1:5, each=1))
logs$like<-as.vector(as.numeric( sub("\\D*(\\d+).*", "\\1", foundset) ))

tapply(logs$like, logs$K, FUN= function(x) mean(abs(x))/sd(abs(x)))

sfiles <- list.files(wd,pattern=" *.qopt", full.names=T)

slist <- readQ(files=sfiles, indlabfromfile=F)
if(length(unique(sapply(slist,nrow)))==1) slist <- lapply(slist,"rownames<-",sample_info$ID)
head(slist[[1]])
tr1 <- tabulateQ(qlist=slist)
sr1 <- summariseQ(tr1)
slist1 <- alignK(slist)

groups <- data.frame(sample_info$Island,sample_info$Elevation)

names(groups) <- c("Island","Elevation")


#groups$Island <- NA

groups[groups$Island=="Isabela",]$Island <- "1) Isabela"
groups[groups$Island=="Santa Cruz",]$Island <- "2) Santa Cruz"
groups[groups$Island=="San Cristobal",]$Island <- "3) San Cristobal"

groups <- data.frame(groups$Island)
names(groups) <- c("Island")

# modified for this document
p1 <- plotQ(slist1[c(1,2,3,4,5)],imgoutput="join",returnplot=T,exportplot=F,basesize=11,
            grplab=groups,ordergrp = T,showgrplab =T,grplabsize=4,linesize=0.8,pointsize=3,sharedindlab=F,showindlab=T,useindlab = T,splab = c("K=2","K=3","K=4","K=5","K=6"),titlelab = "NGSAdmix",showtitle = T)
grid.arrange(p1$plot[[1]])
