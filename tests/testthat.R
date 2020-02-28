source(list.files(pattern = "testthat-helpers.R$", recursive = TRUE, full.names = TRUE))
library(testthat)
library(testthat$get_package_name(), character.only = TRUE)
test_check(testthat$get_package_name())
