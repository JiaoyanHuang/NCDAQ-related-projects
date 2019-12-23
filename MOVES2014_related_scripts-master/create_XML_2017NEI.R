library(readxl)
library(readr)
path_DS <- "V:/Onroad/Projects_Inventory/2017_NEI_NC_Onroad_EI"
file_DS <- sprintf("%s/2017_EPA_NEI_Design_Sheet.xlsx",path_DS)

DS <- read_excel(file_DS,sheet = "XMLImporter")
STY <- read_excel(file_DS,sheet = "sourceTypeYear")
VMT <- read_excel(file_DS,sheet ="VMT Converter")
IM <- data.frame(read.table("V:/Onroad/MOVES_Input_Data/IMCoverage/2016_MOVES2014/IM_list_48COUNTY.csv",skip = 1,sep = ","))
colnames(IM) <- c("IM","countyName","countyID")
COID <- IM$countyID
FuelSu<- read_excel(file_DS,sheet ="FuelSupply")
FuelUs<- read_excel(file_DS,sheet ="FuelUsageFractions")
FuelFo<- read_excel(file_DS,sheet ="FuelFormulation")
AVFT  <- read_excel(file_DS,sheet ="AFVT")
MET <- read_excel(file_DS,sheet = "zoneMonthHour")
RunSpec <- read_excel(file_DS,sheet = "RunSpec")
AVGSPD <- read_excel(file_DS,sheet = "avgSpdDistribution")
STAD <- read_excel(file_DS,sheet = "sourceTypeAgeDistribution")
MDVF <- read_excel(file_DS,sheet = "monthVMTFraction_dayVMTFraction")
IMF <- read_excel(file_DS,sheet = "IMCoverage")

Proj_Name_pre <- "2017EPANEI"

Proj_Name <- "2017EPANEI"

#read template file
path_XML <- "V:/Onroad/Projects_Inventory/2017_NEI_NC_Onroad_EI/XML_Importers"
XML_infile <- sprintf("%s/TEMP.xml",path_XML)
XML <-  readLines(XML_infile)

for (i in 1:length(DS$countyID)){
#  if(i !=37){
    k <- which(MDVF$countyID == DS$countyID[i])
    YEAR <- DS$Year[i]
    #k <- i - 37 ####important one could be removed if needed
    outfile <- DS$Filename[i]
    XML_outfile <- sprintf("%s/%s",path_XML,outfile)
    if (file.exists(XML_outfile)) file.remove(XML_outfile)
    #CDB
    XML_2 <- gsub("Metrolina2045MTPAllPay_c37025y2026_TDM_9653_90_cdb",RunSpec$`CDM Input name`[i],XML)
    #STAD
    STAD_tmp <- sprintf("%s%s",STAD$Directory[i],STAD$Filename[i])
    XML_2[66] <- sprintf("\t\t\t\t\t<filename>%s</filename>",STAD_tmp)
    #AVGSPD
    AVGSPD_tmp <- sprintf("%s%s",AVGSPD$Path[i],AVGSPD$AvgSpdConverter[i])
    XML_2[75] <- sprintf("\t\t\t\t\t<filename>%s</filename>",AVGSPD_tmp)    
    #fuel
    Fuelsuppy_tmp <- sprintf("%s\\%s",FuelSu$`Directory for Fuel Supply Files`[i],
                             FuelSu$`Fuel Supply Files`[i])
    XML_2[85] <- sprintf("\t\t\t\t\t<filename>%s</filename>",Fuelsuppy_tmp)         
    Fuelform_tmp <- sprintf("%s%s",FuelFo$`Directory for Fuel Formulation Files`[i],
                            FuelFo$`Fuel Formulation Files`[i])
    XML_2[88] <- sprintf("\t\t\t\t\t<filename>%s</filename>",Fuelform_tmp)    
    Fueluse_tmp <- sprintf("%s%s",FuelUs$`Directory for Fuel Usage Fraction Files`[i],
                           FuelUs$`Fuel Usage Fraction Files`[i])
    XML_2[91] <- sprintf("\t\t\t\t\t<filename>%s</filename>",Fueluse_tmp)
#    Dir_temp <- Fuel$`Directory for Fuel`[i]
    AVFT_tmp <- sprintf("%s%s",AVFT$`Directory for AFVT Files`[i],
                        AVFT$`AFVT Files`[i])
    XML_2[94] <- sprintf("\t\t\t\t\t<filename>%s</filename>",AVFT_tmp)
    #MET
#    MET_tmp <- sprintf("%s\\%s",MET$Directory[i],MET$Filename[i])
#    XML_2[103] <- sprintf("\t\t\t\t\t<filename>%s</filename>",MET_tmp)
    #STY
    STY_tmp <- sprintf("%s%s",STY$Directory[i],STY$Filename[i])
    XML_2[133] <- sprintf("\t\t\t\t\t<filename>%s</filename>",STY_tmp)
    #VMTfraction
    MVF_tmp <- sprintf("%s\\%s",MDVF$Directory[k],MDVF$MFilename[k]) # change k to i if needed
    XML_2[170] <- sprintf("\t\t\t\t\t<filename>%s</filename>",MVF_tmp)
    DVF_tmp <- sprintf("%s\\%s",MDVF$Directory[k],MDVF$DFilename[k]) # change k to i if needed
    XML_2[173] <- sprintf("\t\t\t\t\t<filename>%s</filename>",DVF_tmp) 
    #IM coverage
    if(IMF$`MY Coverage`[i] == "n/a" ){
      XML_2[198] <- "\t\t\t\t\t<filename></filename>"
    }else{
      IM_tmp <- sprintf("%s\\%s",IMF$Directory[i],IMF$Filename[i])
      XML_2[198] <- sprintf("\t\t\t\t\t<filename>%s</filename>",IM_tmp)
    }
    #VMT converter
    VMT_tmp <- sprintf("%s%s",VMT$`File Path`[i],VMT$`File Name`[i])
    XML_2[c(113,123,166,176)] <- sprintf("\t\t\t\t\t<filename>%s</filename>",VMT_tmp)
    
    XML_3 <- gsub("2026",YEAR,XML_2)
    XML_3 <- gsub("2005",YEAR,XML_3)
    XML_4 <- gsub("37025",DS$countyID[i],XML_3)
    XML_5 <- gsub("Cabarrus",DS$countyName[i],XML_4)
    XML_6 <- gsub("CABARRUS",toupper(DS$countyName[i]),XML_5)
    XML_7 <- gsub("Metrolina2045MTPAllPay",Proj_Name_pre,XML_6)
    XML_8 <- gsub("Metrolina",Proj_Name,XML_7)
    writeLines(XML_8,XML_outfile)
#  }
}

