
######Admixture#######

sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

###YEWA All Contigs, K=2

tbl=read.table("/home/pkalhori/plink/yewa_alignment/unsupervised_admixture/yewa_all_contigs.2.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Sex, tbl$V1),]

tbl2 <- cbind(newdata$V1,newdata$V2)

barplot(t(as.matrix(tbl2)),col=rainbow(2), xlab="Individual#",ylab="Ancestry",border=NA)

##YEWA All Contigs, K=3
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

tbl=read.table("/home/pkalhori/plink/yewa_alignment/unsupervised_admixture/yewa_all_contigs.3.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Island,tbl$V1),]

tbl2 <- cbind(newdata$V1,newdata$V2, newdata$V3)

barplot(t(as.matrix(tbl2)),col=rainbow(3), xlab="Individual#",ylab="Ancestry",border=NA)

#Admixture Supervised, YEWA Contigs

##In this run, all samples except for JC125 (San Cristobal) and JC94 (Isabela) were assigned to their respective island
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

tbl=read.table("/home/pkalhori/plink/yewa_alignment/supervised_admixture/plink2.3.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Island),]

tbl2 <- cbind(newdata$V1,newdata$V2, newdata$V3)

barplot(t(as.matrix(tbl2)),col=rainbow(3), xlab="Individual#",ylab="Ancestry",border=NA)

#MYWA Autosomes, K=2

sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

tbl=read.table("/home/pkalhori/plink/mywa_alignment/admixture/autosomes_only/plink2.2.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Island, tbl$V1),]

tbl2 <- cbind(newdata$V1,newdata$V2)

barplot(t(as.matrix(tbl2)),col=rainbow(3), xlab="Individual#",ylab="Ancestry",border=NA)

#MYWA Autosomes, K=3

sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")

tbl=read.table("/home/pkalhori/plink/mywa_alignment/admixture/autosomes_only/plink2.3.Q")
tbl<- cbind(tbl, sample_info)

tbl$Island <- factor(tbl$Island, levels = c("Isabela", "Santa Cruz","San Cristobal"))
newdata <- tbl[order(tbl$Island, tbl$V1),]

tbl2 <- cbind(newdata$V1,newdata$V2, newdata$V3)

barplot(t(as.matrix(tbl2)),col=rainbow(3), xlab="Individual#",ylab="Ancestry",border=NA)

