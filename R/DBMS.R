# Database Management System ----------------------------------------------
#' @title Database Management System for Interfacing between Presentation Layer and Functional Layer
#' @field path (`character`) A path to the database location.
#' @param artifact (`?`) An object.
#' @param tags (`character`) A character vector with key:value tags.
#' @export
DBMS <- R6::R6Class(
    classname = "DBMS",
    cloneable = FALSE,
    lock_objects = FALSE,
    public = list(
        # Public Fields --------------------------------------------------------
        path = character(0),
        # Public Methods -------------------------------------------------------
        #' @description
        #' Initialize a database
        #' @param path (`character`) A path to the database location
        initialize = function(path = tempfile("DBMS")){
            dir.create(path, showWarnings = FALSE, recursive = TRUE)
            self$path <- path
        },
        #' @description
        #' Establish a connection to the database
        establish_connection = function() DBMS$funs$establish_connection(self),
        #' @description
        #' Create an artifact in the archive
        create = function(artifact, tags = c()) DBMS$funs$create(self, artifact, tags),
        #' @description
        #' Read an artifact from the archive
        #' @param tags (`character`) A character vector with key:value tags
        read = function(tags) DBMS$funs$read(self, tags)
    )
)
DBMS$funs <- new.env()

# Public Methods ----------------------------------------------------------
DBMS$funs$establish_connection <- function(self){
    archivist::createLocalRepo(repoDir = self$path, force = FALSE, default = FALSE)
    invisible(self)
}

DBMS$funs$create <- function(self, artifact, tags){
    archivist::saveToLocalRepo(artifact, repoDir = self$path, userTags = tags)
}

DBMS$funs$read <- function(self, tags){
    archivist::setLocalRepo(repoDir = self$path)
    artifact <- archivist::asearch(tags, repo = NULL)
    return(artifact)
}

