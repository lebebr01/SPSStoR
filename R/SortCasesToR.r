#' Sort Cases to R
#' 
#' Convert SPSS sort cases command to an R function.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export
sortcases_to_r <- function(x){

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
  
  finMat <- matrix(nrow = 1, ncol = 1)
  finMat[1] <- paste("x <- x[order(", sortVars, "), ]", sep = "")
  
 finMat
}
