#' Regression to R
#' 
#' Converts SPSS regression syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export
regression_to_r <- function(x){
  
  x <- gsub("regression\\s*", "", x, ignore.case = TRUE)
  if(nchar(x[1]) == 0) { x <- x[-1] }
  
  if(any(grepl("^\\/origin", x, ignore.case = TRUE))) {
    noint <- "- 1"
  } else { 
    noint <- NULL
  }
  
  if(any(grepl("statistics\\s*", x, ignore.case = TRUE)) == FALSE){
    sumout <- "summary(mod_1)"
    anovaout <- "anova(mod_1)"
  } else {
    statLoc <- grep("statistics\\s*", x, ignore.case = TRUE)
    if(any(grepl("anova", x[statLoc], ignore.case = TRUE)) == FALSE){
      anovaout <- NULL
    } else {
      sumout <- "summary(mod_1)"
      anovaout <- "anova(mod_1)"
    }
  }
  
  if(any(grepl("missing\\s+?", x, ignore.case = TRUE)) == FALSE){
    miss <- NULL 
  } else {
    missLoc <- grep("missing\\s*", x, ignore.case = TRUE)
    if(any(grepl("listwise", x[missLoc], ignore.case = TRUE))){
      miss <- "x1 <- na.omit(x)"
    }
  }
  
  depLoc <- grep("dependent\\s*", x, ignore.case = TRUE)
  depVar <- strsplit(x[depLoc], " ")[[1]][2]
  
  methodLoc <- grep("method\\s*=enter", x, ignore.case = TRUE)
  method <- gsub("^\\/method\\s*=enter\\s*", "", x[methodLoc], 
                 ignore.case = TRUE)
  indvars <- unlist(strsplit(method, " "))
  indvars <- paste(indvars, collapse = " + ")
  
  vars <- paste(depVar, indvars, sep = " ~ ")
  vars <- paste0(vars, noint)
  
  
  if(is.null(miss)){
    finMat <- matrix(nrow = 1, ncol = 1)
    finMat[1] <- paste0('mod_1 <- lm(', vars, ', data = x)')
    finMat <- rbind(finMat, sumout, anovaout)
  } else {
    finMat <- matrix(nrow = 2, ncol = 1)
    finMat[1] <- miss
    finMat[2] <- paste0('mod_1 <- lm(', vars, ', data = x)')
    finMat <- c(finMat, sumout, anovaout)
  }
  
  finMat
}
  