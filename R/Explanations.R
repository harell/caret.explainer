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
        #' @description
        #' Construct an Explanations object
        initialize = function(...){
            assert_that <- assertthat::assert_that

            objects <- list(...)
            for(object in objects){
                assert_that("ModelComposition" %in% class(object))
                private$DALEX <- append(private$DALEX, list(object$DALEX))
            } # DALEX for-loop

        },

        # iBreakDown plots -----------------------------------------------------
        #' @inherit iBreakDown::break_down description
        #' @param parameters passed to \link[iBreakDown]{break_down}.
        plot_break_down = function(...) Explanations$iBreakDown$plot_break_down(private, ...)
    ),
    private = list(DALEX = list())
)


# Private Methods ---------------------------------------------------------
Explanations$iBreakDown <- new.env()
Explanations$iBreakDown$plot_break_down <- function(private, ...){
    explainer <- private$DALEX[[1]]
    args <- list(x = explainer, new_observation = explainer$data[1, ])
    args <- purrr::list_modify(args, !!!list(...))
    break_down <- do.call(iBreakDown::break_down, args)

    ggplot <- plot(break_down)
    return(ggplot)
}

