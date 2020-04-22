# Rporfile for CI/CD ------------------------------------------------------
#' When CI/CD starts, it replaces the .Rprofile of this repo (if any) with the
#' content of this file.

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
    if(identical(Sys.getenv("FRESH_SESSION", FALSE))) return() else Sys.setenv(FRESH_SESSION = FALSE)

    ## Set global options
    .libPaths(Sys.getenv("R_LIBS_USER"))
    options(Ncpus = 8, repos = structure(c(CRAN = get_repos())))

    ## Install requirements
    if(!require(remotes, quietly = TRUE)) utils::install.packages("remotes")
    try(remotes::install_github("ropenscilabs/tic@v0.5.0", dependencies = TRUE, quiet = TRUE))

    return(invisible())
}

# Last --------------------------------------------------------------------
.Last <- function(){}
