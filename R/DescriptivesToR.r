#' Descriptives to R
#' 
#' Converts SPSS descriptives syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export 

descriptives_to_r <- function(x){
  
  varsLoc <- grep("variables\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
  descVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ", ")
  
  statLoc <- grep("statistics\\s?=|stats\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[statLoc], (which(strsplit(x[statLoc], '')[[1]]=='=')+1), nchar(x[statLoc]))
  vars <- gsub("^\\s+|\\s+$", "", gsub("\\.", "", vars))
  stats <- paste(unlist(strsplit(vars, " ")), collapse = ", ")
  stats <- tolower(stats)
  stats <- gsub("stddev", "sd", stats)
  stats <- gsub("variance", "var", stats)
  stats <- gsub("minimum", "min", stats)
  stats <- gsub("maximum", "max", stats)
  if(grepl("all", stats) == TRUE){
    stats <- paste("mean", "semean", "sd", "var", "kurtosis", "skewness", "range", "min", "max",
                   "sum", sep = ", ")
  } 
  if(grepl("default", stats) == TRUE){
    stats <- paste("mean", "sd", "min", "max", sep = ", ")
  }
    
  if(grepl("skewness|kurtosis", stats) == TRUE){
    finMat <- matrix(ncol = 1, nrow = 3)
    finMat[1] <- 'library(SPSStoR)'
    finMat[2] <- 'library(e1071)'
    finMat[3] <- paste('with(x, descmat(x = list(', descVars, '), ', stats, '))', sep = '')
  } else {
    finMat <- matrix(ncol = 1, nrow = 2)
    finMat[1] <- 'library(SPSStoR)'
    finMat[2] <- paste('with(x, descmat(x = list(', descVars, '), ', stats, '))', sep = '')
  }
  
 finMat
}
