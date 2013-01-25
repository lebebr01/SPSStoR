#' 
#' 
#' 
#' @param file path of text file with spss crosstab syntax
#' @export 

valuelabels_to_factor <- function(file){
  
  require(data.table)
  if(syntax == "plyr") require(plyr)
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
 
  
}  