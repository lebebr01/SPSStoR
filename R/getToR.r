#' Get to R
#' 
#' Converts SPSS get syntax to R syntax
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
get_to_r <- function(x, dplyr = TRUE){
  
  fileLoc <- grep("file\\s?=", x, ignore.case = TRUE)
  if(any(grepl('\"', x)) == TRUE){
    path <- substr(x[fileLoc], (which(strsplit(x[fileLoc], '')[[1]]=='\"')[1]), 
                   (which(strsplit(x[fileLoc], '')[[1]]=='\"')[2]))
  } else {
    path <- substr(x[fileLoc], (which(strsplit(x[fileLoc], '')[[1]]=='\'')[1]), 
                   (which(strsplit(x[fileLoc], '')[[1]]=='\'')[2]))
  }
  
  rx <- paste0("x <- read_sav(", path, ")")
  finMat <- paste("library(haven)", rx, sep = "\n")
finMat
}


#' Get Data to R
#' 
#' Converst SPSS Get Data command to R syntax.  Available for delimited or 
#' excel data files.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export
getdata_to_r <- function(x) {
  
  fileLoc <- grep("file\\s?=", x, ignore.case = TRUE)
  if(any(grepl('\"', x)) == TRUE){
    path <- substr(x[fileLoc], (which(strsplit(x[fileLoc], '')[[1]]=='\"')[1]), 
                   (which(strsplit(x[fileLoc], '')[[1]]=='\"')[2]))
  } else {
    path <- substr(x[fileLoc], (which(strsplit(x[fileLoc], '')[[1]]=='\'')[1]), 
                   (which(strsplit(x[fileLoc], '')[[1]]=='\'')[2]))
  }
  
  typeLoc <- grep("type\\s?=", x, ignore.case = TRUE)
  typeVal <- substr(x[typeLoc], (which(strsplit(x[typeLoc], '')[[1]]=='=')+1), 
                    nchar(x[typeLoc]))
  if(grepl("TXT|txt", typeVal) == TRUE){
    firstcase <- grep("firstcase\\s?=", x, ignore.case = TRUE)
    num <- as.numeric(substr(x[firstcase], (which(strsplit(x[firstcase], '')[[1]]=='=')+1), 
                             nchar(x[firstcase])))
    header <- paste0("skip = ", num)
    
    
    delimLoc <- grep("delimiters\\s?=", x, ignore.case = TRUE)
    if(any(grepl('\"', x[delimLoc])) == TRUE){
      delim <- substr(x[delimLoc], (which(strsplit(x[delimLoc], '')[[1]]=='\"')[1]), 
                      (which(strsplit(x[delimLoc], '')[[1]]=='\"')[2]))
    } else {
      delim <- substr(x[delimLoc], (which(strsplit(x[delimLoc], '')[[1]]=='\'')[1]), 
                      (which(strsplit(x[delimLoc], '')[[1]]=='\'')[2]))
    }
    
    finMat <- paste0("x <- read.table(", path, ", sep = ", delim, ", ", header, ")")
    finMat
  } else {
    if(grepl("XLS|xls|XLSX|xlsx", typeVal) == TRUE) {
      
      sheetLoc <- grep("sheet\\s?=", x, ignore.case = TRUE)
      if(grepl("name", x[sheetLoc], ignore.case = TRUE) == TRUE){
        if(any(grepl('\"', x[sheetLoc])) == TRUE){
          sheetT <- substr(x[sheetLoc], (which(strsplit(x[sheetLoc], '')[[1]]=='\"')[1]), 
                          (which(strsplit(x[sheetLoc], '')[[1]]=='\"')[2]))
          sheetN <- NULL
        } else {
          sheetT <- substr(x[sheetLoc], (which(strsplit(x[sheetLoc], '')[[1]]=='\'')[1]), 
                          (which(strsplit(x[sheetLoc], '')[[1]]=='\'')[2]))
          sheetN <- NULL
        }
      } else {
        sheetN <- gsub('[^0-9]', '', x[sheetLoc])
        sheetT <- NULL
      }
      rx <- paste0("x <- read.xlsx(", path, ", ", sheetT, sheetN, ")")
      
      finMat <- paste("library(xlsx)", rx, sep = "\n")
      finMat
      
    } else {
      message("Data for type ODBC or OLEDB are not supported")
    }
  }

  
}

