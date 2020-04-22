context("component test for Caret Model Explanations")

# Classification Models ---------------------------------------------------
test_that("caret glm model", {
    expect_class(caret_train <- generate_glm_caret_model()$model, "train")
    expect_silent(interim_obj <- caret_train %>% CaretModelDecomposition$new())
    expect_class(new_observation <- interim_obj$data[1, ], "data.frame")
    expect_silent(interim_obj <- interim_obj %>% ModelComposition$new())
    expect_silent(interim_obj <- interim_obj %>% Explanations$new())
    expect_class(interim_obj$plot_break_down(new_observation = new_observation), "ggplot")
})

# Regression Models -------------------------------------------------------
test_that("caret lm model", {
    expect_class(caret_train <- generate_lm_caret_model()$model, "train")
    expect_silent(interim_obj <- caret_train %>% CaretModelDecomposition$new())
    expect_class(new_observation <- interim_obj$data[1, ], "data.frame")
    expect_silent(interim_obj <- interim_obj %>% ModelComposition$new())
    expect_silent(interim_obj <- interim_obj %>% Explanations$new())
    expect_class(interim_obj$plot_break_down(new_observation = new_observation), "ggplot")
})

test_that("caret xgboost model", {
    skip_if_not_installed("xgboost")
    expect_class(caret_train <- generate_xgboost_caret_model()$model, "train")
    expect_silent(interim_obj <- caret_train %>% CaretModelDecomposition$new())
    expect_class(new_observation <- interim_obj$data[1, ], "data.frame")
    expect_silent(interim_obj <- interim_obj %>% ModelComposition$new())
    expect_silent(interim_obj <- interim_obj %>% Explanations$new())
    expect_class(interim_obj$plot_break_down(new_observation = new_observation), "ggplot")
})
