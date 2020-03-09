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
    dashboardHeader(title = context$config$appTitle),

    # Sidebar
    dashboardSidebar(
        # DT::dataTableOutput("unseen_observations"),
        # checkboxGroupInput(inputId = "what_if_vars", label = h3("What-if Scenarios"), width = "100%")
    ), # end dashboardSidebar

    # Body
    dashboardBody(
        column(width = 12,
               fluidRow(box(plotOutput("break_down"), title = "Break Down Plot")),
               fluidRow(box(plotOutput("ceteris_paribus"), title = "What-if Scenarios Analysis"))
        )# end column 12
    ) # end dashboardBody
))
