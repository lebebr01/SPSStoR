#' Save to R
#' 
#' Converts SPSS Save statements to valid Save statements in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
save_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub('save', '', x, ignore.case = TRUE)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  
  keep_loc <- grep('keep\\s*=', x, ignore.case = TRUE)
  keep_vars <- x[(keep_loc+1):length(x)]
  keeps_vars <- gsub("^\\s+|\\s+$", "", keep_vars)
  keep_vars <- paste0('c(', paste(keep_vars, collapse = ','), ')')
  
  outfile_loc <- grep('outfile\\s*=', x, ignore.case = TRUE)
  
  x <- gsub('/keep\\s*=|outfile\\s*=', '', x, ignore.case = TRUE)
  
  file_loc <- gsub("^ \\'|\\' $", "", x[1])
  file_loc <- gsub('.sav', '.rda', file_loc)
  
  finMat <- matrix(ncol = 1, nrow = 1)
  
  finMat[1] <- paste0('save(x[', keep_vars, '], file = ', file_loc, ')')
  
  finMat
  
}