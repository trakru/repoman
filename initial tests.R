install.packages("jsonlite")
library(jsonlite)
file <- "E:/Dropbox/BigData/cmts_list.csv"
df <- read.csv(file)
ipdf <- df$IP.address
ipdf <- as.character(ipdf)

ipdf2<-ipdf[101:200]
ipdf2_url <- paste0(ipdf2,collapse = ",")
url2 <- paste0("http://api.db-ip.com/v2/","aa24a1de20f1d6427938a0bf5cec066afa32f8a9","/",ipdf2_url)
json_cmts2 <- fromJSON(url2)








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
