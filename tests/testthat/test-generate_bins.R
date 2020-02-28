context("unit test for generate_bins")

test_that("generate_bins works", {
    set.seed(2223)
    expect_length(generate_bins(x = runif(100), n_bins = 10), 10 + 1)
})
