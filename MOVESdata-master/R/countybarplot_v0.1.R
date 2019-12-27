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
#' county_level_stackbar(data, path, DSfile, year, unit, outpath)
#'

county_level_stackbar <- function(data, path, DSfile, year, unit, outpath, poll){
  library(readxl)
  library(ggplot2)
  year <- year #2025
  unit <- unit #"tons/y"
  outpath <- outpath
  data_tmp <- data[which(data$yearID == year),]
  colnames(data_tmp)[5] <- "emission"
  data_tmp$sourcetypeID <- as.character(data_tmp$sourcetypeID)
  data_tmp$countyID <- as.character(data_tmp$countyID)
  path <- path
  DSfile <- sprintf("%s/%s",path,DSfile)
  DS <- read_excel(DSfile,"RunSpec")
  data_tmp1 <- data_tmp
  data_tmp1$percent <- " "
  plotlist1 = list()
  plotlist2 = list()
    for (c in 1:length(DS$countyID)){
      COID <- DS$countyID[c]
      rowind <- which(data_tmp1$countyID == COID)
      countysum <- sum(data_tmp1[which(data_tmp1$countyID == COID),5])
      for (i in 1:length(rowind)){
        data_tmp1$percent[rowind[i]] <- data_tmp1$emission[rowind[i]]/countysum*100
      }
    }
    data_tmp1$percent <- as.numeric(data_tmp1$percent)
    p1 <- ggplot() +
      geom_bar(aes(y = emission, x = countyID, fill = sourcetypeID), data = data_tmp1,
                        stat="identity") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      ggtitle(sprintf("%s emissions %s",poll,unit))
    plotlist1[[1]] = p1
    p2 <- ggplot() +
      geom_bar(aes(y = percent, x = countyID, fill = sourcetypeID), data = data_tmp1,
               stat="identity")+
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      ggtitle(paste(poll, "emissions in %"))
    plotlist2[[1]] = p2

  # for (s in 1:length(pollutantID)){
    outfile1 <- sprintf("%s/%s_%s_emission.png",outpath,year,poll)
    outfile2 <- sprintf("%s/%s_%s_percent.png",outpath,year,poll)
    png(outfile1)
    print(plotlist1[[1]])
    dev.off()
    png(outfile2)
    print(plotlist2[[1]])
    dev.off()
  # }
}
