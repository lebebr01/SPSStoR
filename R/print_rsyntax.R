#' Prints a rsyntax object
#' 
#' Prints a rsyntax object.
#' 
#' @param x The rsyntax object.
#' @param \ldots ignored
#' @method print rsyntax
#' @export print rsyntax
print.rsyntax <- function(x, ...){
  cat(paste(x, collapse = "\n"), "\n")
}
