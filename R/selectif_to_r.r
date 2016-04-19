#' Select if to R
#' 
#' Converts SPSS select if statements to valid select statements in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @param ... Additional arguments passed to function, not currently supported.
#' @export
selectif_to_r <- function(x, dplyr = TRUE, ...) {
  
  x <- gsub('select if', '', x, ignore.case = TRUE)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  
  if(grepl('eq|=', x, ignore.case = TRUE)) {
    x <- gsub('eq|=', '==', x, ignore.case = TRUE)
  } 
  if(grepl('ge', x, ignore.case = TRUE)) {
    x <- gsub('ge', '>=', x, ignore.case = TRUE)
  }
  if(grepl('gt', x, ignore.case = TRUE)) {
    x <- gsub('gt', '>', x, ignore.case = TRUE)
  } 
  if(grepl('le', x, ignore.case = TRUE)) {
    x <- gsub('le', '<=', x, ignore.case = TRUE)
  } 
  if(grepl('lt', x, ignore.case = TRUE)) {
    x <- gsub('lt', '<', x, ignore.case = TRUE)
  } 
  if(grepl('ne|~=|<>', x, ignore.case = TRUE)) {
    x <- gsub('ne|~=|<>', '!=', x, ignore.case = TRUE)
  } 
  
  finMat <- matrix(nrow = 2, ncol = 1)
  finMat[1] <- 'library(dplyr)'
  finMat[2] <- paste0('x <- x %>% filter(', x, ')')
  
  finMat 
  
}