DeployShiny <- R6::R6Class(
    "DeployShiny",
    inherit = TicStep,
    public = list(
        # Public Fields --------------------------------------------------------
        dashboard_source = "./inst/dashboard",
        dashboard_target = file.path(tempdir(), "dashboard"),
        # Public Methods -------------------------------------------------------
        env_var_exists = function(x) nchar(Sys.getenv(x)) > 0,
        load_app_config = function() list2env(yaml::yaml.load_file(file.path(getOption("path_dashboard"), "config.yml"), eval.expr = TRUE), globalenv()),
        create_dir = function(x){unlink(x, recursive = TRUE, force = TRUE); dir.create(x, FALSE, TRUE)},
        initialize = function() remotes::install_cran(c("rsconnect", "yaml", "fs"), quiet = TRUE),
        run = function(){
            load_app_config <- self$load_app_config
            env_var_exists <- self$env_var_exists
            create_dir <- self$create_dir

            # Defensive Programming
            stopifnot(env_var_exists("SHINY_NAME"), env_var_exists("SHINY_TOKEN"), env_var_exists("SHINY_SECRET"))

            # Setup
            dashboard_source <- self$dashboard_source
            dashboard_target <- self$dashboard_target
            create_dir(dashboard_target)
            fs::dir_copy(dashboard_source, dirname(dashboard_target))

            pacakge_source <- "."
            package_target <- file.path(dashboard_target, "package")
            fs::dir_copy(pacakge_source, package_target)

            # Prepare Shiny
            load_app_config()
            rsconnect::setAccountInfo(
                name = Sys.getenv("SHINY_NAME"),
                token = Sys.getenv("SHINY_TOKEN"),
                secret = Sys.getenv("SHINY_SECRET")
            )

            # Deploy Shiny
            rsconnect::deployApp(
                appDir = dashboard_target,
                appName = appName,
                appTitle = appTitle,
                forceUpdate = appForceUpdate
            )

        }
    )
)

step_deploy_shiny <- function() {
    DeployShiny$new()
}


