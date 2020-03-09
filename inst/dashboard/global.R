# Objects defined here are:
# 1. visible across all sessions; and
# 2. visible to the code in both the server and ui objects.

# Setup -------------------------------------------------------------------
library(shiny)
library(shinydashboard)
library(pkgload)
pkgload::load_all(path = "./package", helpers = FALSE)

# Context Object ----------------------------------------------------------
context <- new.env()
## Load dashboard config file
context$config <- new.env()
Dashboard$utils$yaml2env(input = "config.yml", envir = context$config)
## Default values
context$values <- new.env()
context$values$role_input <- NULL
