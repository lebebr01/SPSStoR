#' File Handle to R
#' 
#' Converts SPSS file handle statements to valid file handle statements in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
filehandle_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub('file handle', '', x, ignore.case = TRUE)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  
  split_var <- unlist(strsplit(x, '/'))
  
  path_name <- split_var[1]
  
  path <- stringr::str_extract(split_var[2], "\'([^]]+)\'")
  path <- gsub("\'", '', path)
  
  finMat <- paste0('setwd(', sQuote(path), ')')
  
  finMat
  
}