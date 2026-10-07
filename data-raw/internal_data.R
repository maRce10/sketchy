# Builds the package data from the files in 'examples/':
#  - R/sysdata.rda (internal_files): templates written by make_compendium()
#  - data/compendiums.rda: adds/updates the 'github_site' format
# Run from the package root: source("data-raw/internal_data.R")

read_example <- function(...) readLines(file.path("examples", ...), warn = FALSE)

## internal files ####
internal_files <- list(
  manuscript_template = read_example("manuscript_template.Rmd"),
  apa.csl = read_example("apa.csl"),
  readme_template = read_example("README_template.Rmd"),
  analysis_template_rmarkdown = read_example("analysis_template_rmarkdown.Rmd"),
  analysis_template_quarto = read_example("analysis_template_quarto.qmd"),
  rmd_css = read_example("rmd.css"),
  qmd_css = read_example("qmd.css"),
  example_library = read_example("example_library.bib"),
  # github_site format (based on https://github.com/maRce10/suwo_publication)
  site_workflow = read_example("github_site", "publish.yml"),
  site_quarto_yml = read_example("github_site", "_quarto.yml"),
  site_index = read_example("github_site", "index.qmd"),
  site_fig_download = read_example("github_site", "fig_download.html"),
  site_qmd_css = read_example("github_site", "qmd.css"),
  site_gitignore = read_example("github_site", "gitignore"),
  site_scripts_gitignore = read_example("github_site", "scripts_gitignore"),
  site_scripts_rprofile = read_example("github_site", "scripts_Rprofile")
)

usethis::use_data(internal_files, internal = TRUE, overwrite = TRUE)

## compendiums ####
load("data/compendiums.rda")

github_site_comments <- c(
  ".github" = "GitHub settings",
  ".github/workflows" = "GitHub action that renders and publishes the site",
  "archive" = "files no longer used (see spot_unused_files())",
  "data" = "",
  "data/raw" = "original data",
  "data/processed" = "modified/rearranged data",
  "manuscript" = "manuscript/poster files",
  "output" = "all non-data products of data analysis",
  "scripts" = "quarto website: code + reports (index.qmd is the home page)"
)

compendiums$github_site <- list(
  skeleton = names(github_site_comments),
  comments = github_site_comments,
  info = "sketchy's own design: quarto website published on GitHub Pages (e.g. https://github.com/maRce10/suwo_publication)"
)

stopifnot(all(vapply(compendiums, function(x) identical(x$skeleton, names(x$comments)), logical(1))))

usethis::use_data(compendiums, overwrite = TRUE)
