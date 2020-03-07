# Dashboard Class ---------------------------------------------------------
#' @title One Stop Shop for Dashboard Functions
#' @export
Dashboard <- R6::R6Class(
    classname = "LinkFunction",
    cloneable = FALSE,
    lock_objects = FALSE
)

# Utils -------------------------------------------------------------------
Dashboard$utils <- new.env()
Dashboard$utils$yaml2env <- function(input = "config.yml", envir = globalenv()) {
    yaml_content <- yaml::yaml.load_file(input, eval.expr = TRUE)
    list2env(yaml_content, envir = envir)
    invisible()
}

# Dashboard Functions -----------------------------------------------------
Dashboard$funs <- new.env()
Dashboard$funs$load_data <- function(){
    caret <- new.env()

    set.seed(2112)
    utils::data('titanic_imputed', package = "DALEX")
    dataset <-
        titanic_imputed %>%
        dplyr::mutate(survived = factor(survived, levels = 1:0, c("Survived", "Perished"))) %>%
        tibble::add_column(name = generator::r_full_names(nrow(.)), .before = 0)

    role_target <- "survived"
    role_input <- c("gender", "age", "class", "embarked", "fare", "sibsp", "parch")
    role_info <- c("name", "gender")
    model_formula <- formula(paste(role_target, "~" , paste(role_input, collapse = " + ")))

    set.seed(1546)
    caret_ctrl <- caret::trainControl(method = "none", classProbs = TRUE, summaryFunction = caret::twoClassSummary)
    train <- caret::train(
        model_formula,
        data = dataset,
        method = "glm",
        trControl = caret_ctrl
    )

    caret$dataset <- dataset
    caret$role_target <- role_target
    caret$role_input <- role_input
    caret$role_info <- role_info
    caret$train <- train

    assign("caret", caret, envir = parent.frame(1))
    invisible()
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

