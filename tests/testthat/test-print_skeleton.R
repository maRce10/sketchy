test_that("folder tree is printed", {
  dir <- local_project()
  dir.create(file.path(dir, "data", "raw"), recursive = TRUE)
  dir.create(file.path(dir, "scripts"))

  out <- capture.output(res <- print_skeleton(path = dir))

  expect_s3_class(res, "cli_tree")
  expect_identical(out[1], basename(dir))
  expect_true(any(grepl("data/", out, fixed = TRUE)))
  expect_true(any(grepl("raw/", out, fixed = TRUE)))
  expect_true(any(grepl("scripts/", out, fixed = TRUE)))
})

test_that("named comments can be added to some folders", {
  out <- capture.output(print_skeleton(
    path = "proj", folders = c("a/b", "c"), comments = c("a/b" = "a comment")
  ))

  expect_length(out, 4)
  expect_true(any(grepl("b/ # a comment", out, fixed = TRUE)))
  # missing parent folders are added
  expect_true(any(grepl("a/", out, fixed = TRUE)))
})

test_that("comments must match folders", {
  expect_error(
    print_skeleton(folders = c("a", "b"), comments = c(z = "x")),
    "counterpart"
  )
  expect_error(
    print_skeleton(folders = c("a", "b"), comments = "x"),
    "2 folders found"
  )
})

test_that("all built-in compendiums print with their comments", {
  for (format in names(compendiums)) {
    dir <- local_project()
    expect_no_error(capture.output(
      make_compendium(name = "comp", path = dir, format = format, readme = FALSE)
    ))
  }
})

test_that(".github is shown but .git is not", {
  dir <- local_project()
  dir.create(file.path(dir, ".git", "refs"), recursive = TRUE)
  dir.create(file.path(dir, ".github", "workflows"), recursive = TRUE)

  out <- capture.output(print_skeleton(path = dir))

  expect_true(any(grepl(".github/", out, fixed = TRUE)))
  expect_false(any(grepl("refs/", out, fixed = TRUE)))
})

test_that("with 'folders', 'path' is used as a label and not resolved", {
  out <- capture.output(print_skeleton(folders = c("a", "b")))
  expect_identical(out[1], ".")

  out <- capture.output(print_skeleton(path = "basic", folders = c("a", "b")))
  expect_identical(out[1], "basic")
})
