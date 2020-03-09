context("unit test for instantiate_explainer")

test_that("instantiate_explainer works", {
    expect_silent(explanations <- instantiate_explainer(caret$model))
    expect_class(explanations, "Explanations")
})
