# Helper Functions --------------------------------------------------------
box <- function(..., width = NULL, solidHeader = TRUE) suppressWarnings(shinydashboard::box(..., width = width, solidHeader = solidHeader))
tabItem <- function(tabName = NULL, ..., enable = TRUE) if(enable) shinydashboard::tabItem(tabName = tabName, ...) else shinydashboard::tabItem(tabName = tabName, NullModuleUI(id = tabName))
menuItem <- function(..., enable = TRUE) if(enable) shinydashboard::menuItem(...) else NULL
plotOutput <- function(...) shiny::plotOutput(..., height = "34vh")
dataTableOutput <- DT::dataTableOutput

# shinydashboard ----------------------------------------------------------
shinydashboard$dashboardHeader$title <- stringr::str_glue("{appTitle}\n{appVersion}", appTitle = rsconnect$appTitle, appVersion = rsconnect$appVersion)

shinydashboard$dashboardPage$title <- rsconnect$appTitle

dashboardPage <- purrr::partial(
    shinydashboard::dashboardPage,
    title = shinydashboard$dashboardPage$title,
    skin = shinydashboard$dashboardPage$skin
)

dashboardHeader <- purrr::partial(
    shinydashboard::dashboardHeader,
    title = shinydashboard$dashboardHeader$title
)

dashboardSidebar <- purrr::partial(
    shinydashboard::dashboardSidebar,
    disable = shinydashboard$dashboardSidebar$disable,
    width = shinydashboard$dashboardSidebar$width,
    collapsed = shinydashboard$dashboardSidebar$collapsed
)
