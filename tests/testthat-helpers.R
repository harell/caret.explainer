# Project Helpers ---------------------------------------------------------
testthat <- testthat::test_env()
testthat$get_package_name <- function() gsub("Package:(| )", "", readLines(file.path(testthat$get_projet_dir(), "DESCRIPTION"), 1))
testthat$get_projet_dir <- function(){
    candidates <- dirname(list.files(stringr::str_remove(getwd(), "(/tests/testthat|/tests)$|[^\\/]+tests$"), "^DESCRIPTION$", full.names = TRUE, recursive = TRUE))
    return(candidates[which.min(nchar(candidates))])
}
# Expectations ------------------------------------------------------------
error_message <- function(title, failed_values = NULL) paste0("Error! ", title, paste0(failed_values, collapse = ", "))
expect <- function(ok, failure_message, info = NULL, srcref = NULL){testthat::expect(identical(ok, TRUE), failure_message, info, srcref); invisible()}
expect_class <- function(object, class) expect(any(base::class(object) %in% class), error_message(paste("object is", base::class(object), "not", class)))
expect_table_has_col_names <- function(object, col_names) if(is.null(expect_class(object, "data.frame"))) expect(all(col_names %in% colnames(object)), error_message("data.frame missing columns: ", setdiff(col_names, colnames(object))))
expect_not_null <- function(object) expect(isFALSE(is.null(object)), "object is NULL")
expect_file_exists <- function(path) expect(file.exists(path), error_message("Could not find ", path))

# Skips -------------------------------------------------------------------
skip_on_pc <- function(){
    is_ci <- function() identical(Sys.getenv("CI"), "true")
    if (isTRUE(is_ci())) return(invisible(TRUE))
    testthat::skip("On PC")
}

