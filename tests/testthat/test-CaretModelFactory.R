context("unit test for CaretModelFactory")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
})

# General -----------------------------------------------------------------
test_that("CaretModelFactory$new works", {
    attach(test_env)

    expect_silent(caret_model <- CaretModelFactory$new())
    expect_class(caret_model, "CaretModelFactory")
    expect_class(caret_model$artifact, "environment")
    expect_class(caret_model$artifact$train, "train")
})
