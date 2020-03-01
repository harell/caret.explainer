context("component test for Explanations object")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    test_env$mc <- MockModelDecomposition$new() %>% ModelComposition$new()
})

# General -----------------------------------------------------------------
test_that("Explanations$new works", {
    attach(test_env)
    expect_silent(explanations <- Explanations$new(test_env$mc))
    expect_class(explanations, "Explanations")
    test_env$explanations <- explanations
})

# ModelComposition DALEX --------------------------------------------------
# test_that("ModelComposition$new works", {
#     attach(test_env)
#     expect_class(test_env$mc$DALEX, "explainer")
# })

