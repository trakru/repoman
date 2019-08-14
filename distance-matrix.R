
##Wyandotte code

for(i in 1:nrow(wyandotte))
{
  #url <- URLencode("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=3200%20Biddle%20Ave,%20Wyandotte,%20MI%2048192&destinations=",wyandotte$geoAddress[i],"&key=my_key")
  url <- paste0("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=42.200700,-83.150991&destinations=",wyandotte$latlong[i],"&key=my_key")
  result <- fromJSON(url)
  wyandotte$distance[i] <- as.integer(result[["rows"]][["elements"]][[1]][["distance"]]$value)
  wyandotte$duration[i] <- as.integer(result[["rows"]][["elements"]][[1]][["duration"]]$value)
}

library(tidyverse)
by_st <- wyandotte %>% group_by(Street) #filtering for address groups by street (North/South)
by_st_23rd <- by_st %>% filter(Street== "23RD") %>% arrange(desc(distance)) #filtering only for 23rd street addresses
head(by_st_23rd$distance)
tail(by_st_23rd$distance)

