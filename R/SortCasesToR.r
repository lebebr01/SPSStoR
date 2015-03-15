#' Sort Cases to R
#' 
#' Convert SPSS sort cases command to an R function.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
sortcases_to_r <- function(x, dplyr = TRUE){

  loc <- grep("sort cases", x, ignore.case = TRUE)
  byLoc <- grep("by", x, ignore.case = TRUE)
  
  if(length(byLoc) < 1){
    sortVars <- substr(x, 12, nchar(x))
  } else {
    sortVars <- substr(x, 15, nchar(x))
  }
  
  sortVars <- gsub("\\s{1}\\(", "\\(", sortVars)
  sortVars <- gsub("\\.", "", sortVars)
  sortVars <- unlist(strsplit(sortVars, " "))
  
  decLoc <- grep("\\(d\\)|\\(down\\)", sortVars, ignore.case = TRUE)
  
  sortVars <- gsub("\\([a-zA-Z]*\\)", "", sortVars)
  if(length(decLoc) > 0){
    sortVars[decLoc] <- gsub("^", "-", sortVars[decLoc])
  }
  
  sortVars <- paste(sortVars, collapse = ", ")
  
  finMat <- matrix(nrow = 2, ncol = 1)
  if(dplyr) {
    finMat[1] <- 'library(dplyr)'
    finMat[2] <- paste0('x <- arrange(', sortVars, ')')
  } else {
    finMat[1] <- 'library(data.table)'
    finMat[2] <- paste0("x <- x[order(", sortVars, "), ]")
  }
  
 finMat
}
