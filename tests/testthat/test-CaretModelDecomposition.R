context("unit test for CaretModelDecomposition object")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    assign("classification", generate_classification_caret_model(), envir = test_env)
    assign("regression", generate_regression_caret_model(), envir = test_env)
})

# General -----------------------------------------------------------------
test_that("CaretModelDecomposition$new works", {
    attach(test_env)

    # Classification model
    object <- test_env$classification$model
    expect_silent(cmd <- CaretModelDecomposition$new(object))
    expect_class(cmd, "ModelDecomposition")
    test_env$classification$cmd <- cmd

    # Regression model
    object <- test_env$regression$model
    expect_silent(cmd <- CaretModelDecomposition$new(object))
    expect_class(cmd, "ModelDecomposition")
    test_env$regression$cmd <- cmd
})

# Extract essential elements ----------------------------------------------
test_that("CaretModelDecomposition extract essential elements", {
    attach(test_env)
    cmd <- test_env$classification$cmd
    role_target <- test_env$classification$role_target
    role_input <- test_env$classification$role_input

    expect_class(cmd$model_object, "train")
    expect_identical(cmd$role_target, role_target)
    expect_setequal(cmd$role_input, role_input)
    expect_table_has_col_names(cmd$data, c(role_target, role_input))
})

# Predict Function --------------------------------------------------------
test_that("CaretModelDecomposition$predict_function works", {
    attach(test_env)

    # Classification model
    cmd <- test_env$classification$cmd
    new_data <- cmd$data
    model_object <- cmd$model_object
    expect_length(cmd$predict_function(model_object, new_data), nrow(new_data))
    expect_class(cmd$predict_function(model_object, new_data), "numeric")

    # Regression model
    cmd <- test_env$regression$cmd
    new_data <- cmd$data
    model_object <- cmd$model_object
    expect_length(cmd$predict_function(model_object, new_data), nrow(new_data))
    expect_class(cmd$predict_function(model_object, new_data), "numeric")
})

# Cleanup -----------------------------------------------------------------
testthat::teardown(test_env <- NULL)
