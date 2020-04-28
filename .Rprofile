# First -------------------------------------------------------------------
.First <- function(){
    # Helpers
    get_repos <- function(){
        DESCRIPTION <- readLines("DESCRIPTION")
        Date <- trimws(gsub("Date:", "", DESCRIPTION[grepl("Date:", DESCRIPTION)]))
        URL <- if(length(Date) == 1) paste0("https://mran.microsoft.com/snapshot/", Date) else "https://cran.rstudio.com/"
        return(URL)
    }

    # Programming Logic
    ## .First watchdog
    if(isFALSE(Sys.getenv("NEW_SESSION"))) return() else Sys.setenv(NEW_SESSION = FALSE)

    ## Set global options
    options(startup.check.options.ignore = "stringsAsFactors", stringsAsFactors = TRUE)

    ## Initiate the package management system
    options(Ncpus = 8, repos = structure(c(CRAN = get_repos())), dependencies = "Imports", build = FALSE)
    try(source("./.app/renv/activate.R"))
    message("Activate the package management system with: activate()")

    ## Load development toolkit
    pkgs <- c("usethis", "testthat", "devtools")
    invisible(sapply(pkgs, require, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE))
}

# Last --------------------------------------------------------------------
.Last <- function(){
    unlink <- function(x) base::unlink(x, recursive = TRUE, force = TRUE)

    ## .First watchdog
    Sys.unsetenv("NEW_SESSION")

    ## Cleanup
    unlink("./.git/index.lock")
    unlink("./renv")
    rm(unlink)
}
