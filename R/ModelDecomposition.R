#' @title Abstract Class for Model Decomposition Sub Classes
#'
#' @description The class takes an object containing a prediction model and
#'   decomposes it into its essential parts.
#'
#' @field model_object (`?`) A model object to decompose.
#' @field historical_data (`data.frame`) A data table with the data used to
#'   create \code{model_object}.
#' @field new_data (`data.frame`) A data table with the data to predict.
#' @field role_target (`character`) The name of the target variable in
#'   \code{model_object}.
#' @field role_input (`character`) The name of the target variable
#'   \code{model_object}.
#'
#' @export
#'
#' @param object (`?`) A model object to decompose.
#'
ModelDecomposition <- R6::R6Class( # nocov start
    classname = "ModelDecomposition",
    cloneable = FALSE,
    lock_objects = TRUE,
    public = list(
        # Public Fields --------------------------------------------------------
        model_object = NULL,
        historical_data = NULL,
        new_data = NULL,
        role_target = NULL,
        role_input = NULL,
        # Public Methods -------------------------------------------------------
        #' @description
        #' Predict method for \code{object}.
        #' @param newdata (`data.frame`)` A data table in which to look for
        #'   variables with which to predict.
        predict_function = function(object, newdata = NULL) predict(object, newdata),
        #' @description
        #' Decompose a given object to its essential parts.
        initialize = function(object){
            self$role_target <- private$extract_role_target(object)
            self$role_input <- private$extract_role_input(object)
            self$historical_data <- private$extract_historical_data(object)
            self$new_data <- private$extract_new_data(object)
            self$model_object <- private$extract_model_object(object)
        }
    ),
    private = list(
        # Private Fields -------------------------------------------------------
        # Private Methods ------------------------------------------------------
        extract_model_object = function(object) stop("I'm a signature function"),
        extract_historical_data = function(object) stop("I'm a signature function"),
        extract_new_data = function(object) stop("I'm a signature function"),
        extract_role_target = function(object) stop("I'm a signature function"),
        extract_role_input = function(object) stop("I'm a signature function")
    )
) # nocov end
