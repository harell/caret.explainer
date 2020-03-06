context("component test for Caret Model Explanations")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    utils::data('titanic_imputed', package = "DALEX")
    dataset <- titanic_imputed
    dataset$survived <- factor(dataset$survived, levels = 1:0, c("Survived", "Perished"))
    role_target <- "survived"
    role_input <- c("gender", "age", "class", "embarked", "fare", "sibsp", "parch")
    model_formula <- formula(paste(role_target, "~" , paste(role_input, collapse = " + ")))

    set.seed(1546)
    suppressWarnings({
        caret_ctrl <- caret::trainControl(method = "none", classProbs = TRUE, summaryFunction = caret::twoClassSummary)
        caret_train <- caret::train(survived ~ ., data = dataset, method = "glm", trControl = caret_ctrl)
        caret_predict <- predict(caret_train, newdata = dataset)
    })

    test_env$role_input <- role_input
    test_env$role_target <- role_target
    test_env$caret_train <- caret_train
})

# General -----------------------------------------------------------------
test_that("Caret model break-down-plot renders", {
    attach(test_env)
    expect_silent(interim_obj <- test_env$caret_train %>% CaretModelDecomposition$new())
    expect_silent(interim_obj <- interim_obj %>% ModelComposition$new())
    expect_silent(interim_obj <- interim_obj %>% Explanations$new())
})
