# Helpers -----------------------------------------------------------------
env_var_exists <- function(x) nchar(Sys.getenv(x))>0
option_exists <- function(x) !is.null(getOption(x))

# Defensive Programming ---------------------------------------------------
try(source("../Renviron.R"))
stopifnot(env_var_exists("SHINY_NAME"), env_var_exists("SHINY_TOKEN"), env_var_exists("SHINY_SECRET"))

# Setup -------------------------------------------------------------------
pkgload::load_all(path = ".", helpers = FALSE, quiet = TRUE)
dashboard_source <- getOption("path_dashboard")
dashboard_target <- file.path(tempdir(), "dashboard")
package_source <- "."
package_target <- file.path(dashboard_target, "package")

Dashboard$create_dir(dashboard_target)
fs::dir_copy(dashboard_source, dirname(dashboard_target))
fs::dir_copy(package_source, package_target)
fs::dir_delete(file.path(package_target, "vignettes"))
fs::dir_delete(file.path(package_target, "inst", "dashboard"))
Dashboard$write_requirements(package_target, dashboard_target)

# Prepare Shiny -----------------------------------------------------------
Dashboard$load_shiny_configuration()
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
    appName = shiny$appName,
    appTitle = shiny$appTitle,
    account = Sys.getenv("SHINY_NAME"),
    forceUpdate = shiny$appForceUpdate
)
