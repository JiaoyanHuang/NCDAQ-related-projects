
#' summarize county level MOVESoutput
#'
#' This function summarize county level MOVESouput
#' @param path: Design sheet path
#' @param DSfile: Design sheet file
#' @param hostname: SQL sever location
#' @param outpath: path of county summary for all pollutant (csv file)
#' @param data the data summaryzed by summary_MOVES_data function
#' @param year the year you would like to plot
#' @param pollutantID pollutant ID NOx 31 VOC 81 PM2.5 110
#' @return a county level summary for NOx VOC PM2.5 emissions
#' @export
#' @examples
#' county_level_map(data, path, DSfile, year, unit, outpath)
#'

county_level_map <- function(data, path, DSfile, year, pollutantID, outpath, unit){
  library(urbnmapr)
  library(tidyverse)
  library(oce)
  unit <- unit
  year <- year
  pollutantID <- pollutantID
  path <- path
  DSfile <- sprintf("%s/%s",path,DSfile)
  DS <- read_excel(DSfile,"RunSpec")
  COID <- na.omit(unique(DS$countyID))
  countyno <- length(COID)
  data_tmp <- data[which(data$yearID == year),]
  data_tmp1 <- data.frame(matrix(0,countyno,length(colnames(data))))
  colnames(data_tmp1) <- colnames(data_tmp)
  colnames(data_tmp1)[1] <- "county_fips"
  colnames(data_tmp1)[5] <- "emissions"
  data_tmp1$county_fips <- as.character(COID)
  data_tmp1$yearID <- year
  data_tmp1$pollutantID <- pollutantID
  data_tmp1$sourcetypeID <- "onroad"

  countyinfo <- counties

  for (c in 1:countyno){
    data_tmp1$emissions[c] <- sum(data_tmp[which(data_tmp$countyID == COID[c]),5])
  }

  p <- data_tmp1 %>%
    left_join(countyinfo, by = "county_fips") %>%
    filter(state_name =="North Carolina") %>%
    ggplot(mapping = aes(long, lat, group = group, fill = emissions)) +
    geom_polygon(color = "white", size = .25) +
    scale_fill_gradient2(low = "deepskyblue", mid = "white", high = "firebrick1", midpoint = 0) +
    coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
    theme(legend.title = element_text(),
          legend.key.width = unit(.5, "in")) +
    ggtitle(paste(data_tmp$pollutant[1], "emissions", unit))
  outfile <- sprintf("%s/%s_poll%s_countymaps.png",outpath,year,pollutantID)
  png(outfile)
  print(p)
  dev.off()
}
