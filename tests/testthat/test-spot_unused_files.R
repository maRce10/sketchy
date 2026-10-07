make_unused_project <- function(env = parent.frame()) {
  dir <- local_project(env)
  dir.create(file.path(dir, "scripts"))
  dir.create(file.path(dir, "data", "raw"), recursive = TRUE)
  dir.create(file.path(dir, "empty_folder"))
  dir.create(file.path(dir, ".git", "refs", "tags"), recursive = TRUE)
  writeLines('x <- read.csv("used.csv")', file.path(dir, "scripts", "analysis.R"))
  write.csv(iris, file.path(dir, "data", "raw", "used.csv"))
  write.csv(iris, file.path(dir, "data", "raw", "unused.csv"))
  dir
}

test_that("unused files are spotted", {
  dir <- make_unused_project()

  res <- spot_unused_files(path = dir)

  expect_identical(res$file.name, "unused.csv")
  expect_true(file.exists(file.path(dir, "data", "raw", "unused.csv")))
})

test_that("archive moves files into 'archive' within path, keeping sub-folders", {
  dir <- make_unused_project()
  old_wd <- setwd(tempdir())
  on.exit(setwd(old_wd))

  spot_unused_files(path = dir, archive = TRUE)

  expect_false(file.exists(file.path(dir, "data", "raw", "unused.csv")))
  expect_true(file.exists(file.path(dir, "archive", "data", "raw", "unused.csv")))
  expect_true(file.exists(file.path(dir, "data", "raw", "used.csv")))
  expect_false(dir.exists(file.path(tempdir(), "archive")))
  expect_false(dir.exists(file.path(tempdir(), "unused_files")))

  # archived files are not reported again
  expect_message(res <- spot_unused_files(path = dir), "All files are referenced")
  expect_null(res)
})

test_that("remove.empty keeps hidden folders such as .git", {
  dir <- make_unused_project()

  suppressMessages(capture.output(spot_unused_files(path = dir, remove.empty = TRUE)))

  expect_false(dir.exists(file.path(dir, "empty_folder")))
  expect_true(dir.exists(file.path(dir, ".git", "refs", "tags")))
  expect_true(dir.exists(dir))
})

test_that("ignore.folder excludes files", {
  dir <- make_unused_project()

  expect_message(
    res <- spot_unused_files(path = dir, ignore.folder = file.path(dir, "data")),
    "No files"
  )
  expect_null(res)
})
