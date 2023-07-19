
###Plink PCA
setwd("/home/pkalhori/plink/mywa_geo_alignment/plink_pca/")


library(tidyverse)
pca <- read_table("./all_autosomes_filtered.eigenvec", col_names = FALSE)
eigenval <- scan("./all_autosomes_filtered.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
##PC 1 explains ~8%, PC 2 explains ~6%
sample_info <- read.csv("/home/pkalhori/sample_info/samples_pop_info.csv")
pca_with_info <- cbind(sample_info, pca)
ggplot(pca_with_info, aes(PC1, PC2, col=Sex, label=ind)) + geom_point(size = 3) + ggtitle("Plink PCA All Autosomes, S. Coronata Alignment w G. Trichas W") + geom_text(nudge_x=.005, nudge_y = .001, check_overlap = F, size=1.5)

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
