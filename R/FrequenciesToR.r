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
  freqVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ", ")
  
  orderLoc <- grep("order\\s?=", x, ignore.case = TRUE)
  
  formatLoc <- grep("format\\s?=", x, ignore.case = TRUE)
  
  if(grepl("\\/pie", x, ignore.case), == TRUE){
    pie <- paste("ggplot(x, aes(x = factor(1), fill = ", freqVars, ")) + geom_bar() + 
      coord_polar(theta = 'y')", sep = "")
  }
  
  if(grepl("\\/bar", x, ignore.case) == TRUE){
    bar <- paste("ggplot(x, aes(x = factor(1), fill = ", freqVars, ")) + geom_bar()", sep = '')
  }
  
  if(grepl("\\/hist", x, ignore.case) == TRUE){
    histogram <- paste("ggplot(x, aes(x = factor(1), fill = ", freqVars, ")) + geom_histogram()", 
                       sep = '')
  }
  
}