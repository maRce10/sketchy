# Changelog

## sketchy 1.0.7

#### NEW FEATURES

- New compendium format “github_site” in
  [`make_compendium()`](https://marce10.github.io/brmsish/reference/make_compendium.md):
  a quarto website (in ‘scripts/’) that is rendered and published on
  GitHub Pages by a GitHub action (‘.github/workflows/publish.yml’). It
  also includes ‘manuscript’ and ‘archive’ folders. With `renv = TRUE`
  the GitHub action installs the packages in ‘renv.lock’, so pages don’t
  need to be rendered locally before publishing

#### MINOR IMPROVEMENTS

- [`spot_unused_files()`](https://marce10.github.io/brmsish/reference/spot_unused_files.md)
  can remove empty folders

- [`load_packages()`](https://marce10.github.io/brmsish/reference/load_packages.md)
  now installs packages with ‘pak’ (instead of ‘remotes’, no longer a
  dependency), accepting pak package specifications
  (e.g. `"bioc::ggtree"`, `"user/repo@v1.0"`) in addition to the
  vector-name syntax. It gains argument `quiet` (`quite` is deprecated),
  returns (invisibly) which packages were loaded and validates
  repository names

- The Rmarkdown analysis template adds copy buttons to code blocks with
  a small script, so ‘xaringanExtra’ is no longer needed (and no longer
  a dependency of sketchy)

- [`load_packages()`](https://marce10.github.io/brmsish/reference/load_packages.md)
  is superseded: it keeps working, but the docs recommend
  [`pak::pkg_install()`](https://pak.r-lib.org/reference/pkg_install.html) +
  [`library()`](https://rdrr.io/r/base/library.html) (no dependency on
  ‘sketchy’) and `make_compendium(renv = TRUE)`

- Analysis and manuscript templates install/load packages with ‘pak’
  (the manuscript template no longer removes packages that fail to
  load). Packages are loaded before setting chunk options, so options
  that need packages (e.g. ‘tidy’ needs ‘formatR’) work on first render
  and base R, so projects no longer depend on ‘sketchy’ and stop with a
  clear message listing the packages that could not be installed

- [`make_compendium()`](https://marce10.github.io/brmsish/reference/make_compendium.md)
  gains argument `renv` to initialize
  [renv](https://rstudio.github.io/renv/) (records package versions in
  ‘renv.lock’). Argument `packrat` is deprecated (packrat has been
  superseded by renv) and now initializes renv; ‘packrat’ is no longer a
  dependency

- [`spot_unused_files()`](https://marce10.github.io/brmsish/reference/spot_unused_files.md)
  archives files into “archive” (within ‘path’) keeping their sub-folder
  structure

- [`print_skeleton()`](https://marce10.github.io/brmsish/reference/print_skeleton.md)
  now uses [`cli::tree()`](https://cli.r-lib.org/reference/tree.html) to
  draw the folder tree, accepts comments for only some folders (named
  vector) and returns the tree invisibly. When `folders` is supplied,
  `path` is used as the label of the root folder Package no longer
  depends on `stringi`

- Package citation now in `citation("sketchy")` (inst/CITATION), always
  matching the installed version

- Tests added (testthat)

#### BUG FIXES

- `make_compendium(format = "sketchy")` wrote an empty Rmarkdown
  analysis template (internal data was out of date). Internal data can
  now be rebuilt from ‘examples/’ with ‘data-raw/internal_data.R’

- [`make_compendium()`](https://marce10.github.io/brmsish/reference/make_compendium.md)
  failed when called as
  [`sketchy::make_compendium()`](https://marce10.github.io/brmsish/reference/make_compendium.md)
  without attaching the package

- [`print_skeleton()`](https://marce10.github.io/brmsish/reference/print_skeleton.md)
  and `make_compendium(clone = ...)` ignored any folder starting with
  ‘.git’ (e.g. ‘.github’)

- [`load_packages()`](https://marce10.github.io/brmsish/reference/load_packages.md)
  no longer uninstalls packages that fail to load, passes ‘quiet’
  correctly to ‘remotes’ and only reports packages that failed

- [`add_to_gitignore()`](https://marce10.github.io/brmsish/reference/add_to_gitignore.md)
  keeps the relative path of files in sub-folders (instead of only the
  file name), prints the right message when only ‘extension’ is supplied
  and no longer treats ‘.gitignore’ entries as regular expressions

- [`spot_unused_files()`](https://marce10.github.io/brmsish/reference/spot_unused_files.md)
  archived files relative to the working directory instead of ‘path’,
  and `remove.empty = TRUE` could delete empty folders inside ‘.git’

- [`make_compendium()`](https://marce10.github.io/brmsish/reference/make_compendium.md)
  could pick up a ‘comments_vector’ object from the global environment
  and failed when cloning with the default ‘format’

- [`open_wd()`](https://marce10.github.io/brmsish/reference/open_wd.md)
  failed with paths containing spaces

- Fixed examples in
  [`print_skeleton()`](https://marce10.github.io/brmsish/reference/print_skeleton.md)
  and
  [`check_urls()`](https://marce10.github.io/brmsish/reference/check_urls.md)

## sketchy 1.0.6

#### MINOR IMPROVEMENTS

- Name of project is added to the subtitle of Rmarkdown/quarto files in
  [`make_compendium()`](https://marce10.github.io/brmsish/reference/make_compendium.md)

## sketchy 1.0.5

CRAN release: 2025-01-16

#### BUG FIXES

- Problem with directory path in Windows OS in
  [`add_to_gitignore()`](https://marce10.github.io/brmsish/reference/add_to_gitignore.md)

## sketchy 1.0.4

CRAN release: 2024-09-02

#### NEW FEATURES

- New function
  [`spot_unused_files()`](https://marce10.github.io/brmsish/reference/spot_unused_files.md)
  to spot/remove unused files in a project directory

- New function
  [`open_wd()`](https://marce10.github.io/brmsish/reference/open_wd.md)
  to open the current working directory

## sketchy 1.0.3

CRAN release: 2024-04-20

#### MINOR IMPROVEMENTS

- Remove ‘comments’ argument in
  [`make_compendium()`](https://marce10.github.io/brmsish/reference/make_compendium.md)

#### NEW FEATURES

- New function
  [`check_urls()`](https://marce10.github.io/brmsish/reference/check_urls.md)
  to check url addresses

## sketchy 1.0.0

- First release
