# CaretModelFactory ------------------------------------------------------------
#' @title Create a caret Model to Present on a Dashboard
#' @field artifact (`environment`) An environment with a caret model
#' @export
CaretModelFactory <- R6::R6Class(
    classname = "CaretModelFactory",
    cloneable = FALSE,
    lock_objects = FALSE,
    public = list(
        # Public Fields --------------------------------------------------------
        artifact = c(),
        # Public Methods -------------------------------------------------------
        #' @description
        #' Generate a caret model
        initialize = function(){self$artifact <- CaretModelFactory$funs$load_caret()}
    )
)
CaretModelFactory$funs <- new.env()

# Dashboard functions -----------------------------------------------------
CaretModelFactory$funs$load_caret <-  function(){
    set.seed(1353)

    caret <- new.env()
    caret <- CaretModelFactory$funs$load_data(envir = caret)
    caret <- CaretModelFactory$funs$load_model(envir = caret)
    return(caret)
}

CaretModelFactory$funs$load_data <- function(envir){
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

CaretModelFactory$funs$load_model <- function(envir){
    assertthat::assert_that(
        !is.null(envir$role_target),
        !is.null(envir$role_input),
        !is.null(envir$dataset)
    )

    role_target <- envir$role_target
    role_input <- envir$role_input
    model_formula <- formula(paste(envir$role_target, "~" , paste(envir$role_input, collapse = " + ")))
    model_object <- CaretModelFactory$funs$model_fit(envir$dataset, model_formula)

    envir$train <- model_object
    return(envir)
}

CaretModelFactory$funs$model_fit <- function(data, formula){
    is.formula <- function (x) invisible(inherits(x, "formula"))
    assertthat::assert_that(is.data.frame(data), is.formula(formula))
    set.seed(1546)

    caret_ctrl <- caret::trainControl(method = "none")

    caret_tune <- NULL

    model_object <- caret::train(
        formula,
        data = data,
        method = "glm",
        tuneGrid = caret_tune,
        trControl = caret_ctrl
    )

    return(model_object)
}
