library(shiny)
library(shinydashboard)
library(SPSStoR)

server <- function(input, output, session) {
  
  output$spss_text <- renderText({
    readLines(input$path[['datapath']])
  })
  
  output$r_code <- renderText({
    spss_to_r(input$path[['datapath']])
  })
  
}
