#' Match Files to R
#' 
#' Converts SPSS match files statements to valid match files statements in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
matchfiles_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub('match files', '', x, ignore.case = TRUE)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  
  if(length(x) == 1) {
    x_split <- unlist(strsplit(x, split = '/'))
  } else {
    x_split <- x
  }
  
  if(any(grepl('table', x_split, ignore.case = TRUE))) {
    table_loc <- grep('table', x_split, ignore.case = TRUE)
    table_command <- x_split[table_loc]
    table_var <- gsub('table\\s?=\\s?', '', table_command, ignore.case = TRUE)
  }
  if(any(grepl('by', x_split, ignore.case = TRUE))) {
    by_loc <- grep('by', x_split, ignore.case = TRUE)
    by_command <- x_split[by_loc]
    by_var <- gsub('by\\s?=\\s?', '', by_command, ignore.case = TRUE)
  }
  if(any(grepl('file', x_split, ignore.case = TRUE))) {
    file_loc <- grep('file', x_split, ignore.case = TRUE)
    file_command <- x_split[file_loc]
    file_var <- gsub('file\\s?=\\s?', '', file_command, ignore.case = TRUE)
    if(any(grepl('\\*', file_var))) {
      star_loc <- grep('\\*', file_var)
      file_var[star_loc] <- 'x'
    }
  }
  
  finMat <- matrix(nrow = 3, ncol = 1)
  finMat[1] <- 'library(dplyr); options(useFanceQuotes = FALSE); library(haven)'
  finMat[2] <- paste0('table_var <- read_spss(path = ', table_var, ')')
  finMat[3] <- paste0('x <- left_join(', file_var, ', table_var', 
                      ', by = ', sQuote(by_var), ')')
  
  return(finMat)
  
  
}