test_that("non-existing paths fail", {
  expect_error(open_wd(file.path(tempdir(), "does_not_exist")), "does not exist")
})

