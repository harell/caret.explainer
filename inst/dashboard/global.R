# Objects defined here are:
# 1. visible across all sessions; and
# 2. visible to the code in both the server and ui objects.

# Setup -------------------------------------------------------------------
library(shiny)
library(shinydashboard)
base::readRenviron(path = "./package/.Renviron")
pkgload::load_all(path = "./package", helpers = FALSE, quiet = TRUE)
invisible(sapply(list.files("./R", ".R$|.r$", full.names = TRUE), source))
database <- DBMS$new()$establish_connection()

# Helper Functions --------------------------------------------------------
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

## Load dashboard config file
Dashboard$utils$load_shiny_configuration(envir = context)

## Default values
context$values <- new.env()
context$values$role_input <- NULL
context$values$role_target <- NULL

# Generate caret model ----------------------------------------------------
database$create(MockDatabase$funs$load_caret())

