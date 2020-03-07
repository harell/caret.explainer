#' @title Decompose a caret model into its essential parts
#'
#' @description
#' Given \code{object} which is a `caret` object made with \link[caret]{train},
#' When \code{CaretModelDecomposition$new(object)} is called,
#' Then the object essential parts are available via public fields.
#'
#' @export
#'
#' @section Further Reading:
#' * \href{http://topepo.github.io/caret/}{The `caret` Package book}
#'
#' @param object (`train`) A model object made by \link[caret]{train}.
#'
CaretModelDecomposition <- R6::R6Class(
    inherit = ModelDecomposition,
    classname = "CaretModelDecomposition",
    cloneable = FALSE,
    lock_objects = TRUE,
    public = list(
        # Public Methods -------------------------------------------------------
        #' @description
        #' Predict method for \code{object}.
        #' @param newdata (`data.frame`)` A data table in which to look for
        #'   variables with which to predict.
        predict_function = function(object, newdata) CaretModelDecomposition$funs$predict_function(object, newdata)
    ),
    private = list(
        # Private Fields -------------------------------------------------------
        # Private Methods ------------------------------------------------------
        extract_model_object = function(object) CaretModelDecomposition$fun$extract_model_object(object),
        extract_data = function(object) CaretModelDecomposition$fun$extract_data(object),
        extract_role_target = function(object) CaretModelDecomposition$fun$extract_role_target(object),
        extract_role_input = function(object) CaretModelDecomposition$fun$extract_role_input(object)
    )
)
CaretModelDecomposition$fun <- new.env()

# Public Methods ----------------------------------------------------------
CaretModelDecomposition$funs$predict_function <- function(object, newdata){
    response <- caret::predict.train(object, newdata, type = "prob", na.action = na.fail)
    if(is.data.frame(response)) return(response[, 1]) else return(response)
}

# Private methods ---------------------------------------------------------
CaretModelDecomposition$fun$extract_model_object <- function(object) object
CaretModelDecomposition$fun$extract_role_target <- function(object) all.vars(object$terms)[1]
CaretModelDecomposition$fun$extract_role_input <- function(object) all.vars(object$terms)[-1]
CaretModelDecomposition$fun$extract_data <- function(object){
    self <- get("self", envir = parent.frame(2))
    object[["trainingData"]] %>% dplyr::rename(!!self$role_target := .outcome)
}
