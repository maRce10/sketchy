test_that("files in sub-folders are added with their relative path", {
  dir <- local_project()
  dir.create(file.path(dir, "data", "raw"), recursive = TRUE)
  write.csv(iris, file.path(dir, "data", "raw", "iris.csv"))

  out <- capture.output(
    found <- add_to_gitignore(add.to.gitignore = TRUE, extension = "csv", path = dir)
  )

  expect_identical(found, "data/raw/iris.csv")
  expect_identical(readLines(file.path(dir, ".gitignore")), "data/raw/iris.csv")
})

test_that("extension-only search prints the extension message", {
  dir <- local_project()
  write.csv(iris, file.path(dir, "iris.csv"))

  out <- paste(capture.output(add_to_gitignore(extension = "csv", path = dir)), collapse = "\n")

  expect_match(out, "match(es) the extension:", fixed = TRUE)
  expect_no_match(out, "cutoff", fixed = TRUE)
})

test_that("cutoff filters by file size", {
  dir <- local_project()
  writeLines("small", file.path(dir, "small.txt"))
  writeBin(raw(2e6), file.path(dir, "big.bin"))

  out <- capture.output(found <- add_to_gitignore(cutoff = 1, path = dir))

  expect_identical(found, "big.bin")
})

test_that("existing entries are not duplicated and glob entries don't break matching", {
  dir <- local_project()
  writeLines(c("*.tmp", "/a.csv"), file.path(dir, ".gitignore"))
  write.csv(iris, file.path(dir, "a.csv"))
  write.csv(iris, file.path(dir, "b.csv"))

  out <- capture.output(add_to_gitignore(TRUE, extension = "csv", path = dir))

  expect_identical(readLines(file.path(dir, ".gitignore")), c("*.tmp", "/a.csv", "b.csv"))
})

test_that("either cutoff or extension is required", {
  expect_error(add_to_gitignore(path = tempdir()), "must be supplied")
})
