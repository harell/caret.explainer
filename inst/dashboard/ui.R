shinyUI(dashboardPage(
    # Application title
    dashboardHeader(
        title = context$shinydashboard$dashboardHeader$title
    ), # end dashboardHeader

    # Sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem("Instance-level Analysis", tabName = "InstanceAnalysisTab", icon = icon("dashboard"), enable = context$shiny$tabs$InstanceAnalysis)
        ),
        disable = context$shinydashboard$dashboardSidebar$disable,
        width = context$shinydashboard$dashboardSidebar$width,
        collapsed = context$shinydashboard$dashboardSidebar$collapsed
    ), # end dashboardSidebar

    # Body
    dashboardBody(
        tabItems(
            tabItem(tabName = "InstanceAnalysisTab", InstanceAnalysisUI(id = "InstanceAnalysis"), enable = context$shiny$tabs$InstanceAnalysis)
        ) # end tabItems
    ), # end dashboardBody

    # Aesthetics
    title = context$shiny$appTitle,
    skin = context$shinydashboard$dashboardPage$skin
) # end dashboardPage
)
