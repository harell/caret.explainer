source(list.files(pattern = "testthat-helpers.R$", recursive = TRUE, full.names = TRUE))
package_name <- testthat$get_package_name()
library(testthat)
library(package_name, character.only = TRUE)
test_check(package_name)
