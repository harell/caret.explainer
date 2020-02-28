# Project Helpers ---------------------------------------------------------
testthat <- testthat::test_env()
testthat$get_package_name <- function() eval(parse(text = 'pkgload::pkg_name(testthat$get_projet_dir())'))
testthat$get_projet_dir <- function() dirname(testthat$get_root_desc(testthat$find_root())[1])
testthat$find_root <- function() {proj_path <- getwd(); while (length(grep("test", proj_path))>0) proj_path <- dirname(proj_path); return(proj_path)}
testthat$get_root_desc <- function(path) list.files(path, "DESCRIPTION", full.names = TRUE, recursive = TRUE)

# Expectations -----------------------------------------------------------------
error_message <- function(title, failed_values = NULL) paste0("Error! ", title, paste0(failed_values, collapse = ", "))
expect <- function(ok, failure_message, info = NULL, srcref = NULL){testthat::expect(identical(ok, TRUE), failure_message, info, srcref); invisible()}
expect_class <- function(object, class) expect(any(base::class(object) %in% class), error_message(paste("object is", base::class(object), "not", class)))
expect_length_gte <- function(object, n) function (object, n)
{
    stopifnot(is.numeric(n), length(n) == 1)
    act <- quasi_label(enquo(object), arg = "object")
    act$n <- length(act$val)
    expect(act$n >= n, sprintf("%s has length %i, not length %i.", act$lab, act$n, n))
    invisible(act$val)
}

# Skips -------------------------------------------------------------------
skip_on_pc <- function(){
    is_ci <- function() identical(Sys.getenv("CI"), "true")
    if (isTRUE(is_ci())) return(invisible(TRUE))
    testthat::skip("On PC")
}
