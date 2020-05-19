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
        establish_connection = function() invisible(self)
    )
)

