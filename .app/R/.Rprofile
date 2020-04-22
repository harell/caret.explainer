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
    path <- ".git/First.lock"
    if(file.exists(path)){unlink(path); return()} else {file.create(path, recursive = TRUE)}

    ## Set global options
    print('Sys.getenv("R_LIBS_USER"):'); print(Sys.getenv("R_LIBS_USER"))
    .libPaths(Sys.getenv("R_LIBS_USER"))
    options(Ncpus = 8, repos = structure(c(CRAN = get_repos())))

    ## Install requirements
    if(!"remotes" %in% rownames(utils::installed.packages())) utils::install.packages("remotes", clean = TRUE)
    try(remotes::install_github("ropenscilabs/tic@v0.5.0", dependencies = TRUE, quiet = TRUE))

    return(invisible())
}

# Last --------------------------------------------------------------------
.Last <- function(){}
