#' Job Lifecycle
#'
#' 1. before_script
#' 2. script
#' 3. after_success or after_failure
#' 4. OPTIONAL before_deploy
#' 5. OPTIONAL deploy
#' 6. OPTIONAL after_deploy
#'
library(tic, warn.conflicts = FALSE)
source("./AppData/tic/helpers.R")

# Stage: Before Script ----------------------------------------------------
get_stage("before_script") %>%
    add_code_step(remotes::install_deps(dependencies = "Imports", build = FALSE, quiet = TRUE)) %>%
    add_code_step(try(devtools::uninstall(), silent = TRUE))

# Stage: Script -----------------------------------------------------------
if(is_master_branch() | is_hotfix_branch()){
    get_stage("script") %>% build_steps() %>% test_steps() %>% deploy_website() %>% deploy_shiny()

} else if (is_develop_branch() | is_release_branch()){
    get_stage("script") %>% build_steps() %>% test_steps()

} else if (is_feature_branch()){
    get_stage("script") %>% test_steps()

}

# Stage: After Success ----------------------------------------------------
get_stage("after_success") %>%
    add_code_step(print(covr::package_coverage(type = "tests")))

# Stage: After Failure ----------------------------------------------------
get_stage("after_failure") %>%
    add_code_step(print(sessioninfo::session_info(include_base = FALSE)))

# Stage: Before Deploy ----------------------------------------------------
get_stage("before_deploy")
if(is_master_branch()){
    get_stage("before_deploy") %>%
        add_code_step(rmarkdown::render("README.Rmd")) %>% # 1st time adds badges tags
        add_code_step(rmarkdown::render("README.Rmd")) # 2nd shows badges
}

# Stage: Deploy -----------------------------------------------------------
get_stage("deploy") # tic deploy is disabled at config.yml

# Stage: After Deploy -----------------------------------------------------
get_stage("after_deploy") %>%
    add_code_step(print(rsconnect::appDependencies(getOption("path_dashboard"))))
