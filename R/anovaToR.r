#' Oneway to R
#' 
#' Converts SPSS oneway syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @param ... Additional arguments passed to function, not currently supported.
#' @export
oneway_to_r <- function(x, dplyr = TRUE, ...){
 
  x <- gsub("oneway\\s+", "", x, ignore.case = TRUE)
  
  vars <- unlist(strsplit(x[1], split = "by|BY"))
  vars <- gsub("^\\s+", "", vars)
  vars[2] <- paste(" factor(", vars[2], ")", sep = "")
  vars <- paste(vars, collapse = "~") 
  
  model <- c(paste("aov.mod <- aov(", vars, ", data = x)", sep = ''),
             "summary(aov.mod)")
  
  if(any(grepl("statistics\\s+?", x, ignore.case = TRUE)) == FALSE){
    levene <- NULL
    brown <- NULL
    welch <- NULL 
  } else {
    statLoc <- grep("statistics\\s+?", x, ignore.case = TRUE)
    if(any(grepl("homogeneity", x[statLoc], ignore.case = TRUE)) == FALSE){
      levene <- NULL 
    } else {
      levene <- c("library(car)", paste("leveneTest(", vars, 
                                        ", data = x, center = mean)", sep = ""))
    }
    if(any(grepl("brownforsythe", x[statLoc], ignore.case = TRUE)) == FALSE){
      brown <- NULL 
    } else {
      brown <- c("library(car)", paste("leveneTest(", vars,
                                       ", data = x)", sep = ""))
    }
    if(any(grepl("welch", x[statLoc], ignore.case = TRUE)) == FALSE){
      welch <- NULL 
    } else {
      welch <- paste("oneway.test(", vars, "data = x)")
    }
  }
  
  if(any(grepl("missing\\s+?", x, ignore.case = TRUE)) == FALSE){
    miss <- NULL 
  } else {
    missLoc <- grep("missing\\s+?", x, ignore.case = TRUE)
    if(any(grepl("listwise", x[missLoc], ignore.case = TRUE))){
      miss <- "x1 <- na.omit(x)"
    }
  }
  
  if(any(grepl("posthoc", x, ignore.case = TRUE)) == FALSE){
    tukey <- NULL 
  } else {
    phLoc <- grep("posthoc", x, ignore.case = TRUE)
    if(any(grepl("tukey", x[phLoc], ignore.case = TRUE))){
      tukey <- "TukeyHSD(aov.mod)"
    }
  }
  
  if(is.null(miss)){
    finMat <- c(model, levene, brown, welch, tukey)
  } else {
    finMat <- c(miss, model, levene, brown, welch, tukey)
    finMat <- gsub("data = x", "data = x1", finMat)
  }
  
 finMat  
}

#' Unianova to R
#' 
#' Converts SPSS unianova syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param ... Additional arguments passed to function, not currently supported.
#' @export
unianova_to_r <- function(x, ...){
  
  x <- gsub("unianova\\s*", "", x, ignore.case = TRUE)
  if(nchar(x[1]) == 0) { x <- x[-1] }
  
  vars <- unlist(strsplit(x[1], split = "by|BY|with|WITH"))
  vars <- gsub("^\\s+|\\s+$", "", vars)
  depvar <- vars[1]
    if(length(vars) == 3) { cov <- vars[3] } else { cov <- ''}
  ivar <- vars[2]  
  ivar <- unlist(strsplit(ivar, " "))
    
  modelLoc <- grep("design", x, ignore.case = TRUE)
  if(length(grep("=", x[modelLoc])) == 0){
    indvars <- vector("character", length(ivar))
    for(xx in 1:length(ivar)) {
      indvars[xx] <- paste("factor(", ivar[xx], ")", sep = "")
    } 
    indvars <- subset(indvars, nchar(indvars) > 0)
    indvars <- paste(indvars, collapse = "*")
    indvars <- c(cov, indvars)
    indvars <- paste(indvars, collapse = " + ")
  } else {
    indvars <- unlist(strsplit(strsplit(x[modelLoc], "=")[[1]][2], " "))
    indvars <- gsub("\\.", "", indvars)
    for(xx in 1:length(ivar)) {
      indvars <- gsub(ivar[xx], paste("factor(", ivar[xx], ")", sep = ""), indvars)
    }     
    indvars <- subset(indvars, nchar(indvars) > 0)
    indvars <- paste(indvars, collapse = " + ")
    #indvars <- c(cov, indvars)
    #indvars <- paste(indvars, collapse = " + ")
    indvars <- gsub("\\*", ":", indvars)
  }
    
  vars <- c(depvar, indvars)  
  vars <- paste(vars, collapse = " ~ ") 

  sstype <- grep("method", x, ignore.case = TRUE)
  if(length(sstype) == 0) {
    ss <- matrix(c('library(car)', 
      paste0('Anova(mod_1, type = 3)')))
  } else {
    tmp <- regexec('^.*?\\([^\\d]*(\\d+)[^\\d]*\\).*$', x, ignore.case = TRUE)
    sst <- as.numeric(unlist(regmatches(x, tmp))[2])
    if(sst %in% c(2, 3)) {
      ss <- matrix(c('library(car)', 
      paste0('Anova(mod_1, type = ', sst, ')')))
    } else {
      ss <- matrix(c('anova(mod_1)'))
    }
  }

  finMat <- matrix(nrow = 2, ncol = 1)
  finMat[1] <- '# Note: A * is a factorial expansion, and : represents an interaction'
  finMat[2] <- paste0('mod_1 <- lm(', vars, ', data = x)')
  finMat <- c(finMat, ss)
    
  finMat
}
