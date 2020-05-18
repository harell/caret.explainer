# Helpers -----------------------------------------------------------------
env_var_exists <- function(x) nchar(Sys.getenv(x))>0
option_exists <- function(x) !is.null(getOption(x))
create_dir <- function(x){unlink(x, recursive = TRUE, force = TRUE); dir.create(x, FALSE, TRUE)}
write_requirements <- function(package_path, dashboard_path){ dependencies <- desc::desc_get_deps(file.path(package_path, "DESCRIPTION")) %>% dplyr::filter(type == "Imports") %>% .$package;writeLines(paste0("library(", dependencies, ")"), file.path(dashboard_path, "requirements.R"))}

# Setup -------------------------------------------------------------------
pkgload::load_all(path = ".", helpers = FALSE, quiet = TRUE)
dashboard_source <- getOption("path_dashboard")
dashboard_target <- file.path(tempdir(), "dashboard")
package_source <- "."
package_target <- file.path(dashboard_target, "package")

create_dir(dashboard_target)
fs::dir_copy(dashboard_source, dirname(dashboard_target))
fs::dir_copy(package_source, package_target)
fs::dir_delete(file.path(package_target, "vignettes"))
fs::dir_delete(file.path(package_target, "inst", "dashboard"))
write_requirements(package_target, dashboard_target)

# App Information ---------------------------------------------------------
# shell.exec(dashboard_target)
# sort(rsconnect::appDependencies()$packages)

# Run Shiny ---------------------------------------------------------------
options(shiny.autoload.r = TRUE)
shiny::runApp(appDir = dashboard_target)
