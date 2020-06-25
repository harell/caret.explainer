################################################################################
##                               Global Objects                               ##
################################################################################
#' Objects defined here are visible:
#' 1. across all sessions;
#' 2. to the code in the server object; and
#' 3. to the code in the ui object.

# Setup -------------------------------------------------------------------
library(shiny)
library(shinydashboard)
base::readRenviron(path = "./package/.Renviron")
pkgload::load_all(path = "./package", helpers = FALSE, quiet = TRUE)
invisible(sapply(list.files("./R", ".R$|.r$", full.names = TRUE), source))
Dashboard$utils$load_shiny_configuration(envir = environment())
database <- DBMS$new(path = tempfile("archive-"))$establish_connection()

# Helper Functions --------------------------------------------------------
get_shiny <- purrr::partial(config::get, file = list.files(".", "config-shiny.yml$", recursive = TRUE, full.names = TRUE)[1])
plotOutput <- function(...) shiny::plotOutput(..., height = "34vh")
box <- function(..., width = NULL, solidHeader = TRUE) suppressWarnings(shinydashboard::box(..., width = width, solidHeader = solidHeader))
tabItem <- function(tabName = NULL, ..., enable = TRUE) if(enable) shinydashboard::tabItem(tabName = tabName, ...) else shinydashboard::tabItem(tabName = tabName, NullModuleUI(id = tabName))
menuItem <- function(..., enable = TRUE) if(enable) shinydashboard::menuItem(...) else NULL
callModule <-  function(..., enable = TRUE) if(enable) shiny::callModule(...) else shiny::callModule(NullModuleServer, id = id)
dataTableOutput <- DT::dataTableOutput
renderDataTable <- DT::renderDataTable
datatable <- DT::datatable

# Context Object ----------------------------------------------------------
context <- new.env()
context$role <- new.env()
context$role$input <- NULL
context$role$target <- NULL

# UI Elements -------------------------------------------------------------
## {shinydashboard}
shinydashboard <- get_shiny("shinydashboard")
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

# Generate caret model ----------------------------------------------------
tags <- "mock:yes"
if(length(database$read(tags)) == 0)
    database$create(artifact = CaretModelFactory$new()$artifact, tags)
