# Rporfile for CI/CD ------------------------------------------------------
#' When CI/CD starts, it replaces the .Rprofile of this repo (if any) with the
#' content of this file.

# First -------------------------------------------------------------------
.First <- function(){
    assign(".Rprofile", new.env(), envir = globalenv())

    # Helpers
    .Rprofile$unset_NEW_SESSION <- function() Sys.unsetenv("NEW_SESSION")
    .Rprofile$set_NEW_SESSION <- function() Sys.setenv(NEW_SESSION = FALSE)
    .Rprofile$get_NEW_SESSION <- function() as.logical(Sys.getenv("NEW_SESSION"))
    get_repos <- function(){
        DESCRIPTION <- readLines("DESCRIPTION")
        Date <- trimws(gsub("Date:", "", DESCRIPTION[grepl("Date:", DESCRIPTION)]))
        URL <- if(length(Date) == 1) paste0("https://mran.microsoft.com/snapshot/", Date) else "https://cran.rstudio.com/"
        return(URL)
    }

    # Programming Logic
    ## .First watchdog
    if(isFALSE(.Rprofile$get_NEW_SESSION())) return() else .Rprofile$set_NEW_SESSION()

    ## Set global options
    options(startup.check.options.ignore = "stringsAsFactors", stringsAsFactors = TRUE)
    options(Ncpus = 8, repos = structure(c(CRAN = get_repos())), dependencies = "Imports", build = FALSE)
    .libPaths(Sys.getenv("R_LIBS_USER"))

    ## Install requirements
    if(!"remotes" %in% rownames(utils::installed.packages())) utils::install.packages("remotes", dependencies = getOption("dependencies"))
    remotes::install_github("ropenscilabs/tic@v0.7.0", dependencies = getOption("dependencies"), quiet = TRUE, build = FALSE)

    return(invisible())
}

# Last --------------------------------------------------------------------
.Last <- function(){
    ## .First watchdog
    .Rprofile$unset_NEW_SESSION()
}
