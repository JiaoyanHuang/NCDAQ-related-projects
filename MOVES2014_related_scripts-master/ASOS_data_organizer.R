library(data.table)

path <- "C:/Users/jhuang/Desktop/TEST/ASOS_raw/ASOS/1A5"
infile <- sprintf("%s/NC_ASOS_1A5_20170101_to_20180101.txt",path)

data <- read.csv(infile,stringsAsFactors=FALSE)
data$MM <- substring(data$valid,6,7)
data$HH <- substring(data$valid,12,13)
data$MMHH <- str_c(data$MM,data$HH)
data$tmpf <- as.numeric(data$tmpf)
data$relh <- as.numeric(data$relh)
data$datehour <- cut(as.POSIXct(data$valid,
                             format="%Y-%m-%d %H:%M"), breaks="hour") 
means<- aggregate(tmpf ~ MMHH, data, mean)
means$RH<- aggregate(relh ~ MMHH, data, mean)[,2]


