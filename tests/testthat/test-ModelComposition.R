context("component test for ModelComposition object")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    test_env$md <- MockModelDecomposition$new()
})

