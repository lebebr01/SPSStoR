#' 
#' 
#' 
#' @param file path of text file with spss crosstab syntax
#' @export 

valuelabels_to_r <- function(file){
  
  #require(data.table)
  #if(syntax == "plyr") require(plyr)
  
  x <- readLines(file)
  x <- gsub("^\\s+|\\s+$", "", x)
 
  
}  