context("component test for CaretModelDecomposition object")

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
test_that("CaretModelDecomposition$new works", {
    attach(test_env)
    object <- test_env$caret_train
    expect_silent(cmd <- CaretModelDecomposition$new(object))
    expect_class(cmd, "ModelDecomposition")
    test_env$cmd <- cmd
})

# Extract essential elements ----------------------------------------------
test_that("CaretModelDecomposition extract essential elements", {
    attach(test_env)
    cmd <- test_env$cmd
    role_target <- test_env$role_target
    role_input <- test_env$role_input

    expect_class(cmd$model_object, "train")
    expect_identical(cmd$role_target, role_target)
    expect_setequal(cmd$role_input, role_input)
    expect_table_has_col_names(cmd$historical_data, c(role_target, role_input))
    expect_null(cmd$new_data)
})
