context("unit test for CaretModelFactory")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    # options(path_archive = tempfile("DBMS"))
})

# General -----------------------------------------------------------------
test_that("CaretModelFactory$new works", {
    attach(test_env)

    expect_silent(caret_model <- CaretModelFactory$new())
    expect_class(caret_model, "CaretModelFactory")
})
