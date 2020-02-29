context("component test for CaretModelDecomposition object")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    utils::data('titanic_imputed', package = "DALEX")
    dataset <- titanic_imputed
    dataset$survived <- factor(dataset$survived, levels = 1:0, c("Survived", "Perished"))

    set.seed(1546)
    suppressWarnings({
        caret_ctrl <- caret::trainControl(method = "none", classProbs = TRUE, summaryFunction = caret::twoClassSummary)
        caret_train <- caret::train(survived ~ ., data = dataset, method = "glm", trControl = caret_ctrl)
        caret_predict <- predict(caret_train, newdata = dataset)
    })

    test_env$caret_train <- caret_train
})

# General -----------------------------------------------------------------
test_that("CaretModelDecomposition$new works", {
    attach(test_env)
    object <- test_env$caret_train
    expect_silent(pme <- CaretModelDecomposition$new(object))
    expect_class(pme, "ModelDecomposition")
})
