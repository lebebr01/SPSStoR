#' T-test to R
#' 
#' Converts SPSS t-test syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @param ... Additional arguments passed to function, not currently supported.
#' @export
ttest_to_r <- function(x, dplyr = TRUE, ...){

  varsLoc <- grep("variables\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
  depVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ", ")
  
  if(any(grepl("testval\\s?=", x, ignore.case = TRUE)) == TRUE){
    testValLoc <- grep("testval\\s?=", x, ignore.case = TRUE)
    testVal <- substr(x[testValLoc], (which(strsplit(x[testValLoc], '')[[1]]=='=')+1), nchar(x[testValLoc]))
  } else {
    testVal <- 0
  }
  
  if(any(grepl("criteria\\s?=", x, ignore.case = TRUE)) == TRUE){
    ciLoc <- grep("criteria\\s?=", x, ignore.case = TRUE)
    ciVal <- substr(x[ciLoc], (which(strsplit(x[ciLoc], '')[[1]]=='(')+1), 
                    (which(strsplit(x[ciLoc], '')[[1]]==')')-1))
  } else {
    ciVal <- .95
  }
  
  if(any(grepl("groups\\s?=", x, ignore.case = TRUE)) == TRUE){
    groupLoc <- grep("groups\\s?=", x, ignore.case = TRUE)
    groupVar <- substr(x[groupLoc], (which(strsplit(x[groupLoc], '')[[1]]=='=')+1), 
                       (which(strsplit(x[groupLoc], '')[[1]]=='(')-1))
    groupVal <- substr(x[groupLoc], (which(strsplit(x[groupLoc], '')[[1]]=='(')+1), 
           (which(strsplit(x[groupLoc], '')[[1]]==')')-1))
    if(length(strsplit(groupVal, ' ')) == 1){
      cutScore = TRUE
    }
  } else { groupVar <- 0}
  
  if(is.character(groupVar) == TRUE){
    finMat <- matrix(ncol = 1, nrow = 4)
  } else {
    finMat <- matrix(ncol = 1, nrow = 1)
  }
  
  
  if(is.character(groupVar) == TRUE){
    finMat[1] <- "library(car)"
    finMat[2] <- paste("leveneTest(", depVars, " ~ ", groupVar, ", data = x)", sep = '')
    finMat[3] <- paste("t.test(", depVars, " ~ ", groupVar, ", data = x, mu = ", testVal, ", conf.level = ",
                       ciVal, ", var.equal = TRUE)", sep = '')
    finMat[4] <- paste("t.test(", depVars, " ~ ", groupVar, ", data = x, mu = ", testVal, ", conf.level = ",
                       ciVal, ", var.equal = FALSE)", sep = '')
  } else{
    finMat[1] <- paste("with(x, t.test(", depVars, ", mu = ", testVal, ", conf.level = ", ciVal, ")", 
                       sep = '')
  }
    
finMat
}
