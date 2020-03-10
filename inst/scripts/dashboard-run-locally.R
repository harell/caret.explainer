# Helpers -----------------------------------------------------------------
env_var_exists <- function(x) nchar(Sys.getenv(x))>0
option_exists <- function(x) !is.null(getOption(x))
load_app_config <- function() list2env(yaml::yaml.load_file(file.path(getOption("path_dashboard"), "config.yml"), eval.expr = TRUE), globalenv())
create_dir <- function(x){unlink(x, recursive = TRUE, force = TRUE); stopifnot(isFALSE(dir.exists(x))); dir.create(x, FALSE, TRUE)}
write_requirements <- function(package_path, dashboard_path){ dependencies <- desc::desc_get_deps(file.path(package_path, "DESCRIPTION")) %>% dplyr::filter(type == "Imports") %>% .$package;writeLines(paste0("library(", dependencies, ")"), file.path(dashboard_path, "requirements.R"))}

# Defensive Programming ---------------------------------------------------
stopifnot(option_exists("dashboard_source"), option_exists("dashboard_target"), option_exists("path_dashboard"))

# Setup -------------------------------------------------------------------
dashboard_source <- getOption("dashboard_source")
dashboard_target <- getOption("dashboard_target")
create_dir(dashboard_target)
fs::dir_copy(dashboard_source, dirname(dashboard_target))

package_source <- "."
package_target <- file.path(dashboard_target, "package")
fs::dir_copy(package_source, package_target)

write_requirements(package_target, dashboard_target)

# Run Shiny ---------------------------------------------------------------
shiny::runApp(appDir = getOption("path_dashboard"))
