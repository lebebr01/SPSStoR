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
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
aggregate_to_r <- function(x, dplyr = TRUE){
  
  if(length(grep("\\/break\\s?=", x, ignore.case = TRUE)) < 1){
    aggVarsOrd <- NULL 
    aggVarsBy <- NULL
  } else {
    varsLoc <- grep("\\/break\\s?=", x, ignore.case = TRUE)
    vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
    aggVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ", ")
    if(dplyr) {
      aggVarsBy <- paste0('group_by(', aggVars, ')')
    } else {
      aggVarsOrd <- paste("order(", aggVars, ")", sep = "")
      aggVarsBy <- paste("by = list(", aggVars, ")", sep = "")
    }
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
  if(is.null(object)) {
    funct <- gsub("\\.", "", funct)
    if(dplyr) {
      funct <- paste(funct, collapse = ", ")
      funct <- paste0('mutate(', funct, ')')
    } else {
      funct <- gsub("=", ":=", funct)
    }
  } else {
    funct <- gsub("\\.", "", paste(funct, collapse = ", "))
    if(dplyr) {
      funct <- paste0('summarize(', funct, ')')
    } else {
      funct <- paste0("list(", funct, ")")
    }
  }  
  
  if(dplyr){
    values <- c('x', aggVarsBy, funct)
    finMat <- matrix(nrow = length(funct) + 1, ncol = 1)
    finMat[1] <- 'library(dplyr)'
    finMat[2] <- paste(values, collapse = ' %>% ')
  } else {
    finMat <- matrix(nrow = length(funct) + 2, ncol = 1)
    finMat[1] <- 'library(data.table)'
    finMat[2] <- 'x <- data.table(x)'
    for(i in 1:length(funct)){
      finMat[i+2] <- paste(object, "x[", aggVarsOrd, ", ", funct[i], ", ", aggVarsBy, "]", sep = "")
    }
  }
   

 finMat
}
