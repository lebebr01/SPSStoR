#' Value Labels to R
#' 
#' Converts SPSS value label syntax to R code. Currently only 
#'   supports adding labels to continuous variables and one 
#'   variable per value labels command.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @importFrom stringr str_extract 
#' @importFrom stringr str_replace_all
#' @export
valuelabels_to_r <- function(x, dplyr = TRUE){
  
  x <- gsub("value labels", "", x, ignore.case = TRUE)
  x <- gsub("^\\s+", "", x)
  x <- gsub("\\.$", "", x)
 
  if(any(grepl("\\'", x))) {
    labels <- str_extract(x, "\\'.+\\'")
  } else {
    labels <- str_extract(x, '\\".+\\"')
  }
  
  if(any(grepl("\\'", x))) {
    nolab <- str_replace_all(x, "\\'.+\\'", '')
  } else {
    nolab <- str_replace_all(x, '\\".+\\"', '')
  }
  
  nolab <- gsub("\\s+$", "", nolab)
  
  var <- unlist(strsplit(nolab, " "))[1]
  values <- unlist(strsplit(nolab, " "))[2:(2+length(labels)-1)]
  
  finmat <- paste0("x$", var, " <- factor(x$", var, 
                   ", levels = c(", paste(values, collapse = ", "), 
                   "), labels = c(", paste(labels, collapse = ", "), "))")
  finmat
}  
