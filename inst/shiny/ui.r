library(shinydashboard)
library(DT)

ui <- dashboardPage(skin = "green",
        dashboardHeader(title = "pdfsearch Demo"),
        dashboardSidebar(
          sidebarMenu(
            menuItem('Input SPSS', tabName = 'input', 
                      icon = icon('info-circle'))
            # menuItem('Results', tabName = 'results',
            #           icon = icon('table'))
          )
        ),
        dashboardBody(
           tabItems(
             tabItem(tabName = 'input',
              fluidRow(
                box(title = 'Upload SPSS file',
                    status = 'primary',
                    width = 4,
                    fileInput('path', 'Choose SPSS file',
                              multiple = FALSE,
                              accept = c('.sps', '.txt'))
                )
              ),
              fluidRow(
                box(title = 'SPSS Code',
                    status = 'info',
                    width = 6,
                    verbatimTextOutput('spss_text')
                ),
                box(title = 'R Code',
                    status = 'primary',
                    width = 6,
                    verbatimTextOutput('r_code')
                )
              ) 
               
             )
           )        
        )
)
