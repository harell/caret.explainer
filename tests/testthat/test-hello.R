context("unit test for hello")

test_that("hello works", {
  expect_message(hello(), "Hello, world!")
})
