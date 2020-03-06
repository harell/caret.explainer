context("component test for package hooks")

test_that("Global options are defined", {
    expect_identical(getOption("stringsAsFactors"), TRUE)
})
