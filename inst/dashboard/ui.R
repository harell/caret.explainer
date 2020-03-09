#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
shinyUI(dashboardPage(

    # Application title
    dashboardHeader(title = context$config$appTitle), # end dashboardHeader

    # Sidebar
    dashboardSidebar(), # end dashboardSidebar

    # Body
    dashboardBody(
        fluidRow(
            column(width = 4,
                   box(dataTableOutput("unseen_observations"), title = "Observations")
            ), # end column 4

            column(width = 2,
                   box(checkboxGroupInput(inputId = "what_if_vars", label = ""), title = "Variables")
            ),# end column 2

            column(width = 6,
                   box(plotOutput("break_down"), title = "Break Down Plot", height = "20%"),
                   box(plotOutput("ceteris_paribus"), title = "What-if Scenarios Analysis")
            )# end column 6
        ) # end dashboardBody
    )# end fluidRow
))
