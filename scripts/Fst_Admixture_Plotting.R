
######Admixture#######

sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

tbl=read.table("/home/pkalhori/admixture_files/mywa_alignment/plink2.2.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Island, tbl$V1),]

tbl2 <- cbind(newdata$V1,newdata$V2)

barplot(t(as.matrix(tbl2)),col=rainbow(2), xlab="Individual#",ylab="Ancestry",border=NA)

##K2
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

tbl=read.table("/home/pkalhori/plink/yewa_alignment/unsupervised_admixture/plink2.2.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Sex,tbl$V1),]

tbl2 <- cbind(newdata$V1,newdata$V2, newdata$V3)

barplot(t(as.matrix(tbl2)),col=rainbow(3), xlab="Individual#",ylab="Ancestry",border=NA)

#Admixture Supervised#
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

tbl=read.table("/home/pkalhori/plink/yewa_alignment/supervised_admixture/plink2.3.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Island),]

tbl2 <- cbind(newdata$V1,newdata$V2, newdata$V3)

barplot(t(as.matrix(tbl2)),col=rainbow(3), xlab="Individual#",ylab="Ancestry",border=NA)


