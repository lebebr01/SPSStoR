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
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @param writeRscript TRUE or FALSE variable to write R script.
#'   By default this is FALSE.
#' @param filePath Path to save R script. 
#'   Default is NULL which saves to working directory as 'rScript.r'.
#' @export 
#' @examples 
#' \donttest{
#' 
#' }
spss_to_r <- function(file, dplyr = TRUE, writeRscript = FALSE, filePath = NULL){
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\t", " ", x)
  
  x <- subset(x, grepl(".+", x) == TRUE)
  
  x <- subset(x, grepl("^\\*", x) == FALSE)
  
  endFuncLoc <- grep("\\.$", x)
  n <- length(endFuncLoc)
  
  funcLoc <- vector("numeric", length = n)
  funcLoc <- sapply(1:n, function(i) endFuncLoc[i-1]+1)
  funcLoc[[1]] <- 1
  
  
  spssfunc <- sapply(funcLoc, function(k) grep("^.+ |^.+", x[k], value = TRUE))
  spssfunc <- gsub("-", "", spssfunc)
  
  if(any(grepl("get data", spssfunc, ignore.case = TRUE))){
    loc <- grep("get data", spssfunc, ignore.case = TRUE)
    spssfunc[loc] <- "getdata"
  }
  if(any(grepl("file handle", spssfunc, ignore.case = TRUE))){
    loc <- grep("file handle", spssfunc, ignore.case = TRUE)
    spssfunc[loc] <- 'filehandle'
  }
  if(any(grepl('do repeat', spssfunc, ignore.case = TRUE))){
    loc <- grep('do repeat', spssfunc, ignore.case = TRUE)
    spssfunc[loc] <- 'dorepeat'
    loc_end <- grep('end repeat', spssfunc, ignore.case = TRUE)
    remove_loc <- paste0('c(', paste(paste0(loc + 1, ':', loc_end), collapse = ','),
                         ')')
    spssfunc <- spssfunc[-eval(parse(text = remove_loc))]
    funcLoc <- funcLoc[-eval(parse(text = remove_loc))]
    remove_loc <- paste0('c(', paste(paste0(loc, ':', loc_end - 1), collapse = ','),
                         ')')
    endFuncLoc <- endFuncLoc[-eval(parse(text = remove_loc))]
  }
  
  if(any(grepl("=|by|BY",spssfunc)) == TRUE){
    trbl <- grep("=|by|BY", spssfunc)
    spssfunc[trbl] <- sapply(trbl, function(k) 
      unlist(strsplit(spssfunc[k], " "))[1])
  }
  
  if(any(grepl(" ", spssfunc) == TRUE)){
    loc <- grep(' ', spssfunc)
    spssfunc[loc] <- sapply(loc, function(l) 
      paste(strsplit(spssfunc[l], ' ')[[1]][1:2], collapse = ""))
  }
  
  spssfunc <- gsub("sort$", "sortcases", spssfunc, ignore.case = TRUE)
  spssfunc <- gsub("missing$", "missingvalues", spssfunc, ignore.case = TRUE)
  spssfunc <- gsub("value$", "valuelabels", spssfunc, ignore.case = TRUE)
  
  spssToR <- as.list(paste(tolower(spssfunc), "_to_r", sep = ""))
  
  funcChunks <- paste(funcLoc, endFuncLoc, sep = ":")
  
  xChunks <- lapply(1:length(funcChunks), function(m) 
    eval(parse(text = paste("x[", funcChunks[m], "]"))))
  
  if(is.list(xChunks) == FALSE){
    FUN <- match.fun(as.character(spssToR))
    rsyntax <- FUN(xChunks, dp)
  } else {
    rsyntax <- unlist(lapply(1:length(spssToR), function(x) 
      do.call(spssToR[[x]], xChunks[x], dplyr)))
  }  
  
  rsyntax <- c("# x is the name of your data frame", rsyntax)
  rsyntax <- rsyntax[!duplicated(rsyntax, incomparables = "p")]
  
  if(writeRscript == TRUE){
    if(is.null(filePath) == TRUE){ filePath <- getwd()}
    write.table(rsyntax, file = paste0(filePath, '/rScript.r'), row.names = FALSE, quote = FALSE,
                col.names = FALSE)
  } else {
    class(rsyntax) <- "rsyntax"
    rsyntax
  }
}
