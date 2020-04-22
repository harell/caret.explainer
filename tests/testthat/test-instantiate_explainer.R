context("unit test for instantiate_explainer")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", generate_classification_caret_model(), envir = parent.frame())
})

# Test Cases --------------------------------------------------------------
test_that("instantiate_explainer works", {
    attach(test_env)
    expect_silent(explanations <- instantiate_explainer(test_env$model))
    expect_class(explanations, "Explanations")
})

# Cleanup -----------------------------------------------------------------
testthat::teardown(test_env <- NULL)

