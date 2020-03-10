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
        InstanceAnalysisUI(id = "InstanceAnalysis")
    )# end fluidRow
))
