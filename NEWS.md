sketchy 1.0.7
=========================

### NEW FEATURES

* New compendium format "github_site" in `make_compendium()`: a quarto website (in 'scripts/') that is rendered and published on GitHub Pages by a GitHub action ('.github/workflows/publish.yml'). It also includes 'manuscript' and 'archive' folders. With `renv = TRUE` the GitHub action installs the packages in 'renv.lock', so pages don't need to be rendered locally before publishing

### MINOR IMPROVEMENTS

* `spot_unused_files()` can remove empty folders

* `load_packages()` now installs packages with 'pak' (instead of 'remotes', no longer a dependency), accepting pak package specifications (e.g. `"bioc::ggtree"`, `"user/repo@v1.0"`) in addition to the vector-name syntax. It gains argument `quiet` (`quite` is deprecated), returns (invisibly) which packages were loaded and validates repository names

* The Rmarkdown analysis template adds copy buttons to code blocks with a small script, so 'xaringanExtra' is no longer needed (and no longer a dependency of sketchy)

* `load_packages()` is superseded: it keeps working, but the docs recommend `pak::pkg_install()` + `library()` (no dependency on 'sketchy') and `make_compendium(renv = TRUE)`

* Analysis and manuscript templates install/load packages with 'pak' (the manuscript template no longer removes packages that fail to load). Packages are loaded before setting chunk options, so options that need packages (e.g. 'tidy' needs 'formatR') work on first render and base R, so projects no longer depend on 'sketchy' and stop with a clear message listing the packages that could not be installed

* `make_compendium()` gains argument `renv` to initialize [renv](https://rstudio.github.io/renv/) (records package versions in 'renv.lock'). Argument `packrat` is deprecated (packrat has been superseded by renv) and now initializes renv; 'packrat' is no longer a dependency

* `spot_unused_files()` archives files into "archive" (within 'path') keeping their sub-folder structure

* `print_skeleton()` now uses `cli::tree()` to draw the folder tree, accepts comments for only some folders (named vector) and returns the tree invisibly. When `folders` is supplied, `path` is used as the label of the root folder Package no longer depends on `stringi`

* Package citation now in `citation("sketchy")` (inst/CITATION), always matching the installed version

* Tests added (testthat)

* Name of project is added to the subtitle of Rmarkdown/quarto files in `make_compendium()`

### BUG FIXES

* `make_compendium(format = "sketchy")` wrote an empty Rmarkdown analysis template (internal data was out of date). Internal data can now be rebuilt from 'examples/' with 'data-raw/internal_data.R'

* `make_compendium()` failed when called as `sketchy::make_compendium()` without attaching the package

* `print_skeleton()` and `make_compendium(clone = ...)` ignored any folder starting with '.git' (e.g. '.github')

* `load_packages()` no longer uninstalls packages that fail to load, passes 'quiet' correctly to 'remotes' and only reports packages that failed

* `add_to_gitignore()` keeps the relative path of files in sub-folders (instead of only the file name), prints the right message when only 'extension' is supplied and no longer treats '.gitignore' entries as regular expressions

* `spot_unused_files()` archived files relative to the working directory instead of 'path', and `remove.empty = TRUE` could delete empty folders inside '.git'

* `make_compendium()` could pick up a 'comments_vector' object from the global environment and failed when cloning with the default 'format'

* `open_wd()` failed with paths containing spaces

* Fixed examples in `print_skeleton()` and `check_urls()`

sketchy 1.0.5
=========================

### BUG FIXES

* Problem with directory path in Windows OS in `add_to_gitignore()` 

sketchy 1.0.4
=========================

### NEW FEATURES

* New function `spot_unused_files()` to spot/remove unused files in a project directory

* New function `open_wd()` to open the current working directory

sketchy 1.0.3
=========================

### MINOR IMPROVEMENTS

* Remove 'comments' argument in `make_compendium()`

### NEW FEATURES

* New function `check_urls()` to check url addresses

sketchy 1.0.0
=========================

* First release
