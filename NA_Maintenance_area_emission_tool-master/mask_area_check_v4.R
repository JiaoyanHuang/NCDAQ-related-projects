# load all package you need
  library(ncdf4) #open grid file
  library(urbnmapr) #county map information
  library(tidyverse) #county map information
  library(oce) #county map information
  library(data.table) #fread

  #main path
  path <- "C:/Users/jhuang/Desktop/Projects/2014fd NEI annual gridded files"
  #GRIDCRO2D file, can be generated using m3tool https://www.cmascenter.org/ioapi/documentation/all_versions/html/LATLON.html
  GRID <- "CONUS4k_GRIDCRO2D" #"2014fd_nata_GRIDCRO2D" #GRIDCRO2D file
  file1 <- sprintf("%s/%s",path, GRID)
  REAL <- "long_lat_Haywood.csv" #NP long_lat file can be coverted using library(proj4) see shapefile conversion code
  file2 <- sprintf("%s/%s",path,REAL)
  #we are using shape file with boundary coordinate to generate an area
  mask_boundary <- read.csv(file2,stringsAsFactors = F)
  #since the 4km grid is large, we will first set a box for the 4km grid, which can reduce the calculation time
  latmin <- 35.2
  latmax <- 35.8
  lonmin <- -84
  lonmax <- 82.75
  
  #read the target area shapefile and assign column names
  mask_point <- mask_boundary
  colnames(mask_point) <- c("LON","LAT")
  mask_point$COL <- 0
  mask_point$ROW <- 0
  mask_point$CLAT <- 0
  mask_point$CLON <- 0
  mask_point$dis <-0

  #index 1 means target areas
  index1 <- 1
  index2 <- 0
  
  #open GRIDCRO2D fiel and assign coordinate to each cell
  ncGRID <- nc_open(file1)

  LAT <- ncvar_get(ncGRID,"LAT")
  LON <- ncvar_get(ncGRID,"LON")
  COL <- ncGRID$dim$COL$vals
  ROW <- ncGRID$dim$ROW$vals
  data_tmp <- expand.grid(COL,ROW)
  colnames(data_tmp) <- c("COL","ROW")
  data_tmp$LON <- as.vector(LON)
  data_tmp$LAT <- as.vector(LAT)
  data_tmp$value <- 0
  data_tmp$COLROW <- str_c(data_tmp$COL,",",data_tmp$ROW)
  
  #zoom in to the target box
  data_tmp_test <- data_tmp[which(data_tmp$LON > lonmin & data_tmp$LON < lonmax & data_tmp$LAT > latmin & data_tmp$LAT < latmax),] 
  data_tmp_test$dis <- 0
  outfile <- sprintf("%s/BOX_mask.csv",path)
  write.csv(data_tmp_test,outfile)

  #loop over different surrogate surface  

  
  # for (i in 1:length(temp$COL)){
  #   temp$LAT[i] <- data_tmp[which(data_tmp_test$COLROW == temp$COLROW[i]),4]
  #   temp$LON[i] <- data_tmp[which(data_tmp_test$COLROW == temp$COLROW[i]),3]
  # }
  # temp_1 <- temp
  #for each shape point, calculaet the most close cell using center coordinate
  for (i in 1:length(mask_point$LON)){
    data_tmp_test$dis <- ((data_tmp_test$LON - mask_point$LON[i])^2 + (data_tmp_test$LAT - mask_point$LAT[i])^2)^0.5
    mask_point$COL[i] <- unlist(data_tmp_test[which.min(data_tmp_test$dis),1])[[1]]
    mask_point$ROW[i] <- unlist(data_tmp_test[which.min(data_tmp_test$dis),2])[[1]]
    mask_point$CLAT[i] <- unlist(data_tmp_test[which.min(data_tmp_test$dis),4])[[1]]
    mask_point$CLON[i] <- unlist(data_tmp_test[which.min(data_tmp_test$dis),3])[[1]]    
    mask_point$dis[i] <- unlist(data_tmp_test[which.min(data_tmp_test$dis),7])[[1]]
  }
  
  library(stringr)
  #this will be a indicate to match the data
  mask_point$COLROW <- str_c( mask_point$COL,",",mask_point$ROW)
  #select only target area boundary point
  point_list <- data.frame(unique(mask_point$COLROW))
  colnames(point_list) <- "COLROW"
  point_list$COL <- 0
  point_list$ROW <- 0
  point_list$LON <- 0
  point_list$LAT <- 0
  for (i in 1:length(point_list$COLROW)){
    point_list$COL[i] <- strsplit(as.character(point_list$COLROW[[i]]),",")[[1]][1]
    point_list$ROW[i] <- strsplit(as.character(point_list$COLROW[[i]]),",")[[1]][2]
    point_list$LON[i] <- LON[as.numeric(point_list$COL[i]),as.numeric(point_list$ROW[i])]
    point_list$LAT[i] <- LAT[as.numeric(point_list$COL[i]),as.numeric(point_list$ROW[i])]
  }
  #assign indicator (1 or 0) to the target counties and target area
  for(i in 1:length(data_tmp_test$COL)){
    if(data_tmp_test$COLROW[i] %in% mask_point$COLROW){
      data_tmp_test$value[i] <- index1
    }else{
      data_tmp_test$value[i] <- index2
    }
  }
  
  #fill the area inside the boundary
  for(i in 1:length(data_tmp_test$COL)){
    COL_tmp <- data_tmp_test$COL[i]
    ROW_tmp <- data_tmp_test$ROW[i]
    rowmax <- max(data_tmp_test[which(data_tmp_test$value == 1 & data_tmp_test$COL == COL_tmp),2])
    rowmin <- min(data_tmp_test[which(data_tmp_test$value == 1 & data_tmp_test$COL == COL_tmp),2])
    colmax <- max(data_tmp_test[which(data_tmp_test$value == 1 & data_tmp_test$ROW == ROW_tmp),1])
    colmin <- min(data_tmp_test[which(data_tmp_test$value == 1 & data_tmp_test$ROW == ROW_tmp),1])
    if(data_tmp_test$ROW[i] < rowmax & data_tmp_test$ROW[i] > rowmin &
       data_tmp_test$COL[i] < colmax &data_tmp_test$COL[i] > colmin){
       data_tmp_test$value[i] <- 1
    }
  }
  
  point_list <- data_tmp_test[which(data_tmp_test$value == 1),]
  outfile <- sprintf("%s/Haywood_mask.csv",path)
  write.csv(point_list,outfile  )
  # # FC for full county and NP for target area
  # # FC <- temp_1
  # NP_tmp <- FC
  # NP <- NP_tmp[NP_tmp$COLROW %in% point_list$COLROW,]
  # 
  # outfile <- sprintf("%s/NP_%s.csv",path,SF_DESC[sf])
  # write.csv(NP,outfile)
  
  # #make map
  # countyinfo <- counties
  # county_t <- countyinfo[which(countyinfo$county_fips %in% county_list),]
  # 
  # ggplot() +
  #   geom_polygon(data = county_t, aes(x = long, y = lat, group = group)) +
  #   geom_point(data =FC, aes(x = LON, y = LAT, color=NUMERATOR)) +
  #   scale_color_gradient(low="white", high="red") +
  #   ggtitle(sprintf("%s %s",SF_DESC[sf],GRID))+
  #   xlim(lonmin,lonmax)+
  #   ylim(latmin,latmax)+
  #   theme(plot.title = element_text(size=9))
  # outfile <- sprintf("%s/%s_%s.png",path,SF_DESC[sf],GRID)
  # ggsave(outfile,units = "in", width = 3.5, height =2, dpi =300)
  # 
  # ggplot() +
  #   geom_polygon(data = county_t, aes(x = long, y = lat, group = group)) +
  #   geom_point(data =NP, aes(x = LON, y = LAT, color=NUMERATOR)) +
  #   scale_color_gradient(low="white", high="blue") +
  #   geom_point(data = mask_point,aes(x = LON, y = LAT),color = "grey",size = 0.1,alpha = 0.6)+
  #   ggtitle(sprintf("NP %s %s",SF_DESC[sf],GRID))+ 
  #   xlim(lonmin,lonmax)+
  #   ylim(latmin,latmax)+
  #   theme(plot.title = element_text(size=9))
  # outfile <- sprintf("%s/NP_%s_%s.png",path,SF_DESC[sf],GRID)
  # ggsave(outfile,units = "in", width = 3.5, height =2, dpi =300)
