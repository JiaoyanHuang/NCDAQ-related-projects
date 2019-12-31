path <- "C:/Users/jhuang/Desktop/Projects/2014fd NEI annual gridded files"
SF_folder <- "4km surrogate files/surrogates_CONUS4_2014_v1.14_14oct2016/ge_dat/gridding/CONUS4_2014_v1.14_14Oct2016" #surrogate folder
path_SF <- sprintf("%s/%s",path,SF_folder)
library(data.table)
library(ncdf4)
library(stringr)
library(urbnmapr)
library(tidyverse)
library(oce)
library(ggplot2)
SF_list_file <- sprintf("%s/Surrogate_file_list.csv",path)
SF_list <- read.csv(SF_list_file,stringsAsFactors = F)
SF_code <- paste(SF_list$CODE,"NOFILL",sep="_")
SF_DESC <- SF_list$DESCRIPTION
SF_list$NP_37087 <- 0
SF_list$FC_37087 <- 0
SF_list$NP_37173 <- 0
SF_list$FC_37173 <- 0

overall_file <- sprintf("%s/surrogate_all_in_this_v1.csv",path)
overall <- read.csv(overall_file,stringsAsFactors = F)
overall$sum_value <- 0
overall$QA <- 0
county_list <- c(37087,37173) #county FIPS

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
  for(c in 1:length(county_list)){
    dummy_n <- which(overall$surrogate_code == SF_list$CODE[sf] & overall$FIPS == county_list[c])
    overall$sum_value[dummy_n] <- sum(overall[which(overall$surrogate_code == SF_list$CODE[sf] & overall$FIPS == county_list[c]),6])
    temp_1 <- temp[which(temp$FIPS == county_list[c])]
    overall$QA[dummy_n] <- temp_1$NUMERATOR
  } #county loop
  SF_list$NP_37087[sf] <- sum(overall[which(overall$surrogate_code == SF_list$CODE[sf] & overall$FIPS == 37087 & overall$NP_mark == "NP"),6])
  SF_list$FC_37087[sf] <- sum(overall[which(overall$surrogate_code == SF_list$CODE[sf] & overall$FIPS == 37087),6])
  SF_list$NP_37173[sf] <- sum(overall[which(overall$surrogate_code == SF_list$CODE[sf] & overall$FIPS == 37173 & overall$NP_mark == "NP"),6])
  SF_list$FC_37173[sf] <- sum(overall[which(overall$surrogate_code == SF_list$CODE[sf] & overall$FIPS == 37173),6])
} #sf loop
overall$sum_diff <- overall$DENOMINATOR-overall$sum_value
overall$QA_diff  <- overall$NUMERATOR-overall$QA
unique(overall$sum_diff)
unique(overall$QA_diff)
outfile <- sprintf("%s/surrogate_QA.csv",path)
write.csv(overall,outfile,row.names = F)
SF_list$NPF_37087 <- SF_list$NP_37087/SF_list$FC_37087
SF_list$NPF_37173 <- SF_list$NP_37173/SF_list$FC_37173
outfile <- sprintf("%s/surrogate_overall_table.csv",path)
write.csv(SF_list,outfile,row.names = F)