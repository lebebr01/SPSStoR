#' Aggregate to R
#' 
#' Converts SPSS aggregate syntax to aggregate in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.  The R syntax used by default is from the 
#' data.table package as this allows the ability to easily save aggregated 
#' variables back into the original R data frame.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
aggregate_to_r <- function(x){
  
  if(length(grep("\\/break\\s?=", x, ignore.case = TRUE)) < 1){
    aggVarsOrd <- NULL 
    aggVarsBy <- NULL
  } else {
    varsLoc <- grep("\\/break\\s?=", x, ignore.case = TRUE)
    vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
    aggVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ", ")
    aggVarsOrd <- paste("order(", aggVars, ")", sep = "")
    aggVarsBy <- paste("by = list(", aggVars, ")", sep = "")
  }  
  
  if(length(grep("\\/outfile\\s?=", x, ignore.case = TRUE)) < 1 | 
       length(grep("addvariables", x, ignore.case = TRUE)) == 1){
    object <- NULL
  } else {
    objectLoc <- grep("\\/outfile\\s?=", x, ignore.case = TRUE)
    object <- unlist(strsplit(substr(x[objectLoc], (which(strsplit(x[objectLoc], '')[[1]]=='=')+1), 
                                     nchar(x[objectLoc])), "/"))
    object <- gsub(".sav", "", object[length(object)])
    object <- gsub("^\'|\'$", "", object)
    object <- paste(object, " <- ", sep = "")
  }  
    
  calcLoc <- grep("aggregate|outfile|document|presorted|break|missing", 
                  x, ignore.case = TRUE, invert = TRUE)
    
  funct <- matrix(ncol = 1, nrow = length(calcLoc))
  for(i in 1:length(calcLoc)){
    funct[i] <- tolower(gsub("/", "", x[calcLoc[i]]))
  }
  if(length(object) < 1) {
    funct <- gsub("=", ":=", funct)
    funct <- gsub("\\.", "", funct)
  } else {
    funct <- gsub("\\.", "", paste(funct, collapse = ", "))
    funct <- paste("list(", funct, ")", sep = "")
  }  
  
    finMat <- matrix(nrow = length(funct) + 2, ncol = 1)
    finMat[1] <- 'library(data.table)'
    finMat[2] <- 'x <- data.table(x)'
    for(i in 1:length(funct)){
      finMat[i+2] <- paste(object, "x[", aggVarsOrd, ", ", funct[i], ", ", aggVarsBy, "]", sep = "")
    }

 finMat
}
