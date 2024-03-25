depth_all <- data_frame()
wd<-"/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq/depths/"
setwd(wd)

chrom="CM027507.1"

depth_ch <- read.csv(paste(wd,"chromosome_",chrom,"_total_site_depth",sep=""),sep="\t",header=F)
names(depth_ch) <- c("chromosome","pos","depth")
depth_ch$position <- paste(depth_ch$chromosome, ".", depth_ch$pos, sep="") 

num_iter <- ceiling(max(depth_ch$pos)/10000)

depth_avg_all <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(depth_avg_all) <- c("window_pos_1","window_pos_2","mean_depth")
for (i in seq(1,num_iter)){
  depth_iter <- depth_ch[(i-1)*10000 < depth_ch$pos & depth_ch$pos < i*10000,]
  depth_avg_iter <- data.frame(matrix(ncol = 3, nrow = 1))
  colnames(depth_avg_iter) <- c("window_pos_1","window_pos_2","mean_depth")
  depth_avg_iter$mean_depth <- mean(depth_iter$depth)  
  depth_avg_iter$window_pos_1 <- (i-1)*10000 + 1
  depth_avg_iter$window_pos_2 <- i*10000 
  depth_avg_all <- rbind(depth_avg_all,depth_avg_iter)
}

depth_avg_all$chromosome <- chrom




write.csv(depth_avg_all,paste("/home/pkalhori/mpileup/calls_mywa_geo_alignment_reseq/depths/chromosome_",chrom,"_windowed_depth",sep=""))
