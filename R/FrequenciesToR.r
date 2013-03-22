#' Frequencies
#' 
#' Convert SPSS frequencies command to an R syntax.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export 
#' 
frequencies_to_r <- function(x) {
  
  varsLoc <- grep("variables\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
  freqVars <- unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " "))
  
  #orderLoc <- grep("order\\s?=", x, ignore.case = TRUE)
  
  if(any(grepl("format\\s?=\\s?notable", x, ignore.case = TRUE))){
    freqOut <- ""
  } else { 
    freqOut <- sapply(1:length(freqVars), function(ii) 
      paste("with(x, table(", freqVars[ii], "))", sep = '')) 
  }
  
  if(any(grepl("^\\/stat", x, ignore.case = TRUE))){
    statOut <- descriptives_to_r(x)
  } else { statsOut <- "" }
  
  if(any(grepl("^\\/ntiles\\s?=", x, ignore.case = TRUE))){
    ntileLoc <- grep("^\\/ntiles\\s?=", x, ignore.case = TRUE)
    numBreak <- sapply(1:length(ntileLoc), function(ii) 
      as.numeric(substr(x[ntileLoc[ii]], (which(strsplit(x[ntileLoc[ii]], '')[[1]]=='=')+1), 
                                  nchar(x[ntileLoc[ii]]))))
    ntilesOut <- sapply(1:length(ntileLoc), function(ii) 
      paste("quantile(x, probs = seq(0, 1, 1/", numBreak[ii], "), type = 6)", sep = ''))
  } else { ntilesOut <- "" }
  
  if(any(grepl("^\\/percentiles\\s?=", x, ignore.case = TRUE))){
    perLoc <- grep("^\\/percentiles\\s?=", x, ignore.case = TRUE)
    nums <- substr(x[perLoc], (which(strsplit(x[perLoc], '')[[1]]=='=')+1), nchar(x[perLoc]))
    probNum <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", nums), " ")), collapse = ", ")
    percentileOut <- paste("quantile(x, probs = c(", probNum, "), type = 6)", sep = '') 
  } else { percentileOut <- "" }
  
  if(any(grepl("^\\/pie", x, ignore.case = TRUE))){
    pieG <- sapply(1:length(freqVars), function(ii) 
      paste("ggplot(x, aes(x = factor(1), fill = ", freqVars[ii], ")) + geom_bar() + coord_polar(theta = 'y')", sep = ""))
  } else { pieG <- "" }
  
  if(any(grepl("^\\/bar", x, ignore.case = TRUE))){
    barG <- sapply(1:length(freqVars), function(ii) 
      paste("ggplot(x, aes(x = factor(1), fill = ", freqVars[ii], ")) + geom_bar()", sep = ''))
  } else { barG <- ""}
  
  if(any(grepl("^\\/hist", x, ignore.case = TRUE))){
    histogramG <- sapply(1:length(freqVars), function(ii) 
      paste("ggplot(x, aes(x = factor(1), fill = ", freqVars[ii], ")) + geom_histogram()", sep = ''))
  } else { histogramG <- "" }
  
}