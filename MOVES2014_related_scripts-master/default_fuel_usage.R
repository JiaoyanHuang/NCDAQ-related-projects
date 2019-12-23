library(RMySQL)
library(readxl)
library(readr)
path_DS <- "V:/Onroad/Projects_Inventory/2017_NEI_NC_Onroad_EI"
file_DS <- sprintf("%s/2017_EPA_NEI_Design_Sheet.xlsx",path_DS)
FuelUs<- read_excel(file_DS,sheet ="FuelUsageFractions")

all_cons <- dbListConnections(MySQL())
for(con in all_cons)
  +  dbDisconnect(con)

mydb = dbConnect(MySQL(), user='moves', password='moves', 
                 dbname="movesdb20161117", host='DENR-DAQ-196189')
on.exit(dbDisconnect(mydb))
rs1 = dbSendQuery(mydb, "SELECT * FROM movesdb20161117.fuelusagefraction
                         where fuelYearID = 2017 and countyID LIKE '37%';")
data_all = fetch(rs1, n=-1)


for (c in 1:length(FuelUs$countyID)){
  data_tmp <- data_all[which(data_all$countyID == FuelUs$countyID[c]),]
  outpath <- gsub("\\\\","/",FuelUs$`Directory for Fuel Usage Fraction Files`[c])
  file <- sprintf("%s/%s",outpath,FuelUs$`Fuel Usage Fraction Files`[c])
  write.table(data_tmp,file,
              row.names = FALSE,
              sep = '\t',
              quote=FALSE)
}
