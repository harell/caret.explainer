# Objects defined here are:
# 1. visible across all sessions; and
# 2. visible to the code in both the server and ui objects.

# Context Object ----------------------------------------------------------
context <- new.env()

context$config <- new.env()
Dashboard$utils$yaml2env(input = "config.yml", envir = context$config)
