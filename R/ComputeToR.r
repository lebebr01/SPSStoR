#' Compute to R
#' 
#' Converts SPSS compute statements to variable creation in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
compute_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub('compute', '', x, ignore.case = TRUE)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  
  varname <- gsub("^\\s+|\\s+$", "", unlist(strsplit(x, '='))[1])
  expr <- gsub("^\\s+|\\s+$", "", unlist(strsplit(x, '='))[2])
  
  if(grepl('\\(', expr)) {
    func <- tolower(unlist(strsplit(expr, '\\('))[1])
    vars <- unlist(strsplit(expr, '\\('))[2]
    expr <- paste(func, vars, sep = '(')
  }
  
  if(grepl('min|max|mean|sum', expr, ignore.case = TRUE)) {
    expr <- gsub(')$', ', na.rm = TRUE)', expr)
  }
  
  finMat <- matrix(nrow = 1, ncol = 1)
  finMat[1] <- paste0('x$', varname, ' <- ', expr)
  
  finMat  
}
