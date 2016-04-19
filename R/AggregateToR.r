#' Aggregate to R
#' 
#' Converts SPSS aggregate syntax to aggregate in R.
#' 
#' This function returns a matrix that highlights R syntax that mimics
#' the analysis done in SPSS.  The R syntax used by default is from the 
#' data.table package as this allows the ability to easily save aggregated 
#' variables back into the original R data frame.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @param dplyr A value of TRUE uses dplyr syntax (default), 
#'              a value of FALSE uses data.table syntax
#' @export
aggregate_to_r <- function(x, dplyr = TRUE){
  
  if(length(grep("\\/break\\s?=", x, ignore.case = TRUE)) < 1){
    aggVarsOrd <- NULL 
    aggVarsBy <- NULL
  } else {
    varsLoc <- grep("\\/break\\s?=", x, ignore.case = TRUE)
    vars <- substr(x[varsLoc], (which(strsplit(x[varsLoc], '')[[1]]=='=')+1), nchar(x[varsLoc]))
    aggVars <- paste(unlist(strsplit(gsub("^\\s+|\\s+$", "", vars), " ")), collapse = ", ")
    if(dplyr) {
      aggVarsBy <- paste0('group_by(', aggVars, ')')
    } else {
      aggVarsOrd <- paste("order(", aggVars, ")", sep = "")
      aggVarsBy <- paste("by = list(", aggVars, ")", sep = "")
    }
  }  
  
  if(length(grep("\\/?outfile\\s?=", x, ignore.case = TRUE)) < 1 | 
       length(grep("addvariables", x, ignore.case = TRUE)) == 1){
    object <- NULL
  } else {
    objectLoc <- grep("\\/?outfile\\s?=", x, ignore.case = TRUE)
    object <- unlist(strsplit(substr(x[objectLoc], (which(strsplit(x[objectLoc], '')[[1]]=='=')+1), 
                                     nchar(x[objectLoc])), "/"))
    object <- gsub('.sav', '.rda', object[length(object)])
    # object <- gsub(".sav", "", object[length(object)])
    # object <- gsub("^\'|\'$", "", object)
    # object <- paste(object, " <- ", sep = "")
  }  
    
  calcLoc <- grep("aggregate|outfile|document|presorted|break|missing", 
                  x, ignore.case = TRUE, invert = TRUE)
    
  funct <- matrix(ncol = 1, nrow = length(calcLoc))
  for(i in 1:length(calcLoc)){
    funct[i] <- tolower(gsub("/", "", x[calcLoc[i]]))
  }
  if(is.null(object)) {
    funct <- gsub("\\.", "", funct)
    if(dplyr) {
      funct <- paste(funct, collapse = ", ")
      funct <- paste0('mutate(', funct, ')')
    } else {
      funct <- gsub("=", ":=", funct)
    }
  } else {
    funct <- gsub("\\.", "", paste(funct, collapse = ", "))
    if(dplyr) {
      if(grepl(" to ", funct, ignore.case = TRUE)) {
        vars <- unlist(strsplit(funct, split = ' to |\\s?='))
        digits <- sapply(1:2, function(xx) 
          gsub('[a-zA-Z][[:punct:]]*', '', vars[xx]))
        alpha <- sapply(1:2, function(xx)
          gsub('[0-9]', '', vars[[xx]])[1])
        num_digits <- sapply(1, function(xx) 
          paste0('%0', nchar(digits[[xx]][1]), 'd'))
        sequence <- lapply(1, function(xx)
          sprintf(num_digits[[xx]], digits[[1]]:digits[[2]]))
        var_names <- unlist(lapply(1, function(xx)
          paste0(alpha[xx], sequence[[xx]])))
        # vars <- paste(vars, collapse = ",")
        funct_name <- unlist(strsplit(funct, split = '\\s?=\\s?'))[2]
        nums <- eval(parse(text = paste0(digits[1], ':', digits[2])))
        funct_name <- gsub('\\)', '', funct_name)
        #funct_name <- paste0(funct_name, '[', nums, '])')
        
        functs <- unlist(strsplit(funct_name, split = "\\("))
        
        #funct <- paste(paste0(var_names, ' = ', funct_name), collapse = ',')
      }  
      
      funct <- paste0('summarize_each(funs(', functs[1], 
                      '(., na.rm = TRUE)), one_of(', functs[2], '))')
      
    } else {
      funct <- paste0("list(", funct, ")")
    }
  }  
  
  if(dplyr){
    if(is.null(object)){
      values <- c('x', aggVarsBy, funct)
      finMat <- matrix(nrow = length(funct) + 1, ncol = 1)
      finMat[1] <- 'library(dplyr)'
      finMat[2] <- paste(values, collapse = ' %>% ')
    } else {
      values <- c('tmp <- x', aggVarsBy, funct)
      finMat <- matrix(nrow = length(funct) + 3, ncol = 1)
      finMat[1] <- 'library(dplyr)'
      finMat[2] <- paste(values, collapse = ' %>% ') 
      finMat[3] <- paste0('names(tmp)[(ncol(tmp)-', length(var_names), '+1):ncol(tmp)] <- ',
                          'c("', paste(var_names, collapse = '","'), '")')
      finMat[4] <- paste0('save(tmp, file = ', object, 
                          ')')
    }
  } else {
    finMat <- matrix(nrow = length(funct) + 2, ncol = 1)
    finMat[1] <- 'library(data.table)'
    finMat[2] <- 'x <- data.table(x)'
    for(i in 1:length(funct)){
      finMat[i+2] <- paste(object, "x[", aggVarsOrd, ", ", funct[i], ", ", aggVarsBy, "]", sep = "")
    }
  }
   

 finMat
}
