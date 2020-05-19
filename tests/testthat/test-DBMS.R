context("unit test for DBMS")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
})

# General -----------------------------------------------------------------
test_that("DBMS$new works", {
    attach(test_env)
    expect_silent(database <- DBMS$new())
    expect_class(database, "DBMS")
    test_env$database <- database
})

# establish_connection ----------------------------------------------------
test_that("DBMS$establish_connection works", {
    attach(test_env)
    expect_silent(test_env$database$establish_connection())
})


