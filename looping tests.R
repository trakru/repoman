install.packages("jsonlite")
library(jsonlite)
file <- "E:/Dropbox/BigData/cmts_list.csv"
df <- read.csv(file, stringsAsFactors = FALSE)
ipdf <- df$IP.address
# ipdf <- as.character(ipdf)
#ipdf[1]
#paste0("http://api.db-ip.com/v2/","aa24a1de20f1d6427938a0bf5cec066afa32f8a9","/",ipdf[1])

result <- data.frame(stringsAsFactors = FALSE)


nrow(df)

for(i in 1:nrow(df))
{
  url <- paste0("http://api.db-ip.com/v2/","aa24a1de20f1d6427938a0bf5cec066afa32f8a9","/",df$IP.address[i])
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

write.csv(df,"cmts-locations-us-all.csv", row.names = FALSE)



#ipdf2<-ipdf[101:200]
#ipdf2_url <- paste0(ipdf2,collapse = ",")
#url2 <- paste0("http://api.db-ip.com/v2/","aa24a1de20f1d6427938a0bf5cec066afa32f8a9","/",ipdf2_url)
#json_cmts2 <- fromJSON(url2)
#ipdf_url <- paste0(ipdf,collapse = ",")
#url <- paste0("http://api.db-ip.com/v2/","aa24a1de20f1d6427938a0bf5cec066afa32f8a9","/",ipdf_url)
#json_cmts <- fromJSON(url)

# ipdf_collapsed <- paste0(ipdf, collapse = ",")
# url <- paste0("http://api.db-ip.com/v2/","aa24a1de20f1d6427938a0bf5cec066afa32f8a9","/",ipdf_collapsed)
# json_cmts <- fromJSON(url)
# ipdf1 <- as.character(ipdf[1:100])
# ipdf1
# ipdf1_url <- paste0(ipdf1,collapse = ",")
# url1 <- paste0("http://api.db-ip.com/v2/","aa24a1de20f1d6427938a0bf5cec066afa32f8a9","/",ipdf1_url)
