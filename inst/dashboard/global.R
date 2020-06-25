################################################################################
##                               Global Objects                               ##
################################################################################
#' Shiny startup procedure
#' global.R --> server.R
#'
#' Objects defined here are visible:
#' 1. across all sessions;
#' 2. to the code in the server object; and
#' 3. to the code in the ui object.
#'
#' Context Object
#' A context object encapsulates the references/pointers to services and
#' configuration information used/needed by other objects. It allows the objects
#' living within a context to see the outside world. Objects living in a
#' different context see a different view of the outside world.
context <- new.env()

# Setup -------------------------------------------------------------------
library(shiny)
library(shinydashboard)
base::readRenviron(path = "./package/.Renviron")
pkgload::load_all(path = "./package", helpers = FALSE, quiet = TRUE)
invisible(sapply(list.files("./R", ".R$|.r$", full.names = TRUE), source))

# Source Layers -----------------------------------------------------------
source("./global_app.R")
# source("./global_ui.R")

# Helper Functions --------------------------------------------------------
plotOutput <- function(...) shiny::plotOutput(..., height = "34vh")
box <- function(..., width = NULL, solidHeader = TRUE) suppressWarnings(shinydashboard::box(..., width = width, solidHeader = solidHeader))
tabItem <- function(tabName = NULL, ..., enable = TRUE) if(enable) shinydashboard::tabItem(tabName = tabName, ...) else shinydashboard::tabItem(tabName = tabName, NullModuleUI(id = tabName))
menuItem <- function(..., enable = TRUE) if(enable) shinydashboard::menuItem(...) else NULL
callModule <-  function(..., enable = TRUE) if(enable) shiny::callModule(...) else shiny::callModule(NullModuleServer, id = id)
dataTableOutput <- DT::dataTableOutput
renderDataTable <- DT::renderDataTable
datatable <- DT::datatable

# Configuration -----------------------------------------------------------
get_shiny <- purrr::partial(config::get, file = list.files(".", "config-shiny.yml$", recursive = TRUE, full.names = TRUE)[1])
shiny <- get_shiny("shiny")
shinydashboard <- get_shiny("shinydashboard")
rsconnect <- get_shiny("rsconnect")

# UI Elements -------------------------------------------------------------
## {shinydashboard}
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
