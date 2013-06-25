#' Crosstab to R
#' 
#' Converts SPSS crosstab syntax to R table syntax.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @import stringr
#' @export 
crosstabs_to_r <- function(x){

  varsLoc <- grep("\\/tables\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
  vars <- gsub("^\\s+|\\s+$", "", vars)
  numby <- str_count(vars, "BY|by")
  if(numby == 1){
    rowvar <- unlist(strsplit(gsub("^\\s+|\\s+$", "", 
                                   unlist(strsplit(vars, "BY|by"))[1]), " "))
    colvar <- unlist(strsplit(gsub("^\\s+|\\s+$", "", 
                                   unlist(strsplit(vars, "BY|by"))[2]), " "))
    tabs <- expand.grid(rowvar, colvar)
    names(tabs) <- c("row", "col")
  } else {
    stop("Currently only supports one by statement")
  }
  cellsLoc <- grep("\\/cells\\s?=", x, ignore.case = TRUE)
  if(length(grep("\\/cells\\s?=", x, ignore.case = TRUE)) > 0 ) {
    num <- str_count(x[cellsLoc], "COUNT|count|COLUMN|column|TOTAL|total|ROW|row")
    cells <- paste(ifelse(grepl("COUNT|count", x[cellsLoc]) == TRUE, "\'n\'", NA), 
                   ifelse(grepl("COLUMN|column", x[cellsLoc]) == TRUE, "\'c\'", NA),
                   ifelse(grepl("TOTAL|total", x[cellsLoc]) == TRUE, "\'t\'", NA),
                   ifelse(grepl("ROW|row", x[cellsLoc]) == TRUE, "\'r\'", NA), sep = ",")
    tabs$cells <- gsub("NA,", "", cells)
  } else {
    tabs$cells <- "n"
  }
 finMat <- matrix(nrow=nrow(tabs) + 1, ncol = 1)
  finMat[1] <- "library(catspec)"
 for(i in 1:nrow(tabs)){
   finMat[i+1] <- paste("ctab(with(x, table(", tabs$row[i],",", 
                      tabs$col[i], ")), type = c(", tabs$cells[i], "))", sep = "") 
 }
  finMat
}