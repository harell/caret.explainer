# Dashboard Class ---------------------------------------------------------
#' @title One Stop Shop for Dashboard Functions
#' @export
Dashboard <- R6::R6Class(
    classname = "LinkFunction",
    cloneable = FALSE,
    lock_objects = FALSE
)
Dashboard$funs <- new.env()

# Dashboard Functions -----------------------------------------------------
Dashboard$funs$get_titanic_glm <- function(){
    utils::data('titanic_imputed', package = "DALEX")
    dataset <- titanic_imputed
    dataset$survived <- factor(dataset$survived, levels = 1:0, c("Survived", "Perished"))
    role_target <- "survived"
    role_input <- c("gender", "age", "class", "embarked", "fare", "sibsp", "parch")
    model_formula <- formula(paste(role_target, "~" , paste(role_input, collapse = " + ")))

    set.seed(1546)
    caret_ctrl <- caret::trainControl(method = "none", classProbs = TRUE, summaryFunction = caret::twoClassSummary)
    caret_train <- caret::train(model_formula, data = dataset, method = "glm", trControl = caret_ctrl)
    return(caret_train)
}
