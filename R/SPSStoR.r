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
    for(k in trbl){
      spssfunc[k] <- unlist(strsplit(spssfunc[k], " "))[1]
    }    
  }
  
  spssfunc <- tolower(spssfunc)
  
}