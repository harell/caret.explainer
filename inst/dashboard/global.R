# Objects defined here are:
# 1. visible across all sessions; and
# 2. visible to the code in both the server and ui objects.

# Setup -------------------------------------------------------------------
library(shiny)
library(shinydashboard)
library(remotes)
library(pkgload)
remotes::install_local(path = "./package", dependencies = "Imports", upgrade = "never", quiet = TRUE)
pkgload::load_all(path = "./package", helpers = FALSE, quiet = TRUE)

# Helper Functions --------------------------------------------------------
plotOutput <- function(...) shiny::plotOutput(..., height = "325px")
box <- function(..., width = NULL, solidHeader = TRUE) suppressWarnings(shinydashboard::box(..., width = width, solidHeader = solidHeader))
dataTableOutput <- DT::dataTableOutput
renderDataTable <- DT::renderDataTable
datatable <- DT::datatable

# Context Object ----------------------------------------------------------
context <- new.env()
## Load dashboard config file
context$config <- new.env()
Dashboard$utils$yaml2env(input = "config.yml", envir = context$config)
## Default values
context$values <- new.env()
context$values$role_input <- NULL
