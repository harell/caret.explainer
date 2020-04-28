activate <- function(){
  # Setup
  if(!"renv" %in% rownames(utils::installed.packages())) utils::install.packages("renv", dependencies = getOption("dependencies"))
  options(
    renv.lockfile = "./.app/renv/renv.lock",
    renv.consent = TRUE,
    renv.settings = list(
      ignored.packages = c("R", utils::installed.packages(priority = c("base", "recommended"))[,1]),
      snapshot.type = ifelse(packageVersion("renv") > "0.9.3", "explicit", "packrat"),
      auto.snapshot = FALSE,
      package.dependency.fields = getOption("dependencies", TRUE),
      vcs.ignore.library = TRUE,
      use.cache = TRUE
    )
  )

  # Helpers
  snapshot <- function()
    renv::snapshot(
      lockfile = getOption("renv.lockfile"),
      type = getOption("snapshot.type"),
      confirm = !getOption("renv.consent", FALSE)
    )

  restore <- function()
    renv::restore(
      lockfile = getOption("renv.lockfile"),
      confirm = !getOption("renv.consent", FALSE)
    )

  # Programming Logic
  if(isFALSE(file.exists(getOption("renv.lockfile")))) {
    message("Creating {renv} lockfile")
    snapshot()
  } else if (isTRUE(as.logical(Sys.getenv("RENV_ACTIVATED")))) {
    message("Updating {renv} lockfile")
    snapshot()
  } else { # load lockfile
    message("Restoring {renv} lockfile")
    restore()
  }

  # Return
  Sys.setenv(RENV_ACTIVATED = TRUE)
  invisible()
}
