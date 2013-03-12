#' Graphics 
#' 
#' Convert SPSS graph command to an R graph call using ggplot2.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export 

graph_to_r <- function(x){
  
  library(stringr)  
  
  titleLoc <- grep("\\/title\\s?=", x, ignore.case = TRUE)
  if(length(titleLoc) > 0){
    titletxt <- substr(x[titleLoc], (which(strsplit(x[titleLoc], '')[[1]]=='=')+1), nchar(x[titleLoc]))
    titletxt <- gsub("\\.", "", titletxt)
    titleggplot <- paste("+ labs(title = ", titletxt, ")", sep = "")
  }
  
  typeLoc <- grep("\\/bar|\\/line|\\/hilo|\\/histogram|\\/scatterplot|\\/errorbar", x, ignore.case = TRUE)
  type <- tolower(substr(x[typeLoc], (which(strsplit(x[typeLoc], '')[[1]]=='/')+1), 
                 (which(strsplit(x[typeLoc], '')[[1]] %in% c('(', '='))[1]-1)))
  
  if(type == "hilo"){ type <- "pointrange"} else { if(type == "scatterplot"){ type <- "point"}}
  
  type <- paste("geom_", type, sep = '')
  
  if(grepl("\\(", x[typeLoc]) == TRUE){
    typesub <- tolower(substr(x[typeLoc], (which(strsplit(x[typeLoc], '')[[1]]=='(')+1), 
                           (which(strsplit(x[typeLoc], '')[[1]] ==')')-1)))
  }
  
  vars <- substr(x[typeLoc], (which(strsplit(x[typeLoc], '')[[1]]=='=')+1), nchar(x[typeLoc]))
  numBy <- attr(regexpr("BY", x[typeLoc]), "match.length")
  numWith <- attr(regexpr("WITH", x[typeLoc]), "match.length")
  varsSplit <- unlist(strsplit(vars, 'BY|WITH'))
  varsSplit <- gsub("^\\s+|\\s+$", "", gsub("\\.$", "", varsSplit))
  
  
  if(typesub == "normal"){
    normdist <- str_c("+ stat_function(geom='line', fun = dnorm, arg = list(mean = mean(x$",
                      vars, "), sd = sd(x$", vars, ")))")
  }
    
  finMat <- matrix(nrow = length(type) + 2, ncol = 1)
  finMat[1] <- "\\#x is the name of your data frame"
  finMat[2] <- "library(ggplot2)"
  finMat[3] <- paste("p <- ggplot(x, aes(x = ," vars, ")) + ", type)
  
}