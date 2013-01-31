#' Standard error for the mean
#' 
#' Computes standard error for the mean
#' 
#' @param x variable to compute standard error for the mean.
#' @export 
semean <- function(x){
   stdev <- sd(x)
   n <- length(x)
   semean <- stdev/n
  return(semean)
}