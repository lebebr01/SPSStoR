#' Descriptives Matrix function
#' 
#' Computes numerous descriptive statistics returning a matrix
#' 
#' This function takes a list of methods (e.g. mean, variance) and 
#' computes these for the list of x variables.  The computed statistics
#' are found along the columns and the different variables are found along
#' the rows.
#' 
#' @param x A list of variables to compute descriptive statistics for.
#' @param ... Statistics to be cacluated.
#' @export 
#' @examples 
#' \donttest{
#' ## Example with college football data
#' data(cfbMinn)
#' }
descmat <- function(x, ...){ 
  fun.names = sapply(lapply(substitute(list(...)), deparse)[-1], paste, collapse="") 
  mthd<-list(...) 
  if(!is.list(x)) x = list(x) 
  res = t(sapply(x, function(y) sapply(mthd, function(m) do.call(m, list(y)) ))) 
  colnames(res) = fun.names 
  rownames(res) = names(x) 
  res 
} 
