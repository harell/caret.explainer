renv <- new.env()

# high level functions ----------------------------------------------------
restore <- function(){
  renv$setup()

  if(isFALSE(file.exists(getOption("renv.lockfile")))) {
    message("Creating {renv} lockfile")
    renv$snapshot()
  } else { # load lockfile
    message("Restoring {renv} lockfile")
    renv$restore()
  }
}

update <- function(){
  renv$setup()
  message("Updating {renv} lockfile")
  unlink(getOption("renv.lockfile"), recursive = TRUE, force = TRUE)
  renv$snapshot()
}

# medium level functions --------------------------------------------------
renv$snapshot <- function(){
  renv::snapshot(
    lockfile = getOption("renv.lockfile"),
    type = getOption("snapshot.type"),
    confirm = !getOption("renv.consent", FALSE)
  )
}

renv$restore <- function(){
  unload_namespace <- function(ns) try(base::unloadNamespace(ns), silent = !TRUE)
  attach_namespace <- function(ns) try(base::attachNamespace(ns), silent = !TRUE)

  system_packages <- unname(utils::installed.packages(priority = c("base", "recommended"))[,1])
  attached_packages <- setdiff(.packages(), system_packages)
  invisible(sapply(attached_packages, unload_namespace))

  tryCatch(
    renv::restore(
      lockfile = getOption("renv.lockfile"),
      confirm = !getOption("renv.consent", FALSE),
      clean = getOption("renv.clean")
    ),
    error = function(e) stop(e, "Try installing Rtools")
  )

  invisible(sapply(attached_packages, attach_namespace))
}

# low level functions -----------------------------------------------------
renv$setup <- function(){
  if(!"renv" %in% rownames(utils::installed.packages()))
    stop("renv is missing; You can install it by calling install.packages(\"renv\")")
  renv$options()
}

renv$options <- function(){
  system_packages <- unname(sort(utils::installed.packages(priority = c("base", "recommended"))[,1]))
  config_packages <- c("tic", "renv")

  options(
    renv.lockfile = "./.app/renv/renv.lock",
    renv.consent = TRUE,
    renv.clean = FALSE,
    renv.settings = list(
      ignored.packages = unique(c(config_packages, system_packages)),
      snapshot.type = ifelse(utils::packageVersion("renv") > "0.9.3", "explicit", "packrat"),
      auto.snapshot = FALSE,
      package.dependency.fields = getOption("dependencies", TRUE),
      vcs.ignore.library = TRUE,
      use.cache = TRUE
    )
  )
}
