#' Missing Values to R
#' 
#' Converts SPSS missing value syntax to R code. Currently assumes
#'   that there is only one missing value code per line.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
missingvalues_to_r <- function(x, dplyr = TRUE){
  
  x <- gsub("missing values", "", x, ignore.case = TRUE)
  x <- gsub("^\\s+", "", x)
  x <- gsub("\\.$", "", x)

  xsplit <- unlist(strsplit(x, " "))
  
  missval <- xsplit[grep("\\(", xsplit)]
  missval <- gsub("\\(|\\)", "", missval)
  
  vars <- xsplit[-grep("\\(", xsplit)]
  
  natrans <- paste0("x$var[x$var == ", missval, "] <- NA")
  
  misscode <- sapply(1:length(vars), function(xx) 
    gsub("var", vars[xx], natrans))
  
  misscode 
  
}  