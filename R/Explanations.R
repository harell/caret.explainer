#' @title Explore, Explain and Examine Predictive Models
#'
#' @details
#'
#' * Instance-level explainers
#' * Dataset-level explainers
#'
#' @section Further Reading:
#' * \href{https://pbiecek.github.io/ema/}{Explanatory Model Analysis book}
#'
#' @export
#'
#' @param ... (`ModelComposition`) One or more objects created by \link{ModelComposition}.
#'
Explanations <- R6::R6Class(
    classname = "Explanations",
    public = list(
        # Public Fields --------------------------------------------------------

        # Public Methods -------------------------------------------------------
        #' @description
        #' Construct an Explanations object
        initialize = function(...){
            # browser()
            objects <- list(...)
            for(object in objects) assertthat::assert_that("ModelComposition" %in% class(object))
        }
    ),
    private = list(
        # Private Fields -------------------------------------------------------
        DALEX_array = list()
        # Private Methods ------------------------------------------------------
        # instantiate_DALEX = function(object) ModelComposition$funs$instantiate_DALEX(object)
    )
)
Explanations$funs <- new.env()

# Private Methods ---------------------------------------------------------
# Explanations$funs$instantiate_DALEX <- function(object){
#     DALEX::explain(
#         model = object$model_object,
#         data = object$historical_data[, object$role_input],
#         y = object$historical_data[, object$role_target],
#         predict_function = object$predict_function,
#         verbose = FALSE
#     )
# }

