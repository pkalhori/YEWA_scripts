install.packages("vcfR")
library(vcfR)
?vcfR::vcfR2genlight()
test_vcf <- read.vcfR("test.vcf")

g1 <- gl.read.vcf("/Users/poonehkalhori/Library/CloudStorage/OneDrive-SanFranciscoStateUniversity/YEWA_analysis/test.vcf")
?
test <- write.csv(g1,"test.csv")
g2 <- read.csv("/Users/poonehkalhori/Library/CloudStorage/OneDrive-SanFranciscoStateUniversity/YEWA_analysis/test.csv")

metadata <- read.csv("/Users/poonehkalhori/Library/CloudStorage/OneDrive-SanFranciscoStateUniversity/YEWA_analysis/samples_pop_info.csv")

gl <- gl.read.dart(filename = "test_genlight.csv", ind.metafile = "samples_pop_info.csv", topskip=0)
?gl.read.dart
