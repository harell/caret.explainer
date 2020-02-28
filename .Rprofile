# First -------------------------------------------------------------------
.First <- function(){
    # Helper Functions ---------------------------------------------------------
    set_repos <- function(){
        DESCRIPTION <- readLines("DESCRIPTION")
        Date <- trimws(gsub("Date:", "", DESCRIPTION[grepl("Date:", DESCRIPTION)]))
        if(length(Date) == 1) options(repos = paste0("https://mran.microsoft.com/snapshot/", Date))
    }

    # Programming Logic --------------------------------------------------------
    suppressWarnings(try(set_repos(), silent = TRUE))
    pkgs <- c("usethis", "testthat", "devtools")
    invisible(sapply(pkgs, require, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE))

    options(dashboard_source = file.path(getwd(), "inst/dashboard"))
    options(dashboard_target = file.path(tempdir(), "dashboard"))
    options(path_dashboard = getOption("dashboard_target"))
}

# Last --------------------------------------------------------------------
.Last <- function(){}
