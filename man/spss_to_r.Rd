\name{spss_to_r}
\alias{spss_to_r}
\title{Master SPSS to R function}
\usage{
  spss_to_r(file, writeRscript = FALSE, filePath = NULL)
}
\arguments{
  \item{file}{Path of text file that has SPSS syntax}

  \item{writeRscript}{TRUE or FALSE variable to write R
  script.  By default this is FALSE.}

  \item{filePath}{Path to save R script.  Default is NULL
  which saves to working directory as 'rScript.r'.}
}
\description{
  This function inputs SPSS syntax and returns comparable R
  syntax.
}
\details{
  The only required input for this function is a text file
  that contains SPSS syntax. The SPSS syntax can be the
  .sps syntax file that SPSS saves as or can be copied into
  another text file format.  The function readLines is used
  to read in the file line by line.

  A single column matrix is used to return the R code.  If
  a R command is long it does not wrap the code and so copy
  and pasting may be needed.  As an alternative, the R
  syntax can be saved to an R script file. No column names
  or row names are printed when saving this script file.
}
\examples{
\donttest{

}
}

