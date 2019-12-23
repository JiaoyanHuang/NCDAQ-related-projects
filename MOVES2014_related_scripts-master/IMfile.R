library(readxl)
library(readr)
path_DS <- "V:/Onroad/Projects_Inventory/2017_NEI_NC_Onroad_EI"
file_DS <- sprintf("%s/2017_EPA_NEI_Design_Sheet.xlsx",path_DS)
#read 100 counties list
RunSpec <- read_excel(file_DS,sheet = "RunSpec")
IM <- read_excel(file_DS,sheet = "IMCoverage")
Year <- 2017

path <- sprintf("V:/Onroad/MOVES_Input_Data/IMCoverage/%s_MOVES2014",Year)

infile <- sprintf("%s/TEMP.tab",path)



for (c in 1:length(IM$countyID)){
  if(IM$`I&M Frequency`[c] == "annual"){
    TEMP <- read.csv(infile,sep = '\t')
    TEMP$countyID <- IM$countyID[c]
    TEMP$yearID <- Year
    TEMP$endModelYearID <- (Year - 3)
    
    outfile <- sprintf("%s/c%sy%s_9653_MOVES2014.tab",path,IM$countyID[c],Year)
    write.table(TEMP,outfile,
                row.names = FALSE,
                sep = '\t',
                quote=FALSE)
  }
}
