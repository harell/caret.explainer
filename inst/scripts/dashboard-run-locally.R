# Helpers -----------------------------------------------------------------
env_var_exists <- function(x) nchar(Sys.getenv(x))>0
option_exists <- function(x) !is.null(getOption(x))
load_app_config <- function() list2env(yaml::yaml.load_file(file.path(getOption("path_dashboard"), "config.yml"), eval.expr = TRUE), globalenv())
create_dir <- function(x){unlink(x, recursive = TRUE, force = TRUE); dir.create(x, FALSE, TRUE)}

# Defensive Programming ---------------------------------------------------
stopifnot(option_exists("dashboard_source"), option_exists("dashboard_target"), option_exists("path_dashboard"))

# Setup -------------------------------------------------------------------
dashboard_source <- getOption("dashboard_source")
dashboard_target <- getOption("dashboard_target")
create_dir(dashboard_target)
fs::dir_copy(dashboard_source, dirname(dashboard_target))

pacakge_source <- "."
package_target <- file.path(dashboard_target, "package")
fs::dir_copy(pacakge_source, package_target)

# Run Shiny ---------------------------------------------------------------
shiny::runApp(appDir = getOption("path_dashboard"))
