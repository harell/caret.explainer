# Helpers -----------------------------------------------------------------
env_var_exists <- function(x) nchar(Sys.getenv(x))>0
option_exists <- function(x) !is.null(getOption(x))
load_app_config <- function() list2env(yaml::yaml.load_file(file.path(getOption("path_dashboard"), "config.yml"), eval.expr = TRUE), globalenv())
create_dir <- function(x){unlink(x, recursive = TRUE, force = TRUE); dir.create(x, FALSE, TRUE)}

# Defensive Programming ---------------------------------------------------
stopifnot(env_var_exists("SHINY_NAME"), env_var_exists("SHINY_TOKEN"), env_var_exists("SHINY_SECRET"))
stopifnot(option_exists("dashboard_source"), option_exists("dashboard_target"), option_exists("path_dashboard"))

# Setup -------------------------------------------------------------------
dashboard_source <- getOption("dashboard_source")
dashboard_target <- getOption("dashboard_target")
create_dir(dashboard_target)
fs::dir_copy(dashboard_source, dirname(dashboard_target))

pacakge_source <- "."
package_target <- file.path(dashboard_target, "package")
fs::dir_copy(pacakge_source, package_target)

# Prepare Shiny -----------------------------------------------------------
load_app_config()
rsconnect::setAccountInfo(
    name = Sys.getenv("SHINY_NAME"),
    token = Sys.getenv("SHINY_TOKEN"),
    secret = Sys.getenv("SHINY_SECRET")
)

# Deploy Shiny ------------------------------------------------------------
rsconnect::deployApp(
    appDir = getOption("path_dashboard"),
    appName = appName,
    appTitle = appTitle,
    forceUpdate = appForceUpdate
)
