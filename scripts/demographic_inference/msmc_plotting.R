

####smcpp####


smc_csv <- read.csv("/home/pkalhori/smcpp/all_dp5.csv")
smc_csv <- read.csv("/home/pkalhori/smcpp/all_dp5_newdistinguished.csv")

ggplot(smc_csv, aes(x = x, y = y, color = label, fill = label)) +
  geom_line(size=1)+
  scale_x_log10() +
  scale_y_log10()+
  labs(
    title = "SMC++ Ne Over Time, g=2 mu=4.6e-9",
    x = "Years ago",
    y = "Effective population size"
  ) +  theme_minimal()

####msmc####

pattern="_p1x2_15x1_1x2_"
date="20260317"

SAN <- c("JC105","JC108","JC116","JC119","JC120","JC121","JC122","JC123","JC125","JC127","JC131","KF6149","LF6101","LF6102","LF6119","LF6146","LF6148","PK01")
CRUZ <- c("JC64","JC65","JC66","JC67","JC68","JC69","LF6126","LF6127","LF6128","LF6129","LF6130","LF6131","LF6132","LF6134","LF6135","LF6137","LF6138","LF6139"
)


ISA <- c("JC70","JC71","JC77","JC78","JC79","JC80","JC83","JC86","JC87","JC90","JC91","JC92","JC93","JC94","JC95","JC96","JC97","JC98"
)

#JC105_p1x2_25x1_1x2_20260405.final.txt
SAN_msmc <- data.frame()
for (ind in SAN){
  file_name <- paste0("/home/pkalhori/msmc/noindels_minGQ_minDP5_miss0.9/",ind,"/",ind,pattern,date,".final.txt")
  if (file.exists(file_name)){
    file <- read.table(file_name,header=T)
    file$id <- ind
    file$island <- "SAN"
    SAN_msmc <- rbind(SAN_msmc,file)
  }
  else{
    print(ind)
    print("File doesn't exist")
  }
  #file<- read.table(paste0("/home/pkalhori/msmc/",ind,"_2025/",ind,"_filtered_autosomes.final.txt"),header=T)
  
}

CRUZ_msmc <- data.frame()
for (ind in CRUZ){
  file_name <- paste0("/home/pkalhori/msmc/noindels_minGQ_minDP5_miss0.9/",ind,"/",ind,pattern,date,".final.txt")
  if (file.exists(file_name)){
    file <- read.table(file_name,header=T)
    file$id <- ind
    file$island <- "CRUZ"
    CRUZ_msmc <- rbind(CRUZ_msmc,file)
  }
  else{
    print(ind)
    print("File doesn't exist")
  }
  #file<- read.table(paste0("/home/pkalhori/msmc/",ind,"_2025/",ind,"_filtered_autosomes.final.txt"),header=T)
  
}

ISA_msmc <- data.frame()
for (ind in ISA){
  file_name <- paste0("/home/pkalhori/msmc/noindels_minGQ_minDP5_miss0.9/",ind,"/",ind,pattern,date,".final.txt")
  if (file.exists(file_name)){
    file <- read.table(file_name,header=T)
    file$id <- ind
    file$island <- "ISA"
    ISA_msmc <- rbind(ISA_msmc,file)
  }
  else{
    print(ind)
    print("File doesn't exist")
  }
  #file<- read.table(paste0("/home/pkalhori/msmc/",ind,"_2025/",ind,"_filtered_autosomes.final.txt"),header=T)
  
}

all_msmc <- rbind(ISA_msmc,SAN_msmc,CRUZ_msmc)

mu <- 4.6e-9
gen <- 2


all_msmc <- all_msmc  %>%
  mutate(
    years_ago = left_time_boundary / mu * gen,
    Ne = (1 / lambda) / (2 * mu)
  )

