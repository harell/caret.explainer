# Dashboard Class ---------------------------------------------------------
#' @title One Stop Shop for Dashboard Functions
#' @export
Dashboard <- R6::R6Class(
    classname = "Dashboard",
    cloneable = FALSE,
    lock_objects = FALSE
)

# Utils -------------------------------------------------------------------
Dashboard$load_shiny_configuration <- function(envir = .GlobalEnv){
    config = Sys.getenv("R_CONFIG_ACTIVE", "default")
    file = list.files(".", "config-shiny.yml$", recursive = TRUE, full.names = TRUE)[1]
    list2env(config::get(NULL, config, file), envir = envir)
    invisible()
}

Dashboard$write_requirements <- function(package_path, dashboard_path){
    dependencies <-
        desc::desc_get_deps(file.path(package_path, "DESCRIPTION")) %>%
        dplyr::filter(type == "Imports") %>%
        .$package
    writeLines(paste0("library(", dependencies, ")"), file.path(dashboard_path, "requirements.R"))
    invisible()
}

Dashboard$create_dir <- function(x){
    base::unlink(x, recursive = TRUE, force = TRUE)
    base::dir.create(x, FALSE, TRUE)
    invisible()
}


# Dashboard functions -----------------------------------------------------
Dashboard$funs <- new.env()

Dashboard$funs$load_caret <-  function(){
    set.seed(1353)

    caret <- new.env()
    caret <- Dashboard$funs$load_data(envir = caret)
    caret <- Dashboard$funs$load_model(envir = caret)
    return(caret)
}

Dashboard$funs$load_data <- function(envir){
    role_target <- "survived"
    role_input <- c("gender", "age", "class", "embarked", "fare", "sibsp", "parch")
    role_info <- c("gender")
    role_pk <- "name"

    utils::data('titanic_imputed', package = "DALEX")
    dataset <-
        titanic_imputed %>%
        dplyr::mutate(survived = factor(survived, levels = 1:0, c("Survived", "Perished"))) %>%
        dplyr::mutate_if(is.numeric, ~round(., 0)) %>%
        tibble::add_column(name = generator::r_full_names(nrow(.)), .before = 0)

    envir$dataset <- dataset %>% dplyr::select(!!role_pk, !!role_target, !!role_input, !!role_info)
    envir$role_target <- role_target
    envir$role_input <- role_input
    envir$role_info <- role_info
    envir$role_pk <- role_pk
    return(envir)
}

Dashboard$funs$load_model <- function(envir){
    assertthat::assert_that(
        !is.null(envir$role_target),
        !is.null(envir$role_input),
        !is.null(envir$dataset)
    )

    role_target <- envir$role_target
    role_input <- envir$role_input
    model_formula <- formula(paste(envir$role_target, "~" , paste(envir$role_input, collapse = " + ")))
    model_object <- Dashboard$funs$model_fit(envir$dataset, model_formula)

    envir$train <- model_object
    return(envir)
}

Dashboard$funs$model_fit <- function(data, formula){
    is.formula <- function (x) invisible(inherits(x, "formula"))
    assertthat::assert_that(is.data.frame(data), is.formula(formula))
    set.seed(1546)

    caret_ctrl <- caret::trainControl(method = "none")

    caret_tune <- tibble::tibble(
        nrounds = 50,
        max_depth = 6,
        eta = 0.05,
        gamma = 0.01,
        colsample_bytree = 0.8,
        min_child_weight = 15,
        subsample = 0.5
    )

    model_object <- caret::train(
        formula,
        data = data,
        method = "xgbTree",
        tuneGrid = caret_tune,
        trControl = caret_ctrl
    )

    return(model_object)
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
