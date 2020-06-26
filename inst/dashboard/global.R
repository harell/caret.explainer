################################################################################
##                               Global Objects                               ##
################################################################################
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

# Configuration -----------------------------------------------------------
get_shiny <- purrr::partial(config::get, file = list.files(".", "config-shiny.yml$", recursive = TRUE, full.names = TRUE)[1])
shiny <- get_shiny("shiny")
shinydashboard <- get_shiny("shinydashboard")
rsconnect <- get_shiny("rsconnect")

# Source Layers -----------------------------------------------------------
source("./global_server.R")
source("./global_ui.R")
