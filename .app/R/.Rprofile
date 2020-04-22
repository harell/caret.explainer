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
    ## Setup watchdog
    path <- ".git/First.lock"
    if(file.exists(path)) return() else file.create(path, recursive = TRUE)

    ## Set global options
    .libPaths(Sys.getenv("R_LIBS_USER"))
    options(Ncpus = 8, repos = structure(c(CRAN = get_repos())))

    ## Install requirements
    if(!"remotes" %in% rownames(utils::installed.packages())) utils::install.packages("remotes")
    remotes::install_github("ropenscilabs/tic@v0.6.0", dependencies = "Imports", quiet = TRUE, build = FALSE)

    return(invisible())
}

# Last --------------------------------------------------------------------
.Last <- function(){
    unlink(".git/First.lock")
}
