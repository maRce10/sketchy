test_that("installed packages are loaded and reported", {
  res <- load_packages("utils", quiet = TRUE)
  expect_identical(res, c(utils = TRUE))
})

test_that("invalid repository names fail early", {
  expect_error(load_packages(c(cranz = "utils")), "invalid repository")
})

test_that("github packages must include the user name", {
  expect_error(load_packages(c(github = "Rraven")), "user/package")
})

test_that("'quite' is deprecated but still works", {
  expect_warning(res <- load_packages("utils", quite = TRUE), "deprecated")
  expect_true(res[["utils"]])
})

test_that("pak specifications and repository names are converted correctly", {
  pkgs <- getFromNamespace(".pkg_specs", "sketchy")(c(
    "kableExtra", "bioc::ggtree", "maRce10/Rraven", "maRce10/warbleR@v1.1.30",
    bioconductor = "Biostrings", github = "user/pkg1", gitlab = "user/pkg2", bitbucket = "user/pkg3"
  ))

  expect_identical(pkgs$spec, c(
    "kableExtra", "bioc::ggtree", "maRce10/Rraven", "maRce10/warbleR@v1.1.30",
    "bioc::Biostrings", "user/pkg1", "gitlab::user/pkg2", "git::https://bitbucket.org/user/pkg3.git"
  ))
  expect_identical(pkgs$name, c(
    "kableExtra", "ggtree", "Rraven", "warbleR", "Biostrings", "pkg1", "pkg2", "pkg3"
  ))
})

test_that("only missing packages are sent to pak", {
  skip_if_not_installed("pak")
  sent <- NULL
  local_mocked_bindings(
    pkg_install = function(pkg, ...) {
      sent <<- c(sent, pkg)
      stop("no network")
    },
    .package = "pak"
  )

  expect_message(
    res <- load_packages(c("utils", "user/notARealPackage123", "bioc::notARealPackage456"), quiet = TRUE),
    "notARealPackage123, notARealPackage456"
  )
  expect_identical(res, c(utils = TRUE, notARealPackage123 = FALSE, notARealPackage456 = FALSE))
  # tried together first and then one by one
  expect_identical(sent, c("user/notARealPackage123", "bioc::notARealPackage456",
                           "user/notARealPackage123", "bioc::notARealPackage456"))
})

test_that("packages are loaded after a successful install", {
  skip_if_not_installed("pak")
  local_mocked_bindings(pkg_install = function(pkg, ...) invisible(NULL), .package = "pak")
  # pretend 'tools' is missing so it goes through the install step
  local_mocked_bindings(requireNamespace = function(package, ...) package != "tools", .package = "base")

  expect_identical(load_packages("tools", quiet = TRUE), c(tools = TRUE))
})
