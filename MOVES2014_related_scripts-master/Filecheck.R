library(readxl)
library(readr)
library(stringi)
library(tidyr)

path_DS <- "V:/Onroad/Projects_Inventory/2017_NEI_NC_Onroad_EI"
file_DS <- sprintf("%s/2017_EPA_NEI_Design_Sheet.xlsx",path_DS)

DS <- read_excel(file_DS,sheet = "XMLImporter")
#STY <- read_excel(file_DS,sheet = "sourceTypeYear")
#VMT <- read_excel(file_DS,sheet ="VMT Converter")
#FuelSu<- read_excel(file_DS,sheet ="FuelSupply")
#FuelUs<- read_excel(file_DS,sheet ="FuelUsageFractions")
#FuelFo<- read_excel(file_DS,sheet ="FuelFormulation")
#AVFT  <- read_excel(file_DS,sheet ="AFVT")
#MET <- read_excel(file_DS,sheet = "zoneMonthHour")
#RunSpec <- read_excel(file_DS,sheet = "RunSpec")
#AVGSPD <- read_excel(file_DS,sheet = "avgSpdDistribution")
#STAD <- read_excel(file_DS,sheet = "sourceTypeAgeDistribution")
#MDVF <- read_excel(file_DS,sheet = "monthVMTFraction_dayVMTFraction")
#IMF <- read_excel(file_DS,sheet = "IMCoverage")
DS[is.na(DS)] <- "-"
checkfile <- sprintf("%s/XML_Importers/checkfile.txt",path_DS)
linenumber <- c(66,75,85,88,91,94,103,113,123,133,166,170,173,176)
if (file.exists(checkfile)) file.remove(checkfile)
for (c in 1:length(DS$countyID)){

  XMLfile <- sprintf("%s/%s",gsub("\\\\","/",DS$Directory[c]),DS$Filename[c])
  XML <-  readLines(XMLfile)
  for (l in 1:length(linenumber)){
    line <- sprintf("dir %s",strsplit(XML[linenumber[l]],split = "[<|,>]")[[1]][3])
    write(line,checkfile,append = TRUE)
  }
  if(DS$`I&M Frequency`[c] == "annual"){
    line <- sprintf("dir %s",strsplit(XML[198],split = "[<|,>]")[[1]][3])
    write(line,checkfile,append = TRUE)
  }
}
filename_bat <- gsub("txt","bat",checkfile)
file.rename(checkfile,filename_bat)
