#' Get Data to R
#' 
#' Converst SPSS Get Data command to R syntax.  Currently only works
#' for delimited data.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
getdata_to_r <- function(x) {
  
  fileLoc <- grep("file\\s?=", x, ignore.case = TRUE)
  if(any(grepl('\"', x)) == TRUE){
    path <- substr(x[fileLoc], (which(strsplit(x[fileLoc], '')[[1]]=='\"')[1]), 
                   (which(strsplit(x[fileLoc], '')[[1]]=='\"')[2]))
  } else {
    path <- substr(x[fileLoc], (which(strsplit(x[fileLoc], '')[[1]]=='\'')[1]), 
                   (which(strsplit(x[fileLoc], '')[[1]]=='\'')[2]))
  }
  
  firstcase <- grep("firstcase\\s?=", x, ignore.case = TRUE)
  num <- substr(x[firstcase], (which(strsplit(x[firstcase], '')[[1]]=='=')+1), nchar(x[firstcase]))
  
  if(num == 2){
    header <- "header = TRUE"
  } else {
    if(num == 1){
      header <- "header = FALSE"
    } else {
      header <- paste("header = FALSE, skip = ", num, sep = '')
    }
  }
  
  delimLoc <- grep("delimiters\\s?=", x, ignore.case = TRUE)
  delim <- substr(x[delimLoc], (which(strsplit(x[delimLoc], '')[[1]]=='=')+1), nchar(x[delimLoc]))
  
  finMat <- matrix(ncol = 1, nrow = 2)
  finMat[1] <- paste("x <- read.table(", path, ", sep = '", delim, "', " header, ")", sep = '')
  
  finMat  
}