summary_df <- all_msmc %>%
  group_by(island, time_index) %>%
  summarise(
    mean_Ne = mean(Ne, na.rm = TRUE),
    se_Ne = sd(Ne, na.rm = TRUE) / sqrt(n()),
    mean_years_ago = mean(years_ago, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(summary_df, aes(x = mean_years_ago, y = mean_Ne, color = island, fill = island)) +
  geom_line(size = 1) +
  geom_ribbon(aes(ymin = mean_Ne - se_Ne, ymax = mean_Ne + se_Ne), alpha = 0.2, color = NA) +
  scale_x_log10() +
  scale_y_log10()+
  labs(
    title = "MSMC Ne Over Time, g=2 mu=4.6e-9",
    x = "Years ago",
    y = "Effective population size"
  ) +
  theme_minimal()

ggplot(all_msmc, aes(x = years_ago, y = Ne, color = id, fill = id)) +
  geom_line(size = 1) +
  scale_x_log10() +
  #scale_y_log10()+
  labs(
    title = "MSMC Ne Over Time, g=2 mu=4.6e-9, autosomes only",
    x = "Years ago",
    y = "Effective population size"
  ) +
  theme_minimal()



###old msmc####


SAN <- c("JC105","JC108","JC116","JC119","JC120","JC121","JC122","JC123","JC125","JC127","JC131","KF6149","LF6101","LF6102","LF6119","LF6146","LF6148","PK01")
CRUZ <- c("JC64","JC65","JC66","JC67","JC68","JC69","LF6126","LF6127","LF6128","LF6129","LF6130","LF6131","LF6132","LF6134","LF6135","LF6137","LF6138","LF6139"
)


ISA <- c("JC70","JC71","JC77","JC78","JC79","JC80","JC83","JC86","JC87","JC90","JC91","JC92","JC93","JC94","JC95","JC96","JC97","JC98"
)
SAN_msmc <- data.frame()
for (ind in SAN){
  file_name <- paste0("/home/pkalhori/msmc/",ind,"/",ind,"_filtered_autosomes.final.txt")
  if (file.exists(file_name)){
    file <- read.table(file_name,header=T)
    file$id <- ind
    file$island <- "SAN"
    SAN_msmc <- rbind(SAN_msmc,file)
  }
  else{
    print(ind)
    print("File doesn't exist")
  }
  #file<- read.table(paste0("/home/pkalhori/msmc/",ind,"_2025/",ind,"_filtered_autosomes.final.txt"),header=T)
  
}

CRUZ_msmc <- data.frame()
for (ind in CRUZ){
  file_name <- paste0("/home/pkalhori/msmc/",ind,"/",ind,"_filtered_autosomes.final.txt")
  if (file.exists(file_name)){
    file <- read.table(file_name,header=T)
    file$id <- ind
    file$island <- "CRUZ"
    CRUZ_msmc <- rbind(CRUZ_msmc,file)
  }
  else{
    print(ind)
    print("File doesn't exist")
  }
  #file<- read.table(paste0("/home/pkalhori/msmc/",ind,"_2025/",ind,"_filtered_autosomes.final.txt"),header=T)
  
}

ISA_msmc <- data.frame()
for (ind in ISA){
  file_name <- paste0("/home/pkalhori/msmc/",ind,"/",ind,"_filtered_autosomes.final.txt")
  if (file.exists(file_name)){
    file <- read.table(file_name,header=T)
    file$id <- ind
    file$island <- "ISA"
    ISA_msmc <- rbind(ISA_msmc,file)
  }
  else{
    print(ind)
    print("File doesn't exist")
  }
  #file<- read.table(paste0("/home/pkalhori/msmc/",ind,"_2025/",ind,"_filtered_autosomes.final.txt"),header=T)
  
}

all_msmc <- rbind(ISA_msmc,SAN_msmc,CRUZ_msmc)

mu <- 4.6e-9
gen <- 2


all_msmc <- all_msmc  %>%
  mutate(
    years_ago = left_time_boundary / mu * gen,
    Ne = (1 / lambda) / (2 * mu)
  )

summary_df <- all_msmc %>%
  group_by(island, time_index) %>%
  summarise(
    mean_Ne = mean(Ne, na.rm = TRUE),
    se_Ne = sd(Ne, na.rm = TRUE) / sqrt(n()),
    mean_years_ago = mean(years_ago, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(summary_df, aes(x = mean_years_ago, y = mean_Ne, color = island, fill = island)) +
  geom_line(size = 1) +
  geom_ribbon(aes(ymin = mean_Ne - se_Ne, ymax = mean_Ne + se_Ne), alpha = 0.2, color = NA) +
  scale_x_log10() +
  #scale_y_log10()+
  labs(
    title = "MSMC Ne Over Time, g=2 mu=4.6e-9, autosomes only",
    x = "Years ago",
    y = "Effective population size"
  ) +
  theme_minimal()

ggplot(all_msmc, aes(x = years_ago, y = Ne, color = id, fill = id)) +
  geom_line(size = 1) +
  scale_x_log10() +
  #scale_y_log10()+
  labs(
    title = "MSMC Ne Over Time, g=2 mu=4.6e-9, autosomes only",
    x = "Years ago",
    y = "Effective population size"
  ) +
  theme_minimal()