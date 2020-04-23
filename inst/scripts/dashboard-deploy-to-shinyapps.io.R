# Helpers -----------------------------------------------------------------
env_var_exists <- function(x) nchar(Sys.getenv(x))>0
option_exists <- function(x) !is.null(getOption(x))
load_app_config <- function() list2env(yaml::yaml.load_file(file.path(getOption("path_dashboard"), "config-shiny.yml"), eval.expr = TRUE), globalenv())
create_dir <- function(x){unlink(x, recursive = TRUE, force = TRUE); dir.create(x, FALSE, TRUE)}
create_dir <- function(x){unlink(x, recursive = TRUE, force = TRUE); stopifnot(isFALSE(dir.exists(x))); dir.create(x, FALSE, TRUE)}
write_requirements <- function(package_path, dashboard_path){ dependencies <- desc::desc_get_deps(file.path(package_path, "DESCRIPTION")) %>% dplyr::filter(type == "Imports") %>% .$package;writeLines(paste0("library(", dependencies, ")"), file.path(dashboard_path, "requirements.R"))}

# Defensive Programming ---------------------------------------------------
stopifnot(env_var_exists("SHINY_NAME"), env_var_exists("SHINY_TOKEN"), env_var_exists("SHINY_SECRET"))

# Setup -------------------------------------------------------------------
pkgload::load_all(path = ".", helpers = FALSE, quiet = TRUE)
dashboard_source <- getOption("dashboard_source")
dashboard_target <- getOption("dashboard_target")
create_dir(dashboard_target)

fs::dir_copy(dashboard_source, dirname(dashboard_target))

package_source <- "."
package_target <- file.path(dashboard_target, "package")
fs::dir_copy(package_source, package_target)
fs::dir_delete(file.path(package_target, "vignettes"))

write_requirements(package_target, dashboard_target)

# Prepare Shiny -----------------------------------------------------------
load_app_config()
rsconnect::setAccountInfo(
    name = Sys.getenv("SHINY_NAME"),
    token = Sys.getenv("SHINY_TOKEN"),
    secret = Sys.getenv("SHINY_SECRET")
)

# Deploy Shiny ------------------------------------------------------------
options(shiny.autoload.r = TRUE)
rsconnect::deployApp(
    appDir = getOption("path_dashboard"),
    appName = appName,
    appTitle = appTitle,
    account = Sys.getenv("SHINY_NAME"),
    forceUpdate = appForceUpdate
)
