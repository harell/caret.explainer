invisible(sapply(list.files("./AppData/tic", "^step_", full.names = TRUE), source))

# high level steps --------------------------------------------------------
build_steps <- function(stage){
    stage %>%
        add_step(step_message(c(sep(), "\n## Build\n", sep()))) %>%
        add_code_step(devtools::document(quiet = TRUE)) %>%
        add_step(step_rcmdcheck(error_on = "error"))
}

test_suite_steps <- function(stage){
    stage %>%
        unit_test_steps() %>%
        component_test_steps()
}

unit_test_steps <- function(stage){
    stage %>%
        add_step(step_message(c(sep(), "\n## Test: Unit-Tests\n", sep()))) %>%
        add_code_step(devtools::load_all(export_all = FALSE)) %>%
        add_code_step(testthat::test_dir("./tests/testthat", stop_on_failure = TRUE))
}

component_test_steps <- function(stage){
    stage %>%
        add_step(step_message(c(sep(), "\n## Test: Component-Tests\n", sep()))) %>%
        add_code_step(devtools::load_all(export_all = FALSE)) %>%
        add_code_step(testthat::test_dir("./tests/component-tests", stop_on_failure = TRUE))
}

deploy_website <- function(stage){
    stage %>%
        add_step(step_message(c(sep(), "\n## Deploy Website\n", sep()))) %>%
        add_code_step(covr::codecov(quiet = FALSE)) %>%
        add_step(step_build_pkgdown())
}

deploy_shiny <- function(stage){
    stage %>%
        add_step(step_message(c(sep(), "\n## Deploy Shiny App\n", sep()))) %>%
        add_step(step_deploy_shiny())
}

# branches wrappers -------------------------------------------------------
is_master_branch <- function() "master" %in% ci_get_branch()
is_develop_branch <- function() "develop" %in% ci_get_branch()
is_feature_branch <- function() grepl("feature", ci_get_branch())
is_hotfix_branch <- function() grepl("hotfix", ci_get_branch())
is_release_branch <- function() grepl("release", ci_get_branch())

# helper functions --------------------------------------------------------
ci_get_job_name <- function() tolower(paste0(Sys.getenv("TRAVIS_JOB_NAME"), Sys.getenv("APPVEYOR_JOB_NAME")))
sep <- function() paste0("\n", paste0(rep("#", 80), collapse = ""))

