setwd("/home/pkalhori/angsd")
library(ggplot2)

association <- read.table("all_islands_score_asso_with_cov_max_depth.lrt0.gz", header=T)

sig_SNPs <- association[association$P<(.05/7700000),]

association$log10P <- log10(association$P)

association$Chr_Position <- paste(association$Chromosome, ".", association$Position, sep="")

association_plot <- ggplot(data = association, aes(x=Chr_Position, y=log10P)) + geom_point()

ggsave("all_islands_score_asso_with_cov_plot.pdf", association_plot)
