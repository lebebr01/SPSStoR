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
#' @param nosave A value of FALSE processes the save commands (default),
#'              a value of TRUE continues processing within R, overriding 
#'              default x object. Extreme care with this feature.
#' @export
save_to_r <- function(x, dplyr = TRUE, nosave = FALSE) {
  
  x <- gsub('save', '', x, ignore.case = TRUE)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  
  keep_loc <- grep('keep\\s*=', x, ignore.case = TRUE)
  keep_vars <- x[(keep_loc+1):length(x)]
  keeps_vars <- gsub("^\\s+|\\s+$", "", keep_vars)
  keep_vars <- paste(keep_vars, collapse = '","')
  keep_vars <- gsub('^\\s+|\\s+$', '', keep_vars)
  keep_vars <- paste0('c("', keep_vars, '")')
  
  outfile_loc <- grep('outfile\\s*=', x, ignore.case = TRUE)
  
  x <- gsub('/keep\\s*=|outfile\\s*=', '', x, ignore.case = TRUE)
  
  file_loc <- gsub("^ \\'|\\' $", "", x[1])
  #file_loc <- gsub('.sav', '.rda', file_loc)
  if(grepl('^/', file_loc)) {
    file_loc <- gsub('^/', '', file_loc)
  }
  
  finMat <- matrix(ncol = 1, nrow = 2)
  
  #finMat[1] <- 'library(foreign)'
  finMat[1] <- paste0('tmp <- x[', keep_vars, ']')
  
  if(nosave) {
    finMat[2] <- 'x <- tmp'
  } else {
    finMat[2] <- paste0('save(tmp, file = ', sQuote(file_loc), 
                        ')')
  }
  
  finMat
  
}