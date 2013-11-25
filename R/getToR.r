#' Get to R
#' 
#' Converts SPSS get syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export
get_to_r <- function(x){
  
  fileLoc <- grep("file\\s?=", x, ignore.case = TRUE)
  if(any(grepl('\"', x)) == TRUE){
    path <- substr(x[fileLoc], (which(strsplit(x[fileLoc], '')[[1]]=='\"')[1]), 
                   (which(strsplit(x[fileLoc], '')[[1]]=='\"')[2]))
  } else {
    path <- substr(x[fileLoc], (which(strsplit(x[fileLoc], '')[[1]]=='\'')[1]), 
                   (which(strsplit(x[fileLoc], '')[[1]]=='\'')[2]))
  }
  
  finMat <- matrix(ncol = 1, nrow = 2)
  finMat[1] <- "library(foreign)"
  finMat[2] <- paste("x <- read.spss(", path, ", to.data.frame = TRUE)", sep = '')
  
finMat
}
