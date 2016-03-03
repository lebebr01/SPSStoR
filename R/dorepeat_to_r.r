#' Do Repeat to R
#' 
#' Converts SPSS do repeat statements to valid do repeat statements in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
dorepeat_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub('do repeat', '', x)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\.$", "", x)
  x <- x[-length(x)]
  
  slash_loc <- grep('/', x)
  
  define_vars <- unlist(strsplit(x[1], '/'))
  object_name <- gsub("=.*$", '', define_vars)
  
  placeholders <- matrix(nrow = length(define_vars), ncol = 1)
  for(i in seq_along(define_vars)) {
    if(grepl(' to ', define_vars[i], ignore.case = TRUE)) {
      split_vars <- unlist(strsplit(define_vars[i], '='))
      name_var <- split_vars[1]
      seq_vars <- split_vars[2]
      
      vars <- strsplit(seq_vars, split = ' to ')
      digits <- lapply(seq_along(vars), function(xx) 
        gsub('[a-zA-Z][[:punct:]]*', '', vars[[xx]]))
      alpha <- lapply(seq_along(vars), function(xx)
        gsub('[0-9]', '', vars[[xx]])[1])
      num_digits <- lapply(seq_along(digits), function(xx) 
        paste0('%0', nchar(digits[[xx]][1]), 'd'))
      sequence <- lapply(seq_along(digits), function(xx)
        sprintf(num_digits[[xx]], digits[[xx]][1]:digits[[xx]][2]))
      vars <- unlist(lapply(seq_along(alpha), function(xx)
        paste0(alpha[[xx]], sequence[[xx]])))
      #vars <- paste(vars, collapse = ",")
      placeholders[i] <- paste0(name_var, ' <- c(', 
                         paste(sQuote(vars), collapse = ","), 
                         ')')
    } else {
      placeholders[i] <- define_vars[i]
    }
  }
  
  statement_loc <- grep('/', x)
  statement <- x[-statement_loc]
  for(i in seq_along(object_name)) {
    statement <- gsub(paste0(object_name[i]), 
                      paste0(object_name[i], '[i]'),
                      statement)
  }
  if(grepl('sysmis', statement, ignore.case = TRUE)) {
    statement <- gsub('sysmis', 'is.na', statement, ignore.case = TRUE)
  }
  if(grepl('not', statement, ignore.case = TRUE)) {
    statement <- gsub('not ', '!', statement, ignore.case = TRUE)
  }
  if(grepl('ne ', statement, ignore.case = TRUE)) {
    statement <- gsub('ne ', '!=', statement, ignore.case = TRUE)
  }
  true_val <- gsub('^.*=\\s*', '', statement)
  statement <- gsub('\\).*$', '', statement)
  statement <- gsub('if ', 'ifelse(', statement)
  if(grepl(paste0(object_name[1]), statement)){
    false_val <- paste0(object_name[1], '[i]')
  } else {
    false_val <- paste0(object_name[2], '[i]')
  }
  
  finMat <- matrix(nrow = length(placeholders) + 2, ncol = 1)
  finMat[1:length(placeholders)] <- placeholders
  finMat[length(placeholders) + 1] <- 
    paste0('mat <- matrix(ncol = length(', object_name[2], 
          '), nrow = nrow(x)); colnames(mat) <- ', object_name[2])
  finMat[length(placeholders) + 2] <- 
    paste0('for(i in seq_along(', object_name[1], ')) {',
           object_name[2], '[, i] <- ', statement, '), ', 
           true_val, ', ', false_val, ')}; x <- cbind(x, mat)')
  finMat
  
}
