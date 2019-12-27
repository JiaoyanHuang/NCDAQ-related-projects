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
#' moves_VI_summary(path,DSfile,hostname,outpath)
#'

move_VI_summary <- function(path,DSfile,hostname,outpath){

  library(RMySQL)
  library(readxl)
  library(readr)
  library(DataCombine)

  # hostname <- 'DENR-DAQ-196189'
  # path <- "V:/Onroad/Projects_Conformity/2018/Triangle_2045_MTP"
  # outpath <- sprintf("%s/results_backup/",path)
  # DSfile <- "Design_Sheet_Triangle_2045_MTP.xlsx"
  path <- path
  DSfile <- sprintf("%s/%s",path,DSfile)
  DS <- read_excel(DSfile,"RunSpec")

  pollutantID <- c(1,6)
  pollutant   <- c("VMT","VPOP")
  ERRORfile <- sprintf("%s/inputdata_summary_error.txt",path)
  if (file.exists(ERRORfile)) file.remove(ERRORfile)
  write(paste("total lines",length(DS$countyID)),ERRORfile,append = TRUE)
  all_cons <- dbListConnections(MySQL())
  for (con in all_cons)
    dbDisconnect(con)

  for (c in 1:length(DS$countyID)){
    if(DS$countyID[c] %in% NA){
      write(paste("error data in line",c),ERRORfile,append = TRUE)
    }else{
      write(paste("finished data in line",c),ERRORfile,append = TRUE)
      database <- DS$`CDM Output Name`[c]
      mydb = dbConnect(MySQL(), user='moves', password='moves',
                       dbname=database, host= hostname)
      #on.exit(dbDisconnect(mydb))
      rs1 = dbSendQuery(mydb, "SELECT countyID, yearID, activityTypeID, sourcetypeID, sum(activity) FROM movesactivityoutput
                      group by countyID, sourceTypeID, activityTypeID")
      data_tmp1 = fetch(rs1, n=-1)
      all_cons <- dbListConnections(MySQL())
      # for (con in all_cons)
      #  dbDisconnect(con)
      tmpoutfile <- sprintf("%s/%s.csv",outpath,database)
      write.csv(data_tmp1,tmpoutfile)
      if (c == 1){
        rs_tmp = dbSendQuery(mydb, "SELECT activityTypeID, activityTypeDesc FROM activitytype")
        activity = fetch(rs_tmp, n=-1)
        for (con in all_cons)
          dbDisconnect(con)

        data <- data_tmp1
                          # [which(data_tmp1$activityTypeID == 1 |
                          #         data_tmp1$activityTypeID == 6),]
      }else{
        for (con in all_cons)
          dbDisconnect(con)
        data_tmp <- data_tmp1
                            # [which(data_tmp1$activityTypeID == 1 |
                            #           data_tmp1$activityTypeID == 6),]
        data <- rbind(data,data_tmp)
      }
    }
  }
  data$activityType <- as.character(data$activityTypeID)
  data <- FindReplace(data = data, Var = "activityType", replaceData = activity,
                      from = "activityTypeID", to = "activityTypeDesc", exact = TRUE)
  write("finished all data",ERRORfile,append = TRUE)
  return(data)
  write("return file",ERRORfile,append = TRUE)
}
