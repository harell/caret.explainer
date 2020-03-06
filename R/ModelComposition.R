#' @title Model Explainers Factory
#'
#' @details ModelComposition decoupls the construction of explainers objects from the objects themselves.
#'
#' @field DALEX (`explainer`) An object constructed by \link[DALEX]{explain}.
#'
#' @export
#'
#' @param object (`ModelDecomposition`) A decomposed model object constructed by
#'   \link{ModelDecomposition} subclass.
#'
ModelComposition <- R6::R6Class(
    classname = "ModelComposition",
    public = list(
        # Public Fields --------------------------------------------------------
        DALEX = NULL,
        # Public Methods -------------------------------------------------------
        #' @description
        #' Decompose a given object to its essential parts.
        initialize = function(object){
            assertthat::assert_that("ModelDecomposition" %in% class(object))
            self$DALEX <- private$instantiate_DALEX(object)
        }
    ),
    private = list(
        # Private Fields -------------------------------------------------------
        # Private Methods ------------------------------------------------------
        instantiate_DALEX = function(object) ModelComposition$funs$instantiate_DALEX(object)
    )
)
ModelComposition$funs <- new.env()

# Private Methods ---------------------------------------------------------
ModelComposition$funs$instantiate_DALEX <- function(object){
    suppressWarnings(
        explainer <- DALEX::explain(
            model = object$model_object,
            data = object$data[, object$role_input],
            y = object$data[, object$role_target],
            predict_function = object$predict_function,
            verbose = FALSE
        )
    )
    return(explainer)
}

