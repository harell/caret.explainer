# Database Management System ----------------------------------------------
#' @title Database Management System for Interfacing between Presentation Layer and Functional Layer
#' @export
DBMS <- R6::R6Class(
    classname = "DBMS",
    cloneable = FALSE,
    lock_objects = FALSE,
    public = list(
        # Public Methods -------------------------------------------------------
        #' @description
        #' Establish a connection to the database
        establish_connection = function() DBMS$funs$establish_connection(self),
        #' @description
        #' Query the database by using JSON tags
        #' @param tags (`character`) A character vector with key:value tags
        query_tags = function(tags) DBMS$funs$query_tags(self, tags)
    )
)
DBMS$funs <- new.env()

# Public Methods ----------------------------------------------------------
DBMS$funs$establish_connection <- function(self){
    invisible(self)
}

DBMS$funs$query_tags <- function(self, tags){
    invisible(self)
}
