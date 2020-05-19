# MockDatabase ------------------------------------------------------------
#' @title Create a caret Model to Present on a Dashboard
#' @export
MockDatabase <- R6::R6Class(
    classname = "MockDatabase",
    cloneable = FALSE,
    lock_objects = FALSE,
    public = list(
        # Public Fields --------------------------------------------------------
        path = character(0),
        artifact = c(),
        # Public Methods -------------------------------------------------------
        #' @description
        #' Generate a caret model
        initialize = function(){self$artifact <- MockDatabase$funs$load_caret()}
    )
)


# Dashboard functions -----------------------------------------------------
MockDatabase$funs <- new.env()

MockDatabase$funs$load_caret <-  function(){
    set.seed(1353)

    caret <- new.env()
    caret <- MockDatabase$funs$load_data(envir = caret)
    caret <- MockDatabase$funs$load_model(envir = caret)
    return(caret)
}

MockDatabase$funs$load_data <- function(envir){
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

MockDatabase$funs$load_model <- function(envir){
    assertthat::assert_that(
        !is.null(envir$role_target),
        !is.null(envir$role_input),
        !is.null(envir$dataset)
    )

    role_target <- envir$role_target
    role_input <- envir$role_input
    model_formula <- formula(paste(envir$role_target, "~" , paste(envir$role_input, collapse = " + ")))
    model_object <- MockDatabase$funs$model_fit(envir$dataset, model_formula)

    envir$train <- model_object
    return(envir)
}

MockDatabase$funs$model_fit <- function(data, formula){
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
