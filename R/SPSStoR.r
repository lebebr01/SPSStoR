#' Master SPSS to R function
#'
#'
SPSS_to_R <- function(file){
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
  
  x <- subset(x, grepl(".+", x) == TRUE)
  
  endFuncLoc <- grep("\\.", x)
  n <- length(endFuncLoc)
  
  funcLoc <- vector("numeric", length = n)
  funcLoc[1] <- 1
  for(i in 2:n){
    funcLoc[i] <- endFuncLoc[n-1]+1
  }
  
  spssfunc <- sapply(funcLoc, function(k) grep("^.+ |^.+", x[k], value = TRUE))
  
  if(any(grepl("=",spssfunc)) == TRUE){
    trbl <- grep("=", spssfunc)
    #sapply(1:length(trbl), function(k) unlist(strsplit(spssfunc[k], " "))[1])
    for(k in trbl){
     spssfunc[k] <- unlist(strsplit(spssfunc[k], " "))[1]
    }    
  }
  
  spssToR <- as.list(paste(tolower(spssfunc), "_to_r", sep = ""))
  
  funcChunks <- paste(funcLoc, endFuncLoc, sep = ":")
  
  xChunks <- sapply(1:length(funcChunks), function(m) 
    eval(parse(text = paste("x[", funcChunks[m], "]"))))
  
  rsyntax <- unlist(lapply(1:length(spssToR), function(x) 
    do.call(as.character(spssToR[x]), xChunks[x])))
  
  return(rsyntax)
}