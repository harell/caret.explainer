context("component test for ModelComposition object")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    test_env$md <- MockModelDecomposition$new()
})

# General -----------------------------------------------------------------
test_that("ModelComposition$new works", {
    attach(test_env)
    object <- test_env$md
    expect_silent(mc <- ModelComposition$new(test_env$md))
    expect_class(mc, "ModelComposition")
    test_env$mc <- mc
})

# ModelComposition DALEX --------------------------------------------------
test_that("ModelComposition$DALEX works", {
    attach(test_env)
    expect_class(test_env$mc$DALEX, "explainer")
    expect_setequal(colnames(test_env$mc$DALEX$data), test_env$md$role_input)
})

