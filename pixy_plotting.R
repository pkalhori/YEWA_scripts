wd<-("/home/pkalhori/pixy")

fst_files<-list.files(wd,pattern="*_fst.txt", full.names=T)

dxy_files <- list.files(wd,pattern="*_dxy.txt", full.names=T)

pi_files <- list.files(wd,pattern="*_pi.txt", full.names=T)

fst_all <- data_frame()

for (file in fst_files){
  fst_file <- read.csv(file,sep="\t")
  fst_all <- rbind(fst_all,fst_file)
}

pi_all <- data_frame()

for (file in pi_files){
  pi_file <- read.csv(file,sep="\t")
  pi_all <- rbind(pi_all,pi_file)
}
