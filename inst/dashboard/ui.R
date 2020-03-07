#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel(context$config$appTitle),

    # Sidebar
    sidebarLayout(
        sidebarPanel(DT::dataTableOutput("unseen_observations")),

        mainPanel(
            plotOutput("break_down")
        )
    )
))
