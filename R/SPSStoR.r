#' Master SPSS to R function
#' 
#' This function inputs SPSS syntax and returns comparable R syntax.
#' 
#' The only required input for this function is a text file that contains SPSS syntax.
#' The SPSS syntax can be the .sps syntax file that SPSS saves as or can be
#' copied into another text file format.  The function readLines is used to 
#' read in the file line by line.
#' 
#' A single column matrix is used to return the R code.  If a R command is long
#' it does not wrap the code and so copy and pasting may be needed.  As an alternative,
#' the R syntax can be saved to an R script file. No column names or row names are 
#' printed when saving this script file.
#'
#' @param file Path of text file that has SPSS syntax
#' @param writeRscript TRUE or FALSE variable to write R script.
#'   By default this is FALSE.
#' @param filePath Path to save R script. 
#'   Default is NULL which saves to working directory as 'rScript.r'.
#' @export 
#' @examples 
#' \donttest{
#' 
#' }
spss_to_r <- function(file, writeRscript = FALSE, filePath = NULL){
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
  
  x <- subset(x, grepl(".+", x) == TRUE)
  
  endFuncLoc <- grep("\\.$", x)
  n <- length(endFuncLoc)
  
  funcLoc <- vector("numeric", length = n)
  funcLoc <- sapply(1:n, function(i) endFuncLoc[i-1]+1)
  funcLoc[[1]] <- 1
  
  
  spssfunc <- sapply(funcLoc, function(k) grep("^.+ |^.+", x[k], value = TRUE))
  spssfunc <- gsub("-", "", spssfunc)
  
  if(any(grepl("=",spssfunc)) == TRUE){
    trbl <- grep("=", spssfunc)
    #sapply(1:length(trbl), function(k) unlist(strsplit(spssfunc[k], " "))[1])
    for(k in trbl){
     spssfunc[k] <- unlist(strsplit(spssfunc[k], " "))[1]
    }    
  }
  
  if(any(grepl(" ", spssfunc) == TRUE)){
    loc <- grep(' ', spssfunc)
    for(l in loc){
      spssfunc[l] <- paste(strsplit(spssfunc[l], ' ')[[1]][1:2], collapse = "")
    }
    
  }
  
  spssToR <- as.list(paste(tolower(spssfunc), "_to_r", sep = ""))
  
  funcChunks <- paste(funcLoc, endFuncLoc, sep = ":")
  
  xChunks <- sapply(1:length(funcChunks), function(m) 
    eval(parse(text = paste("x[", funcChunks[m], "]"))))
  
  if(is.list(xChunks) == FALSE){
    FUN <- match.fun(as.character(spssToR))
    rsyntax <- FUN(xChunks)
  } else {
    rsyntax <- unlist(lapply(1:length(spssToR), function(x) 
      do.call(spssToR[[x]], xChunks[x])))
  }  
  
  rsyntax <- c("# x is the name of your data frame", rsyntax)
  rsyntax <- rsyntax[!duplicated(rsyntax, incomparables = "p")]
  
  if(writeRscript == TRUE){
    if(is.null(filePath) == TRUE){ filePath <- getwd()}
    write.table(rsyntax, file = paste(filePath, '/rScript.r', sep = ''), row.names = FALSE, quote = FALSE,
                col.names = FALSE)
  } else {
    rsyntax
  }
}
