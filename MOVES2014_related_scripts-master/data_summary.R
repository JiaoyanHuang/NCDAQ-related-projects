library(RMySQL)
library(readxl)
library(readr)
library(stringi)
library(tidyr)

path <- "V:/Onroad/Projects_Conformity/2018/Triangle_2045_MTP"
DSfile <- sprintf("%s/Design_Sheet_Triangle_2045_MTP.xlsx",path)
DS <- read_excel(DSfile,"RunSpec")

pollutantID <- c(31,87,110)
pollutant   <- c("NOx","VOC","PM2.5")



for (c in 1:length(DS$countyID)){
  database <- DS$`CDM Output Name`[c]
  mydb = dbConnect(MySQL(), user='moves', password='moves', 
                   dbname=database, host='DENR-DAQ-196189')
  on.exit(dbDisconnect(mydb))
  rs1 = dbSendQuery(mydb, "SELECT countyID, yearID, pollutantID, sourcetypeID, sum(emissionQuant) FROM movesoutput
                  group by countyID, sourceTypeID, pollutantID")
  data_tmp1 = fetch(rs1, n=-1)
  tmpoutfile <- sprintf("%s/results_backup/%s.csv",path,database)
  write.csv(data_tmp1,tmpoutfile)
  if (c == 1){
    data <- data_tmp1[which(data_tmp1$pollutantID == 31 |
                            data_tmp1$pollutantID == 87 |  
                            data_tmp1$pollutantID == 110),]
  }else if (c != 37){
    data_tmp <- data_tmp1[which(data_tmp1$pollutantID == 31 |
                              data_tmp1$pollutantID == 87 |  
                              data_tmp1$pollutantID == 110),]
    data <- rbind(data,data_tmp)
  }
  all_cons <- dbListConnections(MySQL())
  for (con in all_cons)
    dbDisconnect(con)
}
