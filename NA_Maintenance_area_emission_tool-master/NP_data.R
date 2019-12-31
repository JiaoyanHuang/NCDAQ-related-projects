library(ggplot2)
path <- "C:/Users/jhuang/Desktop/Projects/2014fd NEI annual gridded files"

NP_file <- sprintf("%s/NP_mask.csv",path)
Haywood_file <- sprintf("%s/Haywood_mask.csv",path)
Swain_file <- sprintf("%s/Swain_mask.csv",path)
twocounty_file <- sprintf("%s/GSMNP_2county.csv",path)

NP <- read.csv(NP_file,stringsAsFactors = F)
Haywood <- read.csv(Haywood_file,stringsAsFactors = F)
Swain <- read.csv(Swain_file,stringsAsFactors = F)
FC <- read.csv(twocounty_file,stringsAsFactors = F)

NP$value <- 0
NP$FIPS  <- 0
NP$FC_value <- 0

for(i in 1:length(NP$COL)){
  if(length(FC[which(FC$COLROW == NP$COLROW[i]),6]) == 1){
    NP$value[i] <- FC[which(FC$COLROW == NP$COLROW[i]),6]
    NP$FIPS[i] <- FC[which(FC$COLROW == NP$COLROW[i]),2]
  }else{
    NP$value[i] <- sum(FC[which(FC$COLROW == NP$COLROW[i]),6])
    NP$FIPS[i] <- "Two counties"
  }
}

file <- "C:/Users/jhuang/Desktop/Projects/2014fd NEI annual gridded files/GSMNP_cell.csv"
GSMNP <- read.csv(file,stringsAsFactors = F)
file <- "C:/Users/jhuang/Desktop/Projects/2014fd NEI annual gridded files/GSMNP_2county.csv"
county <- read.csv(file,stringsAsFactors = F)


ggplot() +
  geom_polygon(data = county_t, aes(x = long, y = lat, group = group)) +
  geom_point(data =NP, aes(x = LON, y = LAT),color = "red") +
  geom_point(data =Swain, aes(x = LON, y = LAT),color = "green") +
  geom_point(data =Haywood, aes(x = LON, y = LAT),color = "blue") 
  

library(urbnmapr)
library(tidyverse)
library(oce)

countyinfo <- counties
county1 <- countyinfo[which(countyinfo$county_fips == 37087),c(1,2)]
county2 <- countyinfo[which(countyinfo$county_fips == 37173),c(1,2)]

county1_t <- countyinfo[which(countyinfo$county_fips == 37087),]
county2_t <- countyinfo[which(countyinfo$county_fips == 37173),]
county_t <- rbind(county1_t,county2_t)