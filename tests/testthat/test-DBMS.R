context("unit test for DBMS")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    options(path_archive = tempfile("DBMS"))
})

# General -----------------------------------------------------------------
test_that("DBMS$new works", {
    attach(test_env)
    path_archive <- getOption("path_archive")

    expect_silent(database <- DBMS$new(path_archive))
    expect_class(database, "DBMS")
    expect_equal(database$path, path_archive)

    test_env$database <- database
})

# establish archive -------------------------------------------------------
test_that("DBMS$establish_connection works", {
    attach(test_env)
    expect_silent(test_env$database$establish_connection())
})

# create an artifact ------------------------------------------------------
test_that("DBMS$create works", {
    attach(test_env)
    expect_silent(test_env$database$create(mtcars))
})

# read an artifact --------------------------------------------------------
test_that("DBMS$read works", {
    attach(test_env)
    tags <- "class:data.frame"
    expect_class(artifact <- test_env$database$read(tags), "list")
    expect_class(artifact[[1]], "data.frame")
})



