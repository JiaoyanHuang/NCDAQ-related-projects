#' summarize county level MOVESoutput
#'
#' This function summarize county level MOVESouput
#' @param path: Design sheet path
#' @param DSfile: Design sheet file
#' @param hostname: SQL sever location
#' @param outpath: path of county summary for all pollutant (csv file)
#' @return a county level summary for NOx VOC PM2.5 emissions
#' @export
#' @examples
#' moves_data_summary(path,DSfile,hostname,outpath)
#'

move_data_summary <- function(path,DSfile,hostname,outpath){

  library(RMySQL)
  library(readxl)
  library(readr)
  library(DataCombine)


  path <- path
  DSfile <- sprintf("%s/%s",path,DSfile)
  DS <- read_excel(DSfile,"RunSpec")

  pollutantID <- c(31,87,110)
  ERRORfile <- sprintf("%s/data_summary_error.txt",path)
  if (file.exists(ERRORfile)) file.remove(ERRORfile)
  write(paste("total lines",length(DS$countyID)),ERRORfile,append = TRUE)

  all_cons <- dbListConnections(MySQL())
  for (con in all_cons)
    dbDisconnect(con)

  database <- 'movesdb20161117'
  mydb = dbConnect(MySQL(), user='moves', password='moves',
                   dbname=database, host= hostname)

  rs_tmp = dbSendQuery(mydb, "SELECT pollutantID, pollutantName FROM pollutant")
  species = fetch(rs_tmp, n=-1)
  species$pollutantID <- as.character(species$pollutantID)

  all_cons <- dbListConnections(MySQL())
  #on.exit(dbDisconnect(mydb))

  for (c in 1:length(DS$countyID)){
    if(DS$countyID[c] %in% NA){
      write(paste("error data in line",c),ERRORfile,append = TRUE)
    }else{
      write(paste("finished data in line",c),ERRORfile,append = TRUE)
      database <- DS$`CDM Output Name`[c]
      mydb = dbConnect(MySQL(), user='moves', password='moves',
                       dbname=database, host= hostname)
      #on.exit(dbDisconnect(mydb))
      rs1 = dbSendQuery(mydb, "SELECT countyID, yearID, pollutantID, sourcetypeID, sum(emissionQuant) FROM movesoutput
                    group by countyID, sourceTypeID, pollutantID")
      data_tmp1 = fetch(rs1, n=-1)
      all_cons <- dbListConnections(MySQL())
      for (con in all_cons)
        dbDisconnect(con)
      tmpoutfile <- sprintf("%s/%s.csv",outpath,database)
      write.csv(data_tmp1,tmpoutfile)

      if (c == 1){
        data <- data_tmp1
                            # [which(data_tmp1$pollutantID == 31 |
                            #       data_tmp1$pollutantID == 87 |
                            #       data_tmp1$pollutantID == 110),]
      }else{
        data_tmp <- data_tmp1
                              # [which(data_tmp1$pollutantID == 31 |
                              #         data_tmp1$pollutantID == 87 |
                              #         data_tmp1$pollutantID == 110),]
        data <- rbind(data,data_tmp)
      }
    }
  }
  data$pollutant <- as.character(data$pollutantID)
  data <- FindReplace(data = data, Var = "pollutant", replaceData = species,
                      from = "pollutantID", to = "pollutantName", exact = TRUE)

  write("finished all data",ERRORfile,append = TRUE)
  return(data)
  write("return file",ERRORfile,append = TRUE)
}
