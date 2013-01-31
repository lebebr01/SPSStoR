#' 
#' 
#' 
#' @param file path of text file with spss crosstab syntax
#' @export 

sortcases_to_r <- function(file){
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
  
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
  finMat[1] <- "\\#x is the name of your data frame"
  finMat[2] <- paste("x <- x[order(", sortVars, "), ]", sep = "")
  
 finMat
}