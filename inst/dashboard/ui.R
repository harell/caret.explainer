shinyUI(dashboardPage(
    # Application title
    dashboardHeader(
    ), # end dashboardHeader

    # Sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem("Instance-level Analysis", tabName = "InstanceAnalysisTab", icon = icon("dashboard"), enable = shiny$tabs$InstanceAnalysis)
        )
    ), # end dashboardSidebar

    # Body
    dashboardBody(
        tabItems(
            tabItem(tabName = "InstanceAnalysisTab", InstanceAnalysisUI(id = "InstanceAnalysis"), enable = shiny$tabs$InstanceAnalysis)
        ) # end tabItems
    ) # end dashboardBody
) # end dashboardPage
)
