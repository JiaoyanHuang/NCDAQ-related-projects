% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary_VI_v0.1.R
\name{move_VI_summary}
\alias{move_VI_summary}
\title{summarize county level MOVESoutput}
\usage{
move_VI_summary(path, DSfile, hostname, outpath)
}
\arguments{
\item{path:}{Design sheet path}

\item{DSfile:}{Design sheet file}

\item{hostname:}{SQL sever location}

\item{outpath:}{path of county summary for all pollutant (csv file)}
}
\value{
a county level summary for NOx VOC PM2.5 emissions
}
\description{
This function summarize county level MOVESouput
}
\examples{
moves_VI_summary(path,DSfile,hostname,outpath)

}
