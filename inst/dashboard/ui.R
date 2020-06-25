shinyUI(dashboardPage(
    # Application title
    dashboardHeader(
        title = shinydashboard$dashboardHeader$title
    ), # end dashboardHeader

    # Sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem("Instance-level Analysis", tabName = "InstanceAnalysisTab", icon = icon("dashboard"), enable = shiny$tabs$InstanceAnalysis)
        ),
        disable = shinydashboard$dashboardSidebar$disable,
        width = shinydashboard$dashboardSidebar$width,
        collapsed = shinydashboard$dashboardSidebar$collapsed
    ), # end dashboardSidebar

    # Body
    dashboardBody(
        tabItems(
            tabItem(tabName = "InstanceAnalysisTab", InstanceAnalysisUI(id = "InstanceAnalysis"), enable = shiny$tabs$InstanceAnalysis)
        ) # end tabItems
    ) # end dashboardBody
) # end dashboardPage
)
