#' Recode to R
#' 
#' Converts SPSS recode statements to valid recode statements in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
recode_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub('recode', '', x, ignore.case = TRUE)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  
  if(length(x) == 1) {
    start <- regexpr('\\(', x)
    end <- regexpr('\\)', x)
    
    recode_section <- gsub(' ', '', substr(x, start = start, stop = end))
  }
  
  if(length(x) == 1) {
    x <- unlist(strsplit(x, split = ' '))
  }
  
  from_var <- x[1]
  if(any(grepl('into ', x))) {
    to_var <- gsub('into ', '', x[grepl('into ', x)])
  } else {
    to_var <- x[1]
  }
  

  if(length(x) == 1) {
    recode_items <- recode_section[grepl('\\(', recode_section)]
    recode_items <- gsub('\\(|\\)', '', recode_items)
    recode_items <- paste(recode_items, collapse = ';')
    recode_items <- gsub("ELSE", 'else', recode_items)
  } else {
    recode_items <- x[grepl('\\(', x)]
    recode_items <- gsub('\\(|\\)', '', recode_items)
    recode_items <- paste(recode_items, collapse = ';')
    recode_items <- gsub("ELSE", 'else', recode_items)
  }

  finMat <- matrix(nrow = 3, ncol = 1)
  finMat[1] <- 'library(car)'
  finMat[2] <- 'options(useFancyQuotes = FALSE)'
  finMat[3] <- paste0('x$', to_var, ' <- recode(x$', from_var, ', ', 
                      dQuote(recode_items), ')')
  
  finMat 
  
}
