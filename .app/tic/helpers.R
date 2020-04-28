invisible(sapply(list.files("./.app/tic", "^step_", full.names = TRUE), source))

# high level steps --------------------------------------------------------
build_steps <- function(stage){
    stage %>%
        add_step(step_message(c(sep(), "\n## Build", sep()))) %>%
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
        add_step(step_message(c(sep(), "\n## Test: Unit-Tests", sep()))) %>%
        add_code_step(devtools::load_all(export_all = FALSE)) %>%
        add_code_step(testthat::test_dir("./tests/testthat", stop_on_failure = TRUE))
}

component_test_steps <- function(stage){
    if(dir.exists("./tests/component-tests"))
        stage <-
            stage %>%
            add_step(step_message(c(sep(), "\n## Test: Component-Tests", sep()))) %>%
            add_code_step(devtools::load_all(export_all = FALSE)) %>%
            add_code_step(testthat::test_dir("./tests/component-tests", stop_on_failure = TRUE))
    return(stage)
}

deploy_website <- function(stage){
    stage %>%
        add_step(step_message(c(sep(), "\n## Deploy Website", sep()))) %>%
        add_code_step(covr::codecov(quiet = FALSE)) %>%
        add_step(step_build_pkgdown())
}

deploy_shiny <- function(stage){
    stage %>%
        add_step(step_message(c(sep(), "\n## Deploy Shiny App", sep()))) %>%
        add_step(step_install_cran("rsconnect")) %>%
        add_step(step_deploy_shiny())
}

# branches wrappers -------------------------------------------------------
ci_is_gitlab <- function() identical(Sys.getenv("CI_SERVER_NAME"), "GitLab")
ci_get_branch <- function() if(ci_is_gitlab()) Sys.getenv("CI_COMMIT_REF_NAME") else tic::ci_get_branch()
is_master_branch <- function() "master" %in% ci_get_branch()
is_develop_branch <- function() "develop" %in% ci_get_branch()
is_feature_branch <- function() grepl("feature", ci_get_branch())
is_hotfix_branch <- function() grepl("hotfix", ci_get_branch())
is_release_branch <- function() grepl("release", ci_get_branch())

# helper functions --------------------------------------------------------
install_deps <- function() remotes::install_deps(dependencies = getOption("dependencies"), build = getOption("build"), quiet = TRUE)
ci_get_job_name <- function() tolower(paste0(Sys.getenv("TRAVIS_JOB_NAME"), Sys.getenv("APPVEYOR_JOB_NAME")))
sep <- function() paste0("\n", paste0(rep("#", 80), collapse = ""))

