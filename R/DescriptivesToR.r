#' 
#' 
#' 
#' @param file path of text file with spss crosstab syntax
#' @export 

descriptives_to_des <- function(file){
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
  
}


msum = function(x,...){ 
  fun.names = sapply(lapply(substitute(list(...)), deparse)[-1], paste, collapse="") 
  mthd<-list(...) 
  if(!is.list(x)) x = list(x) 
  res = t(sapply(x, function(y) sapply(mthd, function(m) do.call(m, list(y)) ))) 
  colnames(res) = fun.names 
  rownames(res) = names(x) 
  res 
} 