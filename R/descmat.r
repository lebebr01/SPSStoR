#' Descriptives Matrix function
#' 
#' Computes numerous descriptive statistics returning
#' a matrix
#' 
#' @param x A list of variables to compute descriptive statistics for.
#' @param ... Statistics to be cacluated.
#' @export 
descmat <- function(x,...){ 
  fun.names = sapply(lapply(substitute(list(...)), deparse)[-1], paste, collapse="") 
  mthd<-list(...) 
  if(!is.list(x)) x = list(x) 
  res = t(sapply(x, function(y) sapply(mthd, function(m) do.call(m, list(y)) ))) 
  colnames(res) = fun.names 
  rownames(res) = names(x) 
  res 
} 