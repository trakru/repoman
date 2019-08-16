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

df$datetime <- gsub("T","",df$datetime) #removing the annoying T
df$datetime_f <- strptime(df$datetime,tz = "EST", format = "%Y%m%d%H%M%S") #datetime POSIX formatting

#final libraries
library(reshape)
library(dplyr)
library(ggplot2)

#endgame - Download data
df_dl$index <- format(round(df_dl$datetime_f, units="hours"), format="%Y-%m-%d %H:%M")
list <- unique(df_dl$index)
list_mac <- unique(df_dl$`MAC address`)
dldata <- melt(df_dl, id=c('MAC address','index'))
df_dl <- df_dl[,-3]
timemeans <- cast(dldata, index~variable, mean)
timesum <- cast(dldata, index~variable, sum)
colnames(dldata)[colnames(dldata)=="MAC address"] <- "MACaddress"
macmeans <- cast(dldata, MACaddress~variable, mean)
macmeans$DL<- as.integer(macmeans$DL)
macsum <- cast(dldata, MACaddress~variable, sum)
write.csv(timesum, file = './data/final/reshape/timesum.csv')
write.csv(timemeans, file = './data/final/reshape/timemeans.csv')
write.csv(macsum, file = './data/final/reshape/macsum.csv')
write.csv(macmeans, file = './data/final/reshape/macmeans.csv')

#endgame - UL data
df_ul<- df %>% select(`MAC address`,'UL',datetime_f)
df_ul$index <- format(round(df_ul$datetime_f, units="hours"), format="%Y-%m-%d %H:%M")
df_ul <- df_ul[,-3]
uldata <- melt(df_ul, id=c('MAC address','index'))
uldata$DATE <- as.POSIXct(uldata$index, format = "%Y-%m-%d %H:%M")
daily_uldata <- uldata %>% mutate(day= as.Date(DATE, format = "%Y-%m-%d"))
daily_uldata_mac_day <- daily_uldata %>% group_by(day,`MAC address`) %>% summarise(total_UL=sum(value)) %>% na.omit()
colnames(daily_uldata)[colnames(daily_uldata)=="MAC address"] <- "MACaddress"
x <- cast(daily_uldata, MACaddress~value+day)

#environment cleanup
library(gdata)
keep(df)
keep(df,sure = TRUE)


#restarting from df
str(df)
colnames(df)[colnames(df)=="MAC address"] <- "MACaddress" #removing space
df_format <- df%>% select('MACaddress','DL','UL','Date',datetime_f)
unique(df_format$Date)
# x <- seq(as.Date(as.character(20190130),format="%Y%m%d"),as.Date(as.character(20190212),format="%Y%m%d"), by = "day")
# df_format_14 <- df_format %>% select(df_format$Date %in% x) 
df_format <- df_format[-4]
md <- melt(df_format, id=c("ID","datetime_f"))
md$datetime_f <- as.POSIXct(md$datetime_f, format = "%Y-%m-%d")
md <- md %>% mutate(day=as.Date(datetime_f, format = "%Y-%m-%d"))

#splitting into 4
md_1 <- md[1:3380125,]
md_1 <- cast(md_1, ID~variable+day, fun.aggregate = sum)
write.csv(md_1, file = './data/final/OG_1of4.csv')
md_2 <- md[3380126:6760250,]
md_2 <- cast(md_2, ID~variable+day, fun.aggregate = sum)
write.csv(md_2, file = './data/final/OG_2of4.csv')
md_3 <- md[6760251:10140377,]
md_3 <- cast(md_3, ID~variable+day, fun.aggregate = sum)
write.csv(md_3, file = './data/final/OG_3of4.csv')
md_4 <- md[10140378:13520498,]
md_4 <- cast(md_4, ID~variable+day, fun.aggregate = sum)  
write.csv(md_4, file = './data/final/OG_4of4.csv')

#merge dataframes
md_DL <- merge(md_1,md_2, by = "ID")
md_DL <- md_DL[,-21]
md_UL <- merge(md_3,md_4, by = "ID")

#generating column name list
list <- seq(as.Date(as.character(20190129),format="%Y%m%d"),as.Date(as.character(20190216),format="%Y%m%d"), by = "day")
list <- as.character(list)
list <- c("ID",list)
names(md_DL) <- list
names(md_UL) <- list
write.csv(md_DL, file = './data/final/OG_DL.csv')
write.csv(md_UL, file = './data/final/OG_UL.csv')

