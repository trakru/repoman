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
#templog <- read_file("./data/XPDR/2018010114/newfolder/acr01.49thst.pa.panjde.comcast.net")
templog <- read.table("./data/XPDR/2018010114/newfolder/acr01.49thst.pa.panjde.comcast.net", sep = "~", header = FALSE)

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

#write final CSV
write.csv(templog, "acr01.49thst.pa.2018010114.csv")


#some business logic for converting colors to warnings
df <- df %>% mutate(status = case_when (V30 == "GREEN" & V32== "GREEN" ~ "ONLINE",
                                                  V30 == "RED" & V32=="RED" ~ "OFFLINE",
                                                  TRUE ~ "WARNING"))

#Pulling IPv6 address
ipv6 <- data.frame(og_pa$IPv6.address,stringsAsFactors = FALSE) 

for(i in 1:nrow(df))
{
  url <- paste0("http://api.db-ip.com/v2/",api,"/",df$IPv6.address[i])
  # Print("url repoman @ work")
  result <- fromJSON(url)
  df$continentCode[i] <- as.character(result[2])
  df$continentName[i] <- as.character(result[3])
  df$countryCode[i] <- as.character(result[4])
  df$countryName[i] <- as.character(result[5])
  df$stateProv[i] <- as.character(result[12])
  df$district[i] <- as.character(result[13])
  df$city[i] <- as.character(result[14])
  df$zipcode[i] <- as.character(result[16])
  df$latitude [i] <- as.character(result[17])
  df$longitude[i] <- as.character(result[18])
  df$timeZone[i] <- as.character(result[20])
  df$weatherCode <- as.character(result[21])
}



for(i in 1:10)
{
  url <- paste0("http://api.db-ip.com/v2/",api,"/",ipv6$og_pa.IPv6.address[i])
  result <- fromJSON(url)
  df$continentCode[i] <- as.character(result[2])
}
