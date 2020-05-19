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

# establish_connection ----------------------------------------------------
test_that("DBMS$establish_connection works", {
    attach(test_env)
    expect_silent(test_env$database$establish_connection())
})

# save_an_artifact --------------------------------------------------------
test_that("DBMS$create works", {
    attach(test_env)
    expect_silent(test_env$database$create(mtcars))
})

# # import caret model ------------------------------------------------------
# test_that("DBMS$query_tags works", {
#     attach(test_env)
#     tags <- "class:data.frame"
#     expect_class(test_env$database$query_tags(tags), "data.frame")
# })



