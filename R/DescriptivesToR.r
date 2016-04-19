#' Descriptives to R
#' 
#' Converts SPSS descriptives syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @param ... Additional arguments passed to function, not currently supported.
#' @export
descriptives_to_r <- function(x, dplyr = TRUE, ...) {
  
  varsLoc <- grep("variables\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
  if(length(x) != length(grep('\\/', x)) + length(varsLoc)) {
    vars2 <- x[-c(varsLoc, grep('\\/', x))]
    vars <- c(vars, vars2)
  }
  descVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ', ')
  
  statLoc <- grep("statistics\\s?=|stats\\s?=", x, ignore.case = TRUE)
  vars <- substr(x[statLoc], (which(strsplit(x[statLoc], '')[[1]]=='=')+1), nchar(x[statLoc]))
  vars <- gsub("^\\s+|\\s+$", "", gsub("\\.", "", vars))
  stats <- unlist(strsplit(vars, " "))
  stats <- tolower(stats)
  stats <- gsub("stddev", "sd", stats)
  stats <- gsub("variance", "var", stats)
  stats <- gsub("minimum", "min", stats)
  stats <- gsub("maximum", "max", stats)
  if(grepl("all", stats[1]) == TRUE){
    stats <- c("mean", "semean", "sd", "var", "kurtosis", "skewness", "range", "min", "max",
                   "sum")
  } 
  if(grepl("default", stats[1]) == TRUE){
    stats <- c("mean", "sd", "min", "max")
  }
  
  stats <- sapply(seq_along(stats), 
                  function(p) paste0(stats[p], '(., na.rm = TRUE)'))
  stats <- paste(stats, collapse = ", ")
  
  if(any(grepl('save', x, ignore.case = TRUE))) {
    comp_vars <- unlist(strsplit(descVars, ', '))
    scale_names <- paste0('x$Z', comp_vars, ' <- ')
    
    funcs <- paste0('with(x, scale(as.numeric(as.character(', comp_vars, '))))')
    scale_command <- paste0(scale_names, funcs)
  }
  
  descVars <- paste(unlist(strsplit(descVars, ', ')), collapse = '", "')
    
  if(grepl("skewness|kurtosis", stats) == TRUE){
    finMat <- matrix(ncol = 1, nrow = 3)
    #finMat[1] <- 'library(SPSStoR)'
    finMat[1] <- 'library(e1071)'
    finMat[2] <- paste0('convert_num <- function(x) as.numeric(as.character(x));',
                        'x[c("', descVars, '")] <- sapply(x[c("', descVars, '")], convert_num)')
    finMat[3] <- paste0('x %>% summarise_each(funs(', stats, '), one_of("', descVars, '"))')
  } else {
    finMat <- matrix(ncol = 1, nrow = 2)
    #finMat[1] <- 'library(SPSStoR)'
    finMat[1] <- paste0('convert_num <- function(x) as.numeric(as.character(x));',
                        'x[c("', descVars, '")] <- sapply(x[c("', descVars, '")], convert_num)')
    finMat[2] <- paste0('x %>% summarise_each(funs(', stats, '), one_of("', descVars, '"))')
  }
  
  if(any(grepl('save', x, ignore.case = TRUE))) {
    finMat <- c(finMat, scale_command)
  }
  
 finMat
}
