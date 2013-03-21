#' Graphics
#' 
#' Convert SPSS graph command to an R graph call using ggplot2.
#' 
#' @param x SPSS syntax - read in by SPSStoR function
#' @export 

graph_to_r <- function(x){
  
  library(stringr)  
  
  titleLoc <- grep("\\/title\\s?=", x, ignore.case = TRUE)
  if(length(titleLoc) > 0){
    titletxt <- substr(x[titleLoc], (which(strsplit(x[titleLoc], '')[[1]]=='=')+1), nchar(x[titleLoc]))
    titletxt <- gsub("\\.", "", titletxt)
    titleggplot <- paste("+ labs(title = ", titletxt, ")", sep = "")
  } else {titleggplot <- ""}
  
  typeLoc <- grep("\\/bar|\\/line|\\/hilo|\\/histogram|\\/scatterplot|\\/errorbar", x, ignore.case = TRUE)
  type <- tolower(substr(x[typeLoc], (which(strsplit(x[typeLoc], '')[[1]]=='/')+1), 
                 (which(strsplit(x[typeLoc], '')[[1]] %in% c('(', '='))[1]-1)))
  
  if(type == "hilo"){ type <- "pointrange"} 
  if(type == "scatterplot"){ type <- "point"}
  
  type <- paste("geom_", type, sep = '')
  
  if(grepl("\\(", x[typeLoc]) == TRUE){
    typesub <- tolower(substr(x[typeLoc], (which(strsplit(x[typeLoc], '')[[1]]=='(')+1), 
                           (which(strsplit(x[typeLoc], '')[[1]] ==')')-1)))
  } else { typesub <- ""}
  
  if(type == "geom_line" & typesub == "area"){ type <- "geom_area"}
  if(type == "geom_line" & typesub == "diff"){ type <- "geom_ribbon"}
  
  if(typesub %in% c("simple","grouped") & type == "geom_bar"){
    typeOpts <- "(position = 'dodge')"
  } else {
    typeOpts <- "()"
  }
    
  vars <- substr(x[typeLoc], (which(strsplit(x[typeLoc], '')[[1]]=='=')+1), nchar(x[typeLoc]))
  varsSplit <- unlist(strsplit(vars, 'BY|WITH'))
  varsSplit <- gsub("^\\s+|\\s+$", "", gsub("\\.$", "", varsSplit))
  varsSplit <- unlist(strsplit(varsSplit, ' '))
  varsSplit <- gsub(paste("(", "MAX|MIN|MEAN|SUM|VAR|MODE", ")", sep = ""), "\\L\\1", 
       varsSplit, perl = TRUE)
    
  varsSplit <- gsub("COUNT", "..count..", varsSplit, ignore.case = TRUE)
  
  if(length(varsSplit) == 1){
    texttopaste <- "x = "
  } else {
    if(length(varsSplit) == 2){
      texttopaste <- c("y = ", "x = ")
    } else {
      if(length(varsSplit) == 3 & type == "geom_bar") { texttopaste <- c("y = ", "x = ", "fill = ")}
      if(length(varsSplit) == 3 & type == "geom_line") {texttopaste <- c("y = ", "x = ", "color = ")}
      if(length(varsSplit) == 4 & type == "geom_pointrange") {texttopaste <- c("ymax = ", "ymin = ", "y = ", "x = ")}
      if(length(varsSplit) == 3 & type == "geom_ribbon") {texttopaste <- c("ymax = ", "ymin = ", "x = ")}      
    }
  }
  
  if(typesub == "matrix"){
    aestxt <- paste("c('", paste0(varsSplit, collapse = "', '"), "')", sep = "")
  } else {
    aestxt <- paste("aes(", paste0(sapply(1:length(varsSplit), function(x) 
      paste(texttopaste[x], varsSplit[x], sep = '')), collapse = ', '), ")", sep = "")
  }
    
  if(typesub == "normal"){
    normdist <- str_c("+ stat_function(geom='line', fun = dnorm, arg = list(mean = mean(",
                      varsSplit, "), sd = sd(", varsSplit, ")))")
    typeOpts <- "(aes(y = ..density..), stat = 'bin')"
  } else {normdist <- ""}

  if(typesub == "matrix"){
    finMat <- matrix(nrow = 3, ncol = 1)
    finMat[1] <- "library(ggplot2)"
    finMat[2] <- "library(GGally)"
    finMat[3] <- paste("ggpairs(x[, ", aestxt, "])", sep = "")
  } else {
    finMat <- matrix(nrow = 3, ncol = 1)
    finMat[1] <- "library(ggplot2)"
    finMat[2] <- paste("p <- ggplot(x, ", aestxt, ") + ", type, typeOpts, normdist, titleggplot, sep = '')
    finMat[3] <- "p"
  }
    
  finMat
  
}
