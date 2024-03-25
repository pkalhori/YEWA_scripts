
###Plink PCA
setwd("/home/pkalhori/plink/mywa_geo_alignment/reseq/plink_pca")
#setwd("/home/pkalhori/plink/mywa_alignment/plink_pca")
#All islands
library(tidyverse)
pca <- read_table("./all_autosomes_HWE.eigenvec", col_names = FALSE)
eigenval <- scan("./all_autosomes_HWE.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ID"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
##PC 1 explains ~8%, PC 2 explains ~6%
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")
sample_info$Year <- as.factor(sample_info$Year)
pca_with_info <- merge(sample_info, pca)
ggplot(pca_with_info, aes(PC1, PC3, col=Elevation,label=ID,shape=Island)) + geom_point(size = 3)  + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5) +xlab("PC1 (7%)") + ylab("PC3 (5.2%)")


#write.csv(pca,"/home/pkalhori/plink/mywa_geo_alignment/plink_pca/pc_with_label.csv")




####PC testing


##Comparing PC 3 with Elevation Categories
t.test(pca_with_info$PC4~sample_info$Elevation)
summary(lm(pca_with_info$PC3~sample_info$Elevation*sample_info$Island))
anova(lm(pca_with_info$PC2~sample_info$Elevation*sample_info$Island))

ggplot(pca_with_info,aes(x=Elevation,y=PC2)) + geom_boxplot()

##PC 3 versus Elevation Values
summary(lm(formula = pca_with_info$PC3 ~ sample_info$Elevation_Values))
#with island interaction
summary(lm(pca_with_info$PC3~sample_info$Elevation_Values*sample_info$Island))
anova(lm(pca_with_info$PC3~sample_info$Elevation_Values*sample_info$Island))
#Plot
ggplot(pca_with_info,aes(x=Elevation_Values,y=PC2)) + geom_point() + geom_smooth(method = "lm")




#San Cristobal
pca <- read_table("./sancristobal.eigenvec", col_names = FALSE)
eigenval <- scan("./sancristobal.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ID"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pve <- data.frame(PC = 1:18, pve = eigenval/sum(eigenval)*100)
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv") %>% filter( Island=="San Cristobal")
sample_info$Year <- as.factor(sample_info$Year)
pca_with_info <- merge(sample_info, pca)
ggplot(pca_with_info, aes(PC1, PC3, col=Elevation, shape=Elevation,label=ID)) + geom_point(size = 3)  + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)

#Isabela
pca <- read_table("./isabela.eigenvec", col_names = FALSE)
eigenval <- scan("./isabela.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ID"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pve <- data.frame(PC = 1:18, pve = eigenval/sum(eigenval)*100)
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv") %>% filter( Island=="Isabela")
sample_info$Year <- as.factor(sample_info$Year)
pca_with_info <- merge(sample_info, pca)
ggplot(pca_with_info, aes(PC1, PC3, col=Elevation, shape=Elevation,label=ID)) + geom_point(size = 3)  + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)

#Santa Cruz
pca <- read_table("./santacruz.eigenvec", col_names = FALSE)
eigenval <- scan("./santacruz.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ID"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pve <- data.frame(PC = 1:18, pve = eigenval/sum(eigenval)*100)
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv") %>% filter( Island=="Santa Cruz")
sample_info$Year <- as.factor(sample_info$Year)
pca_with_info <- merge(sample_info, pca)
ggplot(pca_with_info, aes(PC4, PC5, col=Elevation, shape=Elevation,label=ID)) + geom_point(size = 3)  + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)


