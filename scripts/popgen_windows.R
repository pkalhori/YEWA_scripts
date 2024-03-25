setwd("/home/pkalhori/popgen_windows/")

contig_file <- read.csv("/home/pkalhori/mywa_geo_chromosomes_split_regions_list.txt",header=F)

chrom <- contig_file[5,1]


isabela <- read.csv(paste("Isabela_",chrom,".csv",sep = ""))
santacruz <- read.csv(paste("SantaCruz_",chrom,".csv",sep = ""))
sancristobal <- read.csv(paste("SantaCristobal_",chrom,".csv",sep = ""))

ggplot(data=isabela,aes(x=start,y=dxy_Isabella_Highland_Isabella_Lowland),legend=T) + geom_point() + geom_point(data=santacruz,aes(x=start,y=dxy_SantaCruz_Highland_SantaCruz_Lowland),color="red") + geom_point(data=sancristobal,aes(x=start,y=dxy_SanCristobal_Highland_SanCristobal_Lowland),color="blue") 

