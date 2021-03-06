# Helpers -----------------------------------------------------------------
env_var_exists <- function(x) nchar(Sys.getenv(x))>0
option_exists <- function(x) !is.null(getOption(x))

# Defensive Programming ---------------------------------------------------
try(source("../Renviron.R"))
stopifnot(env_var_exists("SHINY_NAME"), env_var_exists("SHINY_TOKEN"), env_var_exists("SHINY_SECRET"))

# Setup -------------------------------------------------------------------
pkgload::load_all(path = ".", helpers = FALSE, quiet = TRUE)
dashboard_source <- normalizePath(getOption("path_dashboard"))
dashboard_target <- normalizePath(file.path(tempdir(), "dashboard"))
Dashboard$utils$prepare_app_files(dashboard_source, dashboard_target)

# Configuration -----------------------------------------------------------
get_shiny <- purrr::partial(config::get, file = list.files(".", "config-shiny.yml$", recursive = TRUE, full.names = TRUE)[1])
shinydashboard <- get_shiny("shinydashboard")
rsconnect <- get_shiny("rsconnect")

# Prepare Shiny -----------------------------------------------------------
rsconnect::setAccountInfo(
    name = Sys.getenv("SHINY_NAME"),
    token = Sys.getenv("SHINY_TOKEN"),
    secret = Sys.getenv("SHINY_SECRET")
)

# App Information ---------------------------------------------------------
# shell.exec(dashboard_target)
# sort(rsconnect::appDependencies()$packages)

# Deploy Shiny ------------------------------------------------------------
options(shiny.autoload.r = TRUE)
rsconnect::deployApp(
    appDir = dashboard_target,
    appName = rsconnect$appName,
    appTitle = rsconnect$appTitle,
    account = Sys.getenv("SHINY_NAME"),
    forceUpdate = rsconnect$appForceUpdate
)
