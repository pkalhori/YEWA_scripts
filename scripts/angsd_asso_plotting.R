setwd("/home/pkalhori/angsd")
library(ggplot2)


##ALL ISLANDS


association_pca <- read.table("all_islands_score_asso_with_cov_pca.lrt0.gz", header=T)

association_pca_filtered <- association_pca[association_pca$P<.001,]



association_pca_filtered$Chr_Position <- paste(association_pca_filtered$Chromosome, ".", association_pca_filtered$Position, sep="")
association_pca_filtered$log10P <- log10(association_pca_filtered$P)*-1
ggplot(data = association_pca_filtered, aes(x=Chr_Position, y=log10P, color=Chromosome))+ geom_point(show.legend = F)  + ggtitle("Score Association Test All Islands Highland vs Lowland, YEWA Contigs") + geom_hline(yintercept=8)


##SAN CRISTOBAL

san_cristobal_score_cov <- read.table("san_cristobal_score_asso_with_sex_cov.lrt0.gz", header = T)
  
san_cristobal_latent_cov <- read.table("san_cristobal_latent_asso_with_sex_cov.lrt0.gz", header=T)
  
san_cristobal_latent_no_cov <-read.table("san_cristobal_latent_asso_no_cov.lrt0.gz", header=T)

san_cristobal_lrt_no_cov <-read.table("san_cristobal_lrt_asso_no_cov.lrt0.gz", header=T)
san_cristobal_lrt_no_cov$Island <- "San_Cristobal"

##SANTA CRUZ

santa_cruz_score_cov <- read.table("santa_cruz_score_asso_with_sex_cov.lrt0.gz", header = T)

santa_cruz_latent_cov <- read.table("santa_cruz_latent_asso_with_sex_cov.lrt0.gz", header=T)

santa_cruz_latent_no_cov <-read.table("santa_cruz_latent_asso_no_cov.lrt0.gz", header=T)

santa_cruz_lrt_no_cov <-read.table("santa_cruz_lrt_asso_no_cov.lrt0.gz", header=T)
santa_cruz_lrt_no_cov$Island <- "Santa_Cruz"
##ISABELA

isabela_score_cov <- read.table("isabela_score_asso_with_sex_cov.lrt0.gz", header = T)

isabela_latent_cov <- read.table("isabela_latent_asso_with_sex_cov.lrt0.gz", header=T)

isabela_latent_no_cov <-read.table("isabela_latent_asso_no_cov.lrt0.gz", header=T)
isabela_lrt_no_cov <-read.table("isabela_lrt_asso_no_cov.lrt0.gz", header=T)
isabela_lrt_no_cov$Island <- "Isabela"

all_islands_lrt_no_cov <- rbind(san_cristobal_lrt_no_cov, santa_cruz_lrt_no_cov, isabela_lrt_no_cov) %>% subset(P<0.001)

all_islands_lrt_no_cov$Chr_Position <- paste(all_islands_lrt_no_cov$Chromosome, ".", all_islands_lrt_no_cov$Position, sep="")
all_islands_lrt_no_cov$log10P <- log10(all_islands_lrt_no_cov$P)*-1
association_plot <- ggplot(data = all_islands_lrt_no_cov, aes(x=Chr_Position, y=log10P, color=Chromosome))+ geom_point(show.legend = F) + facet_grid(Island~.) + ggtitle("Likelihood Ratio Test by Island Highland vs Lowland, YEWA Contigs") + geom_hline(yintercept=8)

ggsave("/home/pkalhori/by_island_lrt_asso_with_cov_plot.pdf", association_plot)
