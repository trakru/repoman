library(stringr)
df <- read.table('./data/og1600/TONNAGE-logs/biglogfile.log', sep = "=", fill = TRUE, stringsAsFactors = FALSE)
og_pa <- read.csv('./data/final/og-pa-NEW.csv', stringsAsFactors = FALSE, header = TRUE)
df$V2 <- str_trim(df$V2, side = c("both")) #removing whitespace
df$date <- substr(df$V1,1,8) #new date columns because cSplit was not working
df$time <- substr(df$V1,10,15) #same as arm(z)bove
library(lubridate)
df$date <- ymd(df$date)

##major df cleanup process. shitty code ensues

df <- df %>% separate(V3, into = c("DL","UL"), sep="MB")
df <- df %>% separate(DL, into = c("A1","A2","A3","A4"), sep = "\\s")
df$A4 <- ifelse(df$A4== "", df$A3,df$A4)
df <- df[,-3] #going once
df <- df[,-3] #sold
colnames(df) <- c("datetime","MAC address","DL","UL","Date","Time")


##formatting code
df$DL <- as.integer(df$DL) #coercing NAs
df$UL <- as.integer(df$UL) #coercing NAs
df <- na.omit(df) #remove NAs


