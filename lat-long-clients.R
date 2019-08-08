install.packages("leaflet")
install.packages("sos")
install.packages("splitstackshape")
library(tidyverse)
library(sos)
library(leaflet)
library(splitstackshape)
dir_list <- data.frame(list.files(path="E:/Big Data/Archive/XPDR/XPDR_2018010114"), stringsAsFactors = FALSE)
colnames(dir_list) <- c("Files_2018010114")
dir_list$seq <- seq.int(nrow(dir_list))
all_cmts_names <- cSplit(dir_list,splitCols = "Files_2018010114",sep = ".", direction = "wide", drop = FALSE)
unique(all_cmts_names[,Files_2018010114_3])
#cmts_pa <- grepFn(".pa.", dir_list, column='Files_2018010114', ignore.case=FALSE)
cmts_pa <- all_cmts_names %>% filter(all_cmts_names$Files_2018010114_3==c("downingtown","pa","nj","njpa"))
write.csv(cmts_pa,"cmts-pa.csv")

##moving files on the bash script to a new folder for analysis
# cat cmtsmv.txt|while read file; do echo "Moving $file";mv ~/Documents/R/my-r-code/repoman/XPDR_2018010114/$file ~/Documents/R/my-r-code/repoman/XPDR_2018010114/newfolder; done^C
# dos2unix cmtsmv.txt
##read the file
#templog <- read_file("C:/Users/thetr/Documents/R/my-r-code/repoman/XPDR_2018010114/newfolder/acr01.49thst.pa.panjde.comcast.net")
templog <- read.table("C:/Users/thetr/Documents/R/my-r-code/repoman/XPDR_2018010114/newfolder/acr01.49thst.pa.panjde.comcast.net", sep = "~", header = FALSE)

#some renaming
names(templog)[names(templog) == 'V1'] <- 'MAC address'
names(templog)[names(templog) == 'V2'] <- 'CMTS address'
names(templog)[names(templog) == 'V3'] <- 'IP address'                          
names(templog)[names(templog) == 'V5'] <- 'Physical address'

#cleanup on names
templog$`Physical address`<- gsub("X _", "",templog$`Physical address`)
templog$`Physical address`<- gsub("_", ",",templog$`Physical address`)
templog$`Physical address`<- gsub(" X ", " & ",templog$`Physical address`)

#Reverse GeoCode
library(ggmap)
api <- readLines("GoogleMaps.api")
register_google(key=api)
getOption("ggmap")
locations <- templog$`Physical address`
tempfile2 <- geocode(locations)
templog$longitude <- tempfile2$lon
templog$latitude <- tempfile2$lat


