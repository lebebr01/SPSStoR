#' Oneway to R
#' 
#' Converts SPSS oneway syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export
oneway_to_r <- function(x){
 
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
