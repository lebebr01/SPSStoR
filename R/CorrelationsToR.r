#' 
#' 
#' 
#' @param file path of text file with spss crosstab syntax
#' @export 

correlations_to_cor <- function(file){
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
  
  varsLoc <- grep("variables\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
  corVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ", ")
  
  if(length(grep("\\/missing\\s?=\\s?pairwise", x, ignore.case = TRUE)) == 1){
    missing <- "use = pairwise.complete.obs"
  } else {
    missing <- "use = na.or.complete"
  }
    
  finMat <- matrix(nrow = 2, ncol = 1)
  finMat[1] <- "\\#x is the name of your data frame"
  finMat[2] <- paste("with(x, cor(cbind(", corVars, ")),", missing, ")", sep = "")
    
  finMat
}