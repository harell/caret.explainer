context("unit test for package hooks")

# onAttach ----------------------------------------------------------------
test_that("Global options are defined", {
    err_msg <- "onAttach did not load config-r.yml"
    expect_true(identical(is.null(.Options$path_inst), FALSE), info = err_msg)
})

