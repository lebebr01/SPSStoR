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
    if(grepl(' to ', vars, ignore.case = TRUE)) {
      if(grepl(',', vars, ignore.case = TRUE)) {
        vars <- unlist(strsplit(vars, split = ','))
        vars <- gsub("^\\s+|\\s+$", "", vars)
        vars <- gsub(")", '', vars)
      }
      vars <- strsplit(vars, split = ' to ')
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
      vars <- paste(vars, collapse = ",")
    }
    expr <- paste(func, vars, sep = '(')
    expr <- paste(expr, ')', sep = '')
  }
  
  if(grepl('min|max|mean|sum', expr, ignore.case = TRUE)) {
    expr <- gsub(')$', ', na.rm = TRUE)', expr)
  }
  
  finMat <- matrix(nrow = 1, ncol = 1)
  finMat[1] <- paste0('x$', varname, ' <- with(x, ', expr, ')')
  
  finMat  
}

#' If to R
#' 
#' Converts SPSS if statements to R if statements.
#' 
#' This function returns R syntax that mimics what is accomplished
#'   with the same analysis in SPSS.
#'   
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @importFrom stringr str_extract
#' @export
if_to_r <- function(x, dplyr = TRUE) {
  
  x <- gsub("if\\s*", "", x, ignore.case = TRUE)
  x <- gsub("\\.$", "", x)
  
  vars <- str_extract(x, "\\).+")
  vars <- gsub("^\\)\\s*", "", vars)
  uniq_vars <- gsub("\\s*", "", 
                    unique(gsub("=", "", str_extract(vars, ".+="))))
  n_uniq_vars <- length(uniq_vars)
  uniq_vars_loc <- lapply(1:n_uniq_vars, function(xx) 
    grep(uniq_vars[xx], vars))
  values <- gsub("=\\s*", "", str_extract(vars, "=.+"))
  
  conditions <- str_extract(x, ".+\\)")
  conditions <- gsub("and", "&", conditions, ignore.case = TRUE)
  conditions <- gsub("or", "|", conditions, ignore.case = TRUE)
  conditions <- gsub("ne|~=|<>", "!=", conditions, ignore.case = TRUE)
  conditions <- gsub("eq|=", "==", conditions, ignore.case = TRUE)
  conditions <- gsub("lt", "<", conditions, ignore.case = TRUE)
  conditions <- gsub("gt", ">", conditions, ignore.case = TRUE)
  conditions <- gsub("le|<=+", "<=", conditions, ignore.case = TRUE)
  conditions <- gsub("ge|>=+", ">=", conditions, ignore.case = TRUE)
  
  tmp <- vector("list", length(uniq_vars_loc))
  for(i in 1:length(uniq_vars_loc)) {
     if(length(uniq_vars_loc[[i]]) - 1 == 1) {
        tmp[[i]] <- paste0('ifelse(', conditions[1], ', ',  values[1], ', ', 
               values[2], ')')
      } else {
        tmp[[i]] <- vector('character', (length(uniq_vars_loc[[i]]) - 1))
       for(k in 1:(length(uniq_vars_loc[[i]]) - 1)) {
         if(k == (length(uniq_vars_loc[[i]]) - 1)) {
           tmp[[i]][k] <- paste0('ifelse(', conditions[k], ', ',  values[k], ', ', 
                  values[k + 1], 
                  paste(rep(')', (length(uniq_vars_loc[[i]]) - 1)), collapse = ""))
         } else {
           tmp[[i]][k] <- paste0('ifelse(', conditions[k], ', ', 
                                 values[k], ', ')
         }
       }
      }
  }
  cond <- do.call("paste", c(tmp, collapse = ""))
  
  finmat <- sapply(1:length(uniq_vars), function(xx) 
    paste0('x$', uniq_vars[xx], ' <- ', cond[xx]))
  finmat
}
