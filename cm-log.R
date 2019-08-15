df <- read.table('./data/cmts/acr01.49thst.pa.panjde.comcast.net', sep = "~", fill=TRUE) #using fill because...errors
nrow(df) #what we're dealing with. ~ 22k units
names(df)[names(df) == 'V14'] <- 'Product Description' #human readable names
library(splitstackshape) #because rows> column split
library(dplyr) #duh

#find all OGs
df_og <- df %>% filter (grepl("OUTDOOR", df$`Product Description`)) #method 1
df_og <- df %>% filter (`V16`== "OG1600A") #method 2

#both methods produce only 11 OGs in the area, out of 21,113 observed values

dir_list <- data.frame(list.files(path="E:/Big Data/Archive/CMFILES/CM_20180501_1"), stringsAsFactors = FALSE) # look at folder
colnames(dir_list) <- c("CM_20180501_1") #change header
cm_pa <- dir_list %>% filter(grepl("pa", dir_list$CM_20180501_1)) #only PA CMTS


