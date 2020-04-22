# .onAttach ---------------------------------------------------------------
#nocov start
.onAttach <- function(...) {
    # Helpers
    find_config_file <- function(){
        candidates <- list.files(path = get_projet_dir(), pattern = "^config-r.yml$", full.names = TRUE, recursive = TRUE)
        return(candidates[which.min(nchar(candidates))])
    }

    get_projet_dir <- function(){
        candidates <- dirname(list.files(stringr::str_remove(getwd(), "(/tests/testthat|/tests)$|[^\\/]+tests$"), "^DESCRIPTION$", full.names = TRUE, recursive = TRUE))
        return(candidates[which.min(nchar(candidates))])
    }

    # Programming Logic
    R_CONFIG_FILE <- find_config_file()
    R_CONFIG_ACTIVE <- "default"
    invisible(config::get(config = R_CONFIG_ACTIVE, file = R_CONFIG_FILE))
}
#nocov end
