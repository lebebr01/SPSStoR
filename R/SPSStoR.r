#' Master SPSS to R function
#'
#' @param file path of text file that has spss syntax
#'
spss_to_r <- function(file){
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
  
  x <- subset(x, grepl(".+", x) == TRUE)
  
  endFuncLoc <- grep("\\.$", x)
  n <- length(endFuncLoc)
  
  funcLoc <- vector("numeric", length = n)
  funcLoc <- sapply(1:n, function(i) endFuncLoc[i-1]+1)
  #funcLoc[1] <- 1
  #if(length(endFuncLoc) > 1){
    #for(i in 2:n){
     # funcLoc[i] <- endFuncLoc[i-1]+1
    #}
  #}  
  
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
  
  rsyntax
}