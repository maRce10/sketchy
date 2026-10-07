test_that("built-in format creates folders and templates", {
  dir <- local_project()

  out <- capture.output(make_compendium(name = "comp", path = dir, format = "basic", readme = FALSE))

  expect_true(all(dir.exists(file.path(dir, "comp", compendiums$basic$skeleton))))
  expect_true(file.exists(file.path(dir, "comp", "manuscript", "manuscript.Rmd")))
})

test_that("a global 'comments_vector' object is not picked up", {
  dir <- local_project()
  assign("comments_vector", c(a = "bad"), envir = globalenv())
  on.exit(rm("comments_vector", envir = globalenv()))

  expect_no_error(capture.output(
    make_compendium(name = "comp", path = dir, format = c("f1", "f1/s1"), readme = FALSE)
  ))
})

test_that("cloning with the default format doesn't use built-in comments", {
  dir <- local_project()
  dir.create(file.path(dir, "src", "a", "b"), recursive = TRUE)

  expect_no_error(capture.output(
    make_compendium(name = "comp", path = dir, clone = file.path(dir, "src"), readme = FALSE)
  ))
  expect_true(dir.exists(file.path(dir, "comp", "a", "b")))
})

test_that("existing directories are not reused unless force = TRUE", {
  dir <- local_project()
  dir.create(file.path(dir, "comp"))

  expect_error(capture.output(make_compendium(name = "comp", path = dir, readme = FALSE)), "already exists")
  expect_no_error(capture.output(make_compendium(name = "comp", path = dir, readme = FALSE, force = TRUE)))
})

test_that("github_site format creates the quarto site and github workflow", {
  dir <- local_project()

  out <- capture.output(make_compendium(name = "my_site", path = dir, format = "github_site", readme = FALSE))
  site <- file.path(dir, "my_site")

  expect_true(all(dir.exists(file.path(site, c("archive", "manuscript", ".github/workflows")))))
  expect_true(all(file.exists(file.path(site, c(
    ".github/workflows/publish.yml", ".gitignore",
    "scripts/_quarto.yml", "scripts/index.qmd", "scripts/analysis.qmd",
    "scripts/qmd.css", "scripts/fig_download.html", "scripts/.gitignore",
    "manuscript/manuscript.Rmd"
  )))))

  quarto_yml <- readLines(file.path(site, "scripts", "_quarto.yml"))
  expect_true(any(grepl('title: "my_site"', quarto_yml, fixed = TRUE)))
  expect_false(any(grepl("PROJECT_NAME", quarto_yml, fixed = TRUE)))
  expect_identical(readLines(file.path(site, "scripts", "analysis.qmd"))[3], "subtitle: my_site")

  # .github is shown in the printed skeleton
  expect_true(any(grepl(".github/", out, fixed = TRUE)))
  expect_true(any(grepl("Settings > Pages", out, fixed = TRUE)))
})

test_that("github_site doesn't overwrite existing files", {
  dir <- local_project()
  dir.create(file.path(dir, "my_site", "scripts"), recursive = TRUE)
  writeLines("my own index", file.path(dir, "my_site", "scripts", "index.qmd"))

  out <- capture.output(make_compendium(name = "my_site", path = dir, format = "github_site", readme = FALSE, force = TRUE))

  expect_identical(readLines(file.path(dir, "my_site", "scripts", "index.qmd")), "my own index")
})

test_that("sketchy format writes complete analysis templates", {
  dir <- local_project()

  out <- capture.output(make_compendium(name = "comp", path = dir, format = "sketchy", readme = FALSE))
  rmd <- readLines(file.path(dir, "comp", "scripts", "analysis_template_rmarkdown.Rmd"))

  expect_gt(length(rmd), 10)
  expect_false(any(rmd == "NA"))
  expect_identical(rmd[3], "subtitle: comp")
})

test_that("internal templates are in sync with 'examples/' (run data-raw/internal_data.R if not)", {
  examples_dir <- test_path("..", "..", "examples")
  skip_if_not(dir.exists(examples_dir))

  internal_files <- getFromNamespace("internal_files", "sketchy")
  expect_identical(internal_files$analysis_template_quarto, readLines(file.path(examples_dir, "analysis_template_quarto.qmd"), warn = FALSE))
  expect_identical(internal_files$site_workflow, readLines(file.path(examples_dir, "github_site", "publish.yml"), warn = FALSE))
  expect_identical(internal_files$site_quarto_yml, readLines(file.path(examples_dir, "github_site", "_quarto.yml"), warn = FALSE))
})

test_that("make_compendium() works without attaching sketchy", {
  dir <- local_project()
  script <- sprintf(
    'invisible(capture.output(sketchy::make_compendium("comp", "%s", format = "basic", readme = FALSE))); cat(dir.exists(file.path("%s", "comp", "data", "raw")))',
    dir, dir
  )
  skip_if(!nzchar(system.file(package = "sketchy")), "sketchy not installed")
  out <- system2(file.path(R.home("bin"), "Rscript"), c("-e", shQuote(script)), stdout = TRUE, stderr = TRUE)
  expect_identical(tail(out, 1), "TRUE")
})

test_that("renv = TRUE initializes renv without activating it in this session", {
  skip_if_not_installed("renv")
  skip_on_cran()
  dir <- local_project()
  lib_paths <- .libPaths()

  out <- capture.output(make_compendium(name = "comp", path = dir, readme = FALSE, renv = TRUE))

  expect_true(file.exists(file.path(dir, "comp", "renv.lock")))
  expect_true(file.exists(file.path(dir, "comp", ".Rprofile")))
  expect_identical(.libPaths(), lib_paths)
  # renv internal folders are not printed
  expect_true(any(grepl("renv/", out, fixed = TRUE)))
  expect_false(any(grepl("library/", out, fixed = TRUE)))
})

test_that("packrat is deprecated and uses renv instead", {
  skip_if_not_installed("renv")
  skip_on_cran()
  dir <- local_project()

  expect_warning(
    capture.output(make_compendium(name = "comp", path = dir, readme = FALSE, packrat = TRUE)),
    "deprecated"
  )
  expect_true(file.exists(file.path(dir, "comp", "renv.lock")))
  expect_false(dir.exists(file.path(dir, "comp", "packrat")))
})

test_that("github_site with renv activates renv from 'scripts/' and records all packages", {
  skip_if_not_installed("renv")
  skip_on_cran()
  dir <- local_project()

  out <- capture.output(make_compendium(name = "site", path = dir, format = "github_site", readme = FALSE, renv = TRUE))
  site <- file.path(dir, "site")

  expect_true(file.exists(file.path(site, "scripts", ".Rprofile")))
  expect_identical(renv::settings$snapshot.type(project = site), "all")
  expect_true(any(grepl("renv.lock", out, fixed = TRUE)))
})

test_that("github_site without renv has no scripts/.Rprofile", {
  dir <- local_project()

  out <- capture.output(make_compendium(name = "site", path = dir, format = "github_site", readme = FALSE))

  expect_false(file.exists(file.path(dir, "site", "scripts", ".Rprofile")))
  expect_true(any(grepl("commit the 'scripts/_freeze' folder", out, fixed = TRUE)))
})

test_that("site workflow installs renv packages only when renv.lock exists", {
  internal_files <- getFromNamespace("internal_files", "sketchy")
  workflow <- internal_files$site_workflow

  expect_true(any(grepl("r-lib/actions/setup-renv", workflow, fixed = TRUE)))
  expect_true(any(grepl("if: hashFiles('renv.lock') != ''", workflow, fixed = TRUE)))
  expect_true(any(grepl("if: hashFiles('renv.lock') == ''", workflow, fixed = TRUE)))
})
