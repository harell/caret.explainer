# Dashboard Class ---------------------------------------------------------
#' @title One Stop Shop for Dashboard Functions
#' @export
Dashboard <- R6::R6Class(
    classname = "Dashboard",
    cloneable = FALSE,
    lock_objects = FALSE
)

# Helper Functions --------------------------------------------------------
Dashboard$utils <- new.env()

Dashboard$utils$prepare_app_files <-  function(dashboard_source, dashboard_target){
    unlink <- purrr::partial(base::unlink, recursive = TRUE, force = TRUE)

    dashboard_source <- normalizePath(dashboard_source)
    dashboard_target <- normalizePath(dashboard_target)
    package_source <- "."
    package_target <- normalizePath(file.path(dashboard_target, "package"))

    Dashboard$utils$create_dir(dashboard_target)
    fs::dir_copy(dashboard_source, dirname(dashboard_target))
    fs::dir_copy(package_source, package_target)
    unlink(file.path(package_target, c(".Rprofile")))
    unlink(file.path(package_target, c(".app", ".git", ".Rproj.user", "check", "vignettes")))
    unlink(file.path(package_target, "inst", "dashboard"))
    unlink(Dashboard$utils$list_markdown(package_target))
    Dashboard$utils$write_requirements(package_target, dashboard_target)

    invisible()
}

Dashboard$utils$write_requirements <- function(package_path, dashboard_path){
    invisible(
        dependencies <- desc::desc_get_deps(file.path(package_path, "DESCRIPTION"))
        %>% dplyr::filter(type %in% c("Imports", "Depends"), package != "R")
        %>% .$package
    )
    writeLines(paste0("library(", dependencies, ")"), file.path(dashboard_path, "requirements.R"))
    invisible()
}

Dashboard$utils$create_dir <- function(x){
    base::unlink(x, recursive = TRUE, force = TRUE)
    base::dir.create(x, FALSE, TRUE)
    invisible()
}

Dashboard$utils$list_markdown <- function(path){
    list.files(path, ".(Rmd|md)$", full.names = TRUE, recursive = TRUE)
}

# {DT} functions ----------------------------------------------------------
Dashboard$DT <- new.env()

Dashboard$DT$col_to_hide <- function(data, col_names){
    col_numbers <- match(col_names, colnames(data))
    DT_options <- list()
    DT_options[[1]] <- list(visible = FALSE, targets = col_numbers)
    return(DT_options)
}

Dashboard$DT$col_to_show <- function(data, col_names){
    col_numbers <- base::setdiff(1:ncol(data), match(col_names, colnames(data)))
    DT_options <- list()
    DT_options[[1]] <- list(visible = FALSE, targets = col_numbers)
    return(DT_options)
}

# {shiny} functions -------------------------------------------------------
Dashboard$shiny <- new.env()
Dashboard$shiny$tableFilterGenerator <- function(data, col_name, Namespace = function(id) return(id)){
    choices <- if(is.factor(data[[col_name]])) levels(data[[col_name]]) else return(NULL)
    shiny::selectInput(inputId = Namespace(col_name), label = col_name, choices = choices, multiple = TRUE)
}
