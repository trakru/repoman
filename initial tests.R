install.packages("jsonlite")
library(jsonlite)
file <- "E:/Dropbox/BigData/cmts_list.csv"
df <- read.csv(file)
api <- readLines("db-ip.api")
ipdf <- df$IP.address
ipdf <- as.character(ipdf)

ipdf2<-ipdf[101:200]
ipdf2_url <- paste0(ipdf2,collapse = ",")
url2 <- paste0("http://api.db-ip.com/v2/",api,"/",ipdf2_url)
json_cmts2 <- fromJSON(url2)








#ipdf_url <- paste0(ipdf,collapse = ",")
#url <- paste0("http://api.db-ip.com/v2/",api,"/",ipdf_url)
#json_cmts <- fromJSON(url)

# ipdf_collapsed <- paste0(ipdf, collapse = ",")
# url <- paste0("http://api.db-ip.com/v2/",api,"/",ipdf_collapsed)
# json_cmts <- fromJSON(url)
# ipdf1 <- as.character(ipdf[1:100])
# ipdf1
# ipdf1_url <- paste0(ipdf1,collapse = ",")
# url1 <- paste0("http://api.db-ip.com/v2/",api,"/",ipdf1_url)
