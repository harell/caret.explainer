# First -------------------------------------------------------------------
.First <- function(){
    assign(".Rprofile", new.env(), envir = globalenv())

    # Helpers
    .Rprofile$NEW_SESSION <- new.env()
    .Rprofile$NEW_SESSION$unset <- function() Sys.unsetenv("NEW_SESSION")
    .Rprofile$NEW_SESSION$set <- function() Sys.setenv(NEW_SESSION = FALSE)
    .Rprofile$NEW_SESSION$get <- function() as.logical(Sys.getenv("NEW_SESSION"))
    get_repos <- function(){
        DESCRIPTION <- readLines("DESCRIPTION")
        Date <- trimws(gsub("Date:", "", DESCRIPTION[grepl("Date:", DESCRIPTION)]))
        URL <- if(length(Date) == 1) paste0("https://mran.microsoft.com/snapshot/", Date) else "https://cran.rstudio.com/"
        return(URL)
    }

    # Programming Logic
    ## .First watchdog
    if(isFALSE(.Rprofile$NEW_SESSION$get())) return() else .Rprofile$NEW_SESSION$set()

    ## Set global options
    options(startup.check.options.ignore = "stringsAsFactors", stringsAsFactors = TRUE)

    ## Initiate the package management system
    options(Ncpus = 8, repos = structure(c(CRAN = get_repos())), dependencies = "Imports", build = FALSE)
    try({
        source("./.app/renv/activate-renv.R", local = .Rprofile)
        message("Activate the package management system with: .Rprofile$activate()")
    })

    ## Load development toolkit
    pkgs <- c("usethis", "testthat", "devtools")
    invisible(sapply(pkgs, require, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE))
}

# Last --------------------------------------------------------------------
.Last <- function(){
    unlink <- function(x) base::unlink(x, recursive = TRUE, force = TRUE)

    ## .First watchdog
    .Rprofile$NEW_SESSION$unset()

    ## Cleanup
    unlink("./.git/index.lock")
    unlink("./renv")
    rm(unlink)
}
