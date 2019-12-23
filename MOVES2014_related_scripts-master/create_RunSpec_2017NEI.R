library(readxl)
library(readr)
path_DS <- "V:/Onroad/Projects_Inventory/2017_NEI_NC_Onroad_EI"
file_DS <- sprintf("%s/2017_EPA_NEI_Design_Sheet.xlsx",path_DS)
#read 100 counties list
RunSpec <- read_excel(file_DS,sheet = "RunSpec")
IM <- read_excel(file_DS,sheet = "IMCoverage")
COID <- IM$countyID
DS <- read_excel(file_DS,sheet = "XMLImporter")
#Fuel <- read_excel(file_DS,sheet = "FuelSupply_FuelFormulation")
#MET <- read_excel(file_DS,sheet = "zoneMonthHour")

#read template file
path_RS <- "V:/Onroad/Projects_Inventory/2017_NEI_NC_Onroad_EI/RunSpecs"
RS_infile <- sprintf("%s/TEMP.mrs",path_RS)
RS <-  readLines(RS_infile)

Proj_Name_pre <- "2017EPANEI"

Proj_Name <- "2017EPANEI"

for (i in 1: length(RunSpec$countyID)){
#  if(RunSpec$`VMT Source`[i]=="HPMS" | RunSpec$`VMT Source`[i]=="TDM"){

    
    #outfile name
    outfile <- RunSpec$`Run Spec Filename`[i]
    RS_outfile <- sprintf("%s/%s",path_RS,outfile)
    #remove the file if it exists
    if (file.exists(RS_outfile)) file.remove(RS_outfile)
    #replace CountyID, CountyName

    #replace CDB fiel and outfile
    RS_2 <- gsub("Metrolina2045MTPAllPay_c37025y2026_tdm_9653_90_cdb",RunSpec$`CDM Input name`[i],RS)
    RS_3 <- gsub("Metrolina2045MTPAllPay_c37025y2026_TDM_9653_90_out",RunSpec$`CDM Output Name`[i],RS_2)
    RS_4 <- gsub("37025",RunSpec$countyID[i],RS_3)
    RS_5 <- gsub("Cabarrus",RunSpec$countyName[i],RS_4)
    RS_6 <- gsub("Metrolina2045MTPAllPay",Proj_Name_pre,RS_5)
    #replace year
    RS_7 <- gsub("2026",DS$Year[i],RS_6)
    RS_8 <- gsub("Metrolina",Proj_Name,RS_7)

    writeLines(RS_8,RS_outfile)
#  }
}
