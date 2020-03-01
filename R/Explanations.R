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
            assert_that <- assertthat::assert_that

            objects <- list(...)
            for(object in objects){
                assert_that("ModelComposition" %in% class(object))
                private$DALEX <- append(private$DALEX, list(object$DALEX))
            } # DALEX for-loop

        } # end initialize()
    ),
    private = list(
        # Private Fields -------------------------------------------------------
        DALEX = list()
        # Private Methods ------------------------------------------------------
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

