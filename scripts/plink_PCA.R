
###Plink PCA, pruned for LD (50, 10, 0.1)
setwd("/home/pkalhori/plink/yewa_alignment/plink_pca/LD_pruned")


library(tidyverse)
pca <- read_table("./pruned_yewa.eigenvec", col_names = FALSE)
eigenval <- scan("./pruned_yewa.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
##PC 1 explains ~8%, PC 2 explains ~6%
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")
pca_with_info <- cbind(sample_info, pca)
ggplot(pca_with_info, aes(PC1, PC2, col=Sex)) + geom_point(size = 3)

##Plink PCA, not pruned for LD

setwd("/home/pkalhori/plink/yewa_alignment/plink_pca")


library(tidyverse)
pca <- read_table("./yewa.eigenvec", col_names = FALSE)
eigenval <- scan("./yewa.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
##PC 1 explains ~8%, PC 2 explains ~6%
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")
pca_with_info <- cbind(sample_info, pca)
ggplot(pca_with_info, aes(PC1, PC2, col=Island, label=ind)) + geom_point(size = 3) + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)

##Plink PCA, pruned for LD (50, 10, 0.5)
setwd("/home/pkalhori/plink/yewa_alignment/plink_pca/LD_pruned_0.5")


library(tidyverse)
pca <- read_table("./pruned_yewa.eigenvec", col_names = FALSE)
eigenval <- scan("./pruned_yewa.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
##PC 1 explains ~8%, PC 2 explains ~6%
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")
pca_with_info <- cbind(sample_info, pca)
ggplot(pca_with_info, aes(PC1, PC2, col=Island, label=ind)) + geom_point(size = 3) + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)
