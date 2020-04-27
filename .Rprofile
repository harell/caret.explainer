# First -------------------------------------------------------------------
.First <- function(){
    # Helper Functions
    get_repos <- function(){
        DESCRIPTION <- readLines("DESCRIPTION")
        Date <- trimws(gsub("Date:", "", DESCRIPTION[grepl("Date:", DESCRIPTION)]))
        URL <- if(length(Date) == 1) paste0("https://mran.microsoft.com/snapshot/", Date) else "https://cran.rstudio.com/"
        return(URL)
    }

    # Programming Logic
    options(Ncpus = 8, repos = structure(c(CRAN = get_repos())), dependencies = "Imports")
    pkgs <- c("usethis", "testthat", "devtools")
    invisible(sapply(pkgs, require, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE))
}

# Last --------------------------------------------------------------------
.Last <- function(){}
