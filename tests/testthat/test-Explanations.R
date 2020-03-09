context("unit test for Explanations object")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    test_env$mc <- MockModelDecomposition$new() %>% ModelComposition$new()
})

# General -----------------------------------------------------------------
test_that("Explanations$new works", {
    attach(test_env)
    expect_silent(explanations <- Explanations$new(test_env$mc))
    expect_class(explanations, "Explanations")
    test_env$explanations <- explanations
})

# iBreakDown plots --------------------------------------------------------
test_that("ModelComposition$plot_break_down works", {
    attach(test_env)
    explanations <- test_env$explanations
    new_observation <- test_env$mc$DALEX$data[1, ]

    expect_class(blank_plot <- explanations$plot_break_down(), "ggplot")
    expect_null(blank_plot$data %>% nrow())
    expect_equal(explanations$plot_break_down(new_observation = NULL), blank_plot)

    expect_class(breakdown_plot <- explanations$plot_break_down(new_observation = new_observation), "ggplot")
    expect_not_null(breakdown_plot$data %>% nrow())
})

# ingredients Plots -------------------------------------------------------
test_that("ModelComposition$plot_break_down works", {
    attach(test_env)
    explanations <- test_env$explanations
    new_observation <- test_env$mc$DALEX$data[1, ]

    expect_class(blank_plot <- explanations$plot_ceteris_paribus(), "ggplot")
})

