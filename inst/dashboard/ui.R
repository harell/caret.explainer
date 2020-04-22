shinyUI(dashboardPage(
    # Application title
    dashboardHeader(
        title = stringr::str_glue("{appTitle}\n{appVersion}", appTitle = context$config$appTitle, appVersion = context$config$appVersion)
    ), # end dashboardHeader

    # Sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem("Instance-level Analysis", tabName = "InstanceAnalysisTab", icon = icon("dashboard"), enable = context$config$tabs$InstanceAnalysis)
        ),
        disable = context$shinydashboard$dashboardSidebar$disable,
        width = context$shinydashboard$dashboardSidebar$width,
        collapsed = context$shinydashboard$dashboardSidebar$collapsed
    ), # end dashboardSidebar

    # Body
    dashboardBody(
        tabItems(
            tabItem(tabName = "InstanceAnalysisTab", InstanceAnalysisUI(id = "InstanceAnalysis"), enable = context$config$tabs$InstanceAnalysis)
        ) # end tabItems
    ), # end dashboardBody

    # Aesthetics
    title = context$config$appTitle,
    skin = context$shinydashboard$dashboardPage$skin
) # end dashboardPage
)
