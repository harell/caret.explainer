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
#' @param new_observation (`data.frame`) A new observation with columns that
#'   correspond to variables used in the model.
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
        #' @param ... parameters passed to \link[iBreakDown]{break_down}.
        plot_break_down = function(new_observation, ...) Explanations$iBreakDown$plot_break_down(private, new_observation, ...)
    ),
    private = list(DALEX = list())
)

# Private Methods ---------------------------------------------------------
Explanations$iBreakDown <- new.env()
Explanations$iBreakDown$plot_break_down <- function(private, new_observation = NULL, ...){
    return_blank_ggplot <- Explanations$helpers$return_blank_ggplot
    has_no_new_observation <- function(args) is.null(args$new_observation)

    args <- list(x = private$DALEX[[1]])
    args <- purrr::list_modify(args, !!!list(...))

    if(args %>% has_no_new_observation()) return(return_blank_ggplot())

    break_down <- do.call(iBreakDown::break_down, args)
    ggplot <- plot(break_down)
    return(ggplot)
}

# Helpers -----------------------------------------------------------------
Explanations$helpers <- new.env()
Explanations$helpers$return_blank_ggplot <- function() return(ggplot2::ggplot() + ggplot2::geom_blank())

