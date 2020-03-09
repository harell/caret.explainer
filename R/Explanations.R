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
        #' @references \url{https://modeloriented.github.io/iBreakDown/reference/break_down.html}
        plot_break_down = function(new_observation, ...) Explanations$iBreakDown$plot_break_down(private, new_observation, ...),

        # ingredients plots ----------------------------------------------------
        #' @inherit ingredients::ceteris_paribus description
        #' @param ... parameters passed to \link[ingredients]{ceteris_paribus}.
        #' @references \url{https://modeloriented.github.io/ingredients/reference/ceteris_paribus.html}
        plot_ceteris_paribus = function(new_observation, variables, ...) Explanations$ingredients$plot_ceteris_paribus(private, new_observation, variables, ...)
    ),
    private = list(DALEX = list())
)

# {iBreakDown} Methods ----------------------------------------------------
Explanations$iBreakDown <- new.env()
Explanations$iBreakDown$plot_break_down <- function(private, new_observation, ...){
    # Helpers
    return_no_obs_ggplot <- Explanations$helpers$return_no_obs_ggplot
    DALEX_ylim <- Explanations$helpers$DALEX_ylim

    # NULL object
    if(missing(new_observation)) return(return_no_obs_ggplot())
    if(is.null(new_observation)) return(return_no_obs_ggplot())

    # Plot
    explainer <- private$DALEX[[1]]
    args <- list(x = explainer, new_observation = new_observation)
    args <- purrr::list_modify(args, !!!list(...))

    break_down <- do.call(iBreakDown::break_down, args)

    suppressMessages({
        ggplot <-
            plot(break_down) +
            ggplot2::scale_y_continuous(
                breaks = scales::pretty_breaks(n = 10),
                limits = DALEX_ylim(explainer)
            )
    })

    return(ggplot)
}

# {ingredients} Methods ---------------------------------------------------
Explanations$ingredients <- new.env()
Explanations$ingredients$plot_ceteris_paribus <- function(private, new_observation, variables, ...){
    # Helpers
    return_no_obs_ggplot <- Explanations$helpers$return_no_obs_ggplot
    return_no_vars_ggplot <- Explanations$helpers$return_no_vars_ggplot
    DALEX_ylim <- Explanations$helpers$DALEX_ylim

    # NULL object
    if(missing(new_observation)) return(return_no_obs_ggplot())
    if(is.null(new_observation)) return(return_no_obs_ggplot())
    if(missing(variables)) return(return_no_vars_ggplot())
    if(is.null(variables)) return(return_no_vars_ggplot())

    # Plot
    explainer <- private$DALEX[[1]]
    args <- list(x = explainer, new_observation = new_observation, variables = variables)
    args <- purrr::list_modify(args, !!!list(...))

    ceteris_paribus <- do.call(ingredients::ceteris_paribus, args)

    suppressMessages({
        ggplot <-
            plot(ceteris_paribus) +
            ingredients::show_rugs(ceteris_paribus, variables = args$variables, sides = "bl", color = "red") +
            ingredients::show_observations(ceteris_paribus, variables = args$variables) +
            ggplot2::theme_bw()
    })

    return(ggplot)
}

# Helpers -----------------------------------------------------------------
Explanations$helpers <- new.env()
Explanations$helpers$return_no_vars_ggplot <- function() Explanations$helpers$return_blank_ggplot() + ggplot2::geom_text(ggplot2::aes(0,0), label = "Choose variables to analyse")
Explanations$helpers$return_no_obs_ggplot <- function() Explanations$helpers$return_blank_ggplot() + ggplot2::geom_text(ggplot2::aes(0,0), label = "Choose an observation to analyse")
Explanations$helpers$return_blank_ggplot <- function() return(ggplot2::ggplot() + ggplot2::geom_blank() + ggplot2::theme_void())
Explanations$helpers$DALEX_ylim <- function(explainer) range(explainer$y_hat, na.rm = TRUE)
