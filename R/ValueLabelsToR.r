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
valuelabels_to_r <- function(x, dplyr = TRUE) {
  
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


#' Rename Variables to R
#' 
#' Converts SPSS rename variables syntax to R code.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
renamevariables_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub("rename variables", "", x, ignore.case = TRUE)
  x <- gsub("^\\s+", "", x)
  x <- gsub("\\.$", "", x)
  
  x <- gsub('\\(|\\)', '', x)
  
  vars <- do.call('rbind', strsplit(x, '='))
  
  old_vars <- gsub('^\\s+|\\s+$', '', vars[, 1])
  new_vars <- gsub('^\\s+|\\s+$', '', vars[, 2])
  
  rename_vars <- paste0(new_vars, ' = ', old_vars)
  if(length(rename_vars) > 1) {
    rename_vars <- paste(rename_vars, collapse = ' , ')
  }
  
  finMat <- matrix(nrow = 2, ncol = 1)
  finMat[1] <- 'library(dplyr)'
  finMat[2] <- paste0('x <- rename(x, ', rename_vars, ')')
  
  return(finMat)
  
}
