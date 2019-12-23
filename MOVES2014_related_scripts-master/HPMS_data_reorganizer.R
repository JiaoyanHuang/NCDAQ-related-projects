library(readxl)
library(readr)
path2016 <- gsub("\\\\","/","V:\\Onroad\\MOVES_Raw_Data\\HPMS_VMT\\2016")
file2016 <- sprintf("%s/2016_NC_HPMS_VMT_By_County-AADVMT.tab",path2016)
tableexample <- read.table(file2016,sep ="\t",header = T)

path2017 <- gsub("\\\\","/","V:\\Onroad\\MOVES_Raw_Data\\HPMS_VMT\\2017")
file2017raw <- sprintf("%s/2017 NC VMT By County_NCDOT (002).xlsx",path2017)
raw2017 <- read_excel(file2017raw,sheet = "Final",skip = 4)
rural_RT <- paste("Rural",colnames(read_excel(file2017raw,sheet = "Final",range = "B5:H5")))
urban_RT <- paste("Urban",colnames(read_excel(file2017raw,sheet = "Final",range = "J5:P5")))
col_name <- c("County",rural_RT," ",urban_RT,"Total")
colnames(raw2017) <- col_name
raw2017 <- raw2017[-101,c(-8,-9,-16,-17)]


pathCOlist <- gsub("\\\\","/","C:\\Users\\jhuang\\Desktop")
fileCOlist <- sprintf("%s/NC_CountyID.xlsx",pathCOlist)
COlist <- read_excel(fileCOlist,sheet = "Sheet1")
COlist$countyName <- toupper(COlist$countyName)

for (i in 1:length(raw2017$County)){
  CountyName <- raw2017$County[i]
  CountyID   <- COlist[which(COlist$countyName == CountyName),1]
  Countyindex <- which(tableexample$countyID == as.numeric(CountyID))
  tableexample$AADVMT[c(Countyindex)] <- as.numeric(raw2017[i,c(2:13)])
}

tableexample$yearID <- 2017
tableexample$datasetName <- "HPMS_2017"
tableexample$modelingDate <- "9/24/2017"


outfile <- sprintf("%s/2017_NC_HPMS_VMT_By_County-AADVMT.tab",path2017)
write.table(tableexample,outfile,sep = "\t",row.names = FALSE, quote = FALSE)
