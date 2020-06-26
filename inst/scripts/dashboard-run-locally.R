# Setup -------------------------------------------------------------------
pkgload::load_all(path = ".", helpers = FALSE, quiet = TRUE)
dashboard_source <- getOption("path_dashboard")
dashboard_target <- normalizePath(file.path(tempdir(), "dashboard"))
Dashboard$utils$prepare_app_files(dashboard_source, dashboard_target)

# App Information ---------------------------------------------------------
# shell.exec(dashboard_target)
# sort(rsconnect::appDependencies()$packages)

# Run Shiny ---------------------------------------------------------------
withr::local_options(
    list(shiny.autoload.r = TRUE, shiny.reactlog = TRUE),
    shiny::runApp(appDir = dashboard_target)
)
