source(list.files(path = dirname(getwd()), pattern = "testthat-helpers.R$", recursive = TRUE, full.names = TRUE))

# Stubs -------------------------------------------------------------------
generate_glm_caret_model <- function(){
    caret <- new.env()

    utils::data('titanic_imputed', package = "DALEX")
    dataset <- titanic_imputed
    dataset$survived <- factor(dataset$survived, levels = 1:0, c("Survived", "Perished"))
    role_target <- "survived"
    role_input <- c("gender", "age", "class", "embarked", "fare", "sibsp", "parch")
    model_formula <- formula(paste(role_target, "~" , paste(role_input, collapse = " + ")))

    set.seed(1546)
    caret_ctrl <- caret::trainControl(method = "none", classProbs = TRUE, summaryFunction = caret::twoClassSummary)
    caret_train <- caret::train(model_formula, data = dataset, method = "glm", trControl = caret_ctrl)

    caret$role_input <- role_input
    caret$role_target <- role_target
    caret$model <- caret_train

    return(caret)
}

generate_xgboost_caret_model <- function(){
    caret <- new.env()

    utils::data('mtcars', package = "datasets")
    dataset <- mtcars
    dataset$vs <- factor(dataset$vs, levels = 0:1, c("V-shaped", "Straight"))

    role_target <- "mpg"
    role_input <- c("cyl","disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb")
    model_formula <- formula(paste(role_target, "~" , paste(role_input, collapse = " + ")))

    set.seed(1546)
    caret_ctrl <- caret::trainControl(method = "none")
    caret_tune <- tibble::tibble(
        nrounds = 5,
        max_depth = 6,
        eta = 0.05,
        gamma = 0.01,
        colsample_bytree = 0.8,
        min_child_weight = 15,
        subsample = 0.5
    )
    caret_train <- caret::train(
        model_formula,
        data = dataset,
        method = "xgbTree",
        tuneGrid = caret_tune,
        trControl = caret_ctrl)

    caret$role_input <- role_input
    caret$role_target <- role_target
    caret$model <- caret_train

    return(caret)
}

generate_lm_caret_model <- function(){
    caret <- new.env()

    utils::data('mtcars', package = "datasets")
    dataset <- mtcars
    dataset$vs <- factor(dataset$vs, levels = 0:1, c("V-shaped", "Straight"))

    role_target <- "mpg"
    role_input <- c("cyl","disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb")
    model_formula <- formula(paste(role_target, "~" , paste(role_input, collapse = " + ")))

    set.seed(1546)
    suppressWarnings({
        caret_ctrl <- caret::trainControl(method = "none")
        caret_train <- caret::train(model_formula, data = dataset, method = "lm", trControl = caret_ctrl)
        caret_predict <- predict(caret_train, newdata = dataset)
    })

    caret$role_input <- role_input
    caret$role_target <- role_target
    caret$model <- caret_train

    return(caret)
}
