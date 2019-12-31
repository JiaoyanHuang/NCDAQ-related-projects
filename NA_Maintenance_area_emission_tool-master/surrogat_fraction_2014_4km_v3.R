library(data.table)
library(ncdf4)
library(stringr)
library(urbnmapr)
library(tidyverse)
library(oce)
library(ggplot2)

path <- "C:/Users/jhuang/Desktop/Projects/2014fd NEI annual gridded files"
GRID <- "CONUS4k_GRIDCRO2D" #"2014fd_nata_GRIDCRO2D" #GRIDCRO2D file
file1 <- sprintf("%s/%s",path, GRID)
REAL <- "long_lat_NP.csv" #NP long_lat file
file2 <- sprintf("%s/%s",path,REAL)
SF_folder <- "4km surrogate files/surrogates_CONUS4_2014_v1.14_14oct2016/ge_dat/gridding/CONUS4_2014_v1.14_14Oct2016" #surrogate folder
path_SF <- sprintf("%s/%s",path,SF_folder)
# SF_code <- c("100_NOFILL","260_FILL","260_NOFILL","202_FILL","212_FILL") #surrogate codes
# SF_DESC <- c("Population","TRRM","TRRM_NF","URA","RRA") #surrogate description
SF_list_file <- sprintf("%s/Surrogate_file_list.csv",path)
SF_list <- read.csv(SF_list_file,stringsAsFactors = F)
SF_code <- paste(SF_list$CODE,"NOFILL",sep="_")
SF_DESC <- SF_list$DESCRIPTION

NP_file <- sprintf("%s/NP_mask.csv",path)
Haywood_file <- sprintf("%s/Haywood_mask.csv",path)
Swain_file <- sprintf("%s/Swain_mask.csv",path)
BOX_file <- sprintf("%s/BOX_mask.csv",path)


NP <- read.csv(NP_file,stringsAsFactors = F)
Haywood <- read.csv(Haywood_file,stringsAsFactors = F)
Swain <- read.csv(Swain_file,stringsAsFactors = F)
BOX <- read.csv(BOX_file,stringsAsFactors = F)
county <- rbind(Haywood,Swain)
county_list <- c(37087,37173) #county FIPS

#to loop over varoius surrogate files start from here
for(sf in 1:length(SF_code)){
  file <- sprintf("%s/USA_%s.txt",path_SF,SF_code[sf])
  tmp <- readLines(file)  
  trial_lines <- str_detect(tmp, "#")
  tmp <- tmp[!trial_lines]
  writeLines(tmp, sprintf("%s/tmp.txt",path_SF))
  #open the temp file and find the correct header
  file <- sprintf("%s/tmp.txt",path_SF)
  data_t <- fread(file, fill = TRUE)
  data <- data_t[,-6]
  ndata <- length(colnames(data))
  if(ndata == 7){
    colnames(data) <- c("surrogate_code","FIPS","COL","ROW","spatial fraction","NUMERATOR","DENOMINATOR") 
  }else if(ndata == 8){
    colnames(data) <- c("surrogate_code","FIPS","COL","ROW","spatial fraction","NUMERATOR","DENOMINATOR","QASUM")
  }else{ #if the format is not right report a error to log file
    MES_tmp <- sprintf("%s header not match",SF_code[sf])
    write(MES_tmp,checkfile,append = TRUE)
  }
  temp <- data[which(data$FIPS == 37173 | data$FIPS == 37087),]
  temp$COLROW <- str_c(temp$COL,",",temp$ROW)
  

  #separate individual county data
  for(c in 1:length(county_list)){
    outfile <- sprintf("%s/%s_%s.csv",path,county_list[c],SF_DESC[sf])
    temp_1 <- temp[which(temp$FIPS == county_list[c]),]
    temp_2 <- temp[which(temp$FIPS == county_list[c]),]
    temp_1$NP_mark <- ""
    temp_1$LAT <- 0
    temp_1$LON <- 0
    for(i in 1:length(temp_1$COL)){
      if(temp_1$COLROW[i] %in% BOX$COLROW){
        temp_1$LAT[i] <- BOX[which(BOX$COLROW == temp_1$COLROW[i]),5]
        temp_1$LON[i] <- BOX[which(BOX$COLROW == temp_1$COLROW[i]),4]
      }else{
        temp_1$LAT[i] <- ""
        temp_1$LON[i] <- ""
      }
      
      if(temp_1$COLROW[i] %in% NP$COLROW){
        temp_1$NP_mark[i] <- "NP"
      }else{
        temp_1$NP_mark[i] <- "NON_NP"
      }
    }
    temp_1$fraction <- temp_1$NUMERATOR/temp_1$DENOMINATOR
    NP_1 <- temp_1[which(temp_1$NP_mark == "NP"),]
    outfile <- sprintf("%s/tables/target_in_%s_%s.csv",path,county_list[c],SF_DESC[sf])
    write.csv(temp_1,outfile,row.names = F)
#     #make map
    countyinfo <- counties
    county_t <- countyinfo[which(countyinfo$county_fips == 37087 | countyinfo$county_fips == 37173),]

    ggplot() +
      geom_polygon(data = county_t, aes(x = long, y = lat, group = group)) +
      geom_point(data =temp_1, aes(x = LON, y = LAT, color=fraction)) +
      scale_color_gradient(low="white", high="red") +
#      ggtitle(sprintf("%s %s %s",county_list[c],SF_DESC[sf],GRID))+
      xlim(-84,-82.5)+
      ylim(35.2,35.8)+
      theme(plot.title = element_text(size=9))
    outfile <- sprintf("%s/QA_figures/%s_%s_%s.png",path,county_list[c],SF_DESC[sf],GRID)
    ggsave(outfile,units = "in", width = 3.5, height =2, dpi =300)

    ggplot() +
      geom_polygon(data = county_t, aes(x = long, y = lat, group = group)) +
      geom_point(data =NP_1, aes(x = LON, y = LAT, color=fraction)) +
      scale_color_gradient(low="white", high="blue") +
#      geom_point(data = mask_point,aes(x = LON, y = LAT),color = "grey",size = 0.1,alpha = 0.6)+
#      ggtitle(sprintf("target in %s %s %s",county_list[c],SF_DESC[sf],GRID))+
      xlim(-84,-82.5)+
      ylim(35.2,35.8)+
      theme(plot.title = element_text(size=9))
    outfile <- sprintf("%s/QA_figures/target_in_%s_%s_%s.png",path,county_list[c],SF_DESC[sf],GRID)
    ggsave(outfile,units = "in", width = 3.5, height =2, dpi =300)
    temp_1$SF_DESC <- SF_DESC[sf]
    if(length(colnames(temp_1))==14){
      temp_1 <- temp_1[,-8]
    }
    if(sf == 1 && c==1){
      overall_data <- temp_1
    }else{
      overall_data <- rbind(overall_data,temp_1)
    }
  } #county loop
} #sf loop
outfile <- outfile <- sprintf("%s/surrogate_all_in_this_v1.csv",path)
write.csv(overall_data,outfile,row.names = F)


