#' summarize county level MOVESoutput
#'
#' This function summarize county level MOVESouput
#' @param path: Design sheet path
#' @param DSfile: Design sheet file
#' @param hostname: SQL sever location
#' @param outpath: path of county summary for all pollutant (csv file)
#' @param data the data summaryzed by summary_MOVES_data function
#' @param year the year you would like to plot
#' @param unit the emission unit
#' @return a county level summary for NOx VOC PM2.5 emissions
#' @export
#' @examples
#' pieplot(data, path, DSfile, year, pollutantID, outpath)
#'

pieplot <- function(data, path, DSfile, year, poll, outpath){

  library(ggplot2)

  year <- year
  poll <- poll
  # pollutant <- c(31,87,110)
  # pollutantName   <- c("NOx","VOC","PM2.5")
  path <- path
  DSfile <- sprintf("%s/%s",path,DSfile)
  DS <- read_excel(DSfile,"RunSpec")
  COID <- na.omit(unique(DS$countyID))
  CONAME <- na.omit(unique(DS$countyName))
  countyno <- length(COID)
  data_tmp <- data[which(data$yearID == year),]
  data_tmp1 <- data.frame(matrix(0,countyno,length(colnames(data))))
  colnames(data_tmp1) <- colnames(data_tmp)
  colnames(data_tmp1)[1] <- "county_fips"
  colnames(data_tmp1)[5] <- "emissions"
  data_tmp1$county_fips <- as.character(COID)
  data_tmp1$countyname <- CONAME
  data_tmp1$yearID <- year
#  data_tmp1$pollutantID <- pollutantID
  data_tmp1$sourcetypeID <- "onroad"


  for (c in 1:countyno){
    data_tmp1$emissions[c] <- sum(data_tmp[which(data_tmp$countyID == COID[c]),5])
  }
  data_tmp1$share <- data_tmp1$emissions/sum(data_tmp1$emissions)
#  polln <- which(pollutant == pollutantID)
  pietitle <- sprintf("%s %s contribution",year,poll)
  p <- ggplot(data_tmp1, aes(x=" ", y= share, fill= countyname)) + geom_bar(stat="identity", width=1) +
    coord_polar("y", start=0) +
    geom_text(aes(label = paste0(round(share*100), "%")), position = position_stack(vjust = 0.5)) +
    labs(x = NULL, y = NULL, fill = NULL, title = pietitle) +
    theme_classic() + theme(axis.line = element_blank(),
                              axis.text = element_blank(),
                              axis.ticks = element_blank(),
                              plot.title = element_text(hjust = 0.5, color = "#666666"))
  outfile <- sprintf("%s/%s_%s_pie.png",outpath,year,poll)
  png(outfile)
  print(p)
  dev.off()
}
