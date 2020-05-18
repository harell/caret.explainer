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

# App Information ---------------------------------------------------------
# shell.exec(dashboard_target)
# sort(rsconnect::appDependencies()$packages)

# Run Shiny ---------------------------------------------------------------
options(shiny.autoload.r = TRUE)
shiny::runApp(appDir = dashboard_target)
