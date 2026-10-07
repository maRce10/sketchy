# create a fresh empty project directory that is removed after the test
local_project <- function(env = parent.frame()) {
  dir <- tempfile("sketchy_test_")
  dir.create(dir)
  withr::defer(unlink(dir, recursive = TRUE), envir = env)
  normalizePath(dir, winslash = "/")
}
