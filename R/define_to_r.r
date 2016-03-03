#' Define to R
#' 
#' Converts SPSS define statements to valid define statements in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
define_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  
  loc_define_start <- grep('define ', x)
  loc_define_end <- grep('enddefine', x)
  
  vars <- x[c(-loc_define_start, -loc_define_end)]
  
  name <- gsub("define |\\(|\\)", "", x[loc_define_start])
  
  finMat <- matrix(nrow = 1, ncol = 1)
  finMat[1] <- paste0(name, ' <- c(', 
                      paste(sQuote(vars), collapse = ","), 
                            ')')
  
  finMat 
  
}
