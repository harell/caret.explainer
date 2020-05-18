DeployShiny <- R6::R6Class(
    "DeployShiny",
    inherit = TicStep,
    public = list(
        # Public Methods -------------------------------------------------------
        initialize = function() remotes::install_cran(c("rsconnect", "yaml", "fs", "pkgload"), quiet = TRUE),
        run = function(){
            pkgload::load_all(path = ".", helpers = FALSE, quiet = TRUE)

            # Defensive Programming
            env_var_exists <- function(x) nchar(Sys.getenv(x)) > 0
            option_exists <- function(x) !is.null(getOption(x))
            stopifnot(env_var_exists("SHINY_NAME"), env_var_exists("SHINY_TOKEN"), env_var_exists("SHINY_SECRET"))
            stopifnot(option_exists("path_dashboard"))

            # Setup
            dashboard_source <- getOption("path_dashboard")
            dashboard_target <- file.path(tempdir(), "dashboard")
            DeployShiny$funs$prepare_app_files(dashboard_source, dashboard_target)

            # Prepare Shiny
            rsconnect::setAccountInfo(
                name = Sys.getenv("SHINY_NAME"),
                token = Sys.getenv("SHINY_TOKEN"),
                secret = Sys.getenv("SHINY_SECRET")
            )

            # Deploy Shiny
            DeployShiny$funs$load_shiny_configuration(envir = environment())
            stopifnot(exists("rsconnect"))
            options(shiny.autoload.r = TRUE)
            rsconnect::deployApp(
                appDir = dashboard_target,
                appName = rsconnect$appName,
                appTitle = rsconnect$appTitle,
                account = Sys.getenv("SHINY_NAME"),
                forceUpdate = rsconnect$appForceUpdate
            )
        }
    )
)# end DeployShiny

step_deploy_shiny <- function() {
    DeployShiny$new()
}

# Helpers -----------------------------------------------------------------
DeployShiny$funs <- new.env()

DeployShiny$funs$load_shiny_configuration <- function(envir = .GlobalEnv){
    config = Sys.getenv("R_CONFIG_ACTIVE", "default")
    file = list.files(".", "config-shiny.yml$", recursive = TRUE, full.names = TRUE)[1]
    list2env(config::get(NULL, config, file), envir = envir)
    invisible()
}

DeployShiny$funs$prepare_app_files <-  function(dashboard_source, dashboard_target){
    package_source <- "."
    package_target <- file.path(dashboard_target, "package")

    DeployShiny$funs$create_dir(dashboard_target)
    fs::dir_copy(dashboard_source, dirname(dashboard_target))
    fs::dir_copy(package_source, package_target)
    fs::dir_delete(file.path(package_target, "vignettes"))
    fs::dir_delete(file.path(package_target, "inst", "dashboard"))
    DeployShiny$funs$write_requirements(package_target, dashboard_target)

    invisible()
}

DeployShiny$funs$write_requirements <- function(package_path, dashboard_path){
    dependencies <-
        desc::desc_get_deps(file.path(package_path, "DESCRIPTION")) %>%
        dplyr::filter(type == "Imports") %>%
        .$package
    writeLines(paste0("library(", dependencies, ")"), file.path(dashboard_path, "requirements.R"))
    invisible()
}

DeployShiny$funs$create_dir <- function(x){
    base::unlink(x, recursive = TRUE, force = TRUE)
    base::dir.create(x, FALSE, TRUE)
    invisible()
}
