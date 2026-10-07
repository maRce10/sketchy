# Generate folder structures for research compendiums

`make_compendium` generates the folder structure of a research
compendium.

## Usage

``` r
make_compendium(name = "research_compendium", path = ".", force = FALSE,
format = "basic", packrat = FALSE,
git = FALSE, clone = NULL, readme = TRUE, Rproj = FALSE, renv = FALSE)
```

## Arguments

- name:

  character string: the research compendium directory name. No special
  characters should be used. Default is "research_compendium".

- path:

  Path to put the project directory in. Default is current directory.

- force:

  Logical controlling whether existing folders with the same name are
  used for setting the folder structure. The function will never
  overwrite existing files or folders.

- format:

  A character vector of length 1 with the name of the built-in
  compendiums available in the example object \`compendiums\` (see
  [`compendiums`](https://marce10.github.io/brmsish/reference/compendiums.md)
  for available formats). Default is 'basic'. Alternatively, it can be a
  character vector with 2 or more elements with the names of the folders
  and subfolders to be included (e.g.
  `c("folder_1", "folder_1/subfolder_1", "folder_1/subfolder_2")`).

- packrat:

  Deprecated (packrat has been superseded by renv). Use 'renv' instead.

- git:

  Logical to control if a git repository is initialized
  ([`git2r::init()`](https://docs.ropensci.org/git2r/reference/init.html))
  when creating the compendium. Default is `FALSE`.

- clone:

  Path to a directory containing a folder structure to be cloned.
  Default is `NULL`. If provided 'format' is ignored. The folders
  '.git', '.Rproj.user', '..Rcheck' and '.quarto' (and their
  sub-folders) are ignored.

- readme:

  Logical. Controls if a readme file (in Rmd format) is added to the
  project. The file has predefined fields for documenting objectives and
  current status of the project. Default is `TRUE`.

- Rproj:

  Logical. If `TRUE` a R project is created (i.e. a .Rproj file is saved
  in the main project directory).

- renv:

  Logical to control if [renv](https://rstudio.github.io/renv/) is
  initialized
  ([`renv::init()`](https://rstudio.github.io/renv/reference/init.html))
  when creating the compendium. renv records the exact version of the
  packages used in the project (in the 'renv.lock' file) so they can be
  restored later or by other users with
  [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html).
  renv is set to record all packages installed in the project library
  (`renv::settings$snapshot.type("all")`), so packages installed by the
  templates' package lists are recorded when running
  [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html).
  The project is not activated in the current R session (it is activated
  when the project is opened in a new R session). Default is `FALSE`.

## Value

A folder skeleton for a research compendium. In addition the structure
of the compendium is printed in the console. Template files are also
added depending on the format (existing files are never overwritten):

- If the compendium includes a "manuscript" folder: a manuscript
  template in Rmarkdown format ("manuscript.Rmd"), a BibTex file
  ("references.bib", for showing how to add citations) and an APA
  citation style file ("apa.csl").

- `format = "sketchy"`: analysis templates in Rmarkdown
  ("analysis_template_rmarkdown.Rmd") and quarto
  ("analysis_template_quarto.qmd") format, with their style files
  ("rmd.css" and "qmd.css"), in the "scripts" folder.

- `format = "github_site"`: a quarto website in the "scripts" folder and
  a GitHub action to publish it (see details).

- `readme = TRUE`: "README.Rmd" (and its rendered "README.md").

- `Rproj = TRUE`: an R project file ("name.Rproj").

- `renv = TRUE`: renv files ("renv.lock", ".Rprofile" and "renv"
  folder).

## Details

The function takes predefined folder structures to generate the
directory skeleton of a research compendium.

The format "github_site" sets up a project that is published as a
website on GitHub Pages (see
<https://github.com/maRce10/suwo_publication> for an example). The
'scripts' folder is a quarto website ('\_quarto.yml', 'index.qmd' home
page and 'analysis.qmd' analysis template) and
'.github/workflows/publish.yml' contains a GitHub action that renders
and publishes the site every time changes are pushed to the 'main' (or
'master') branch. Pages rendered locally are not re-run on GitHub: their
results are taken from the 'scripts/\_freeze' folder
(`execute: freeze: true`), which must be committed. Without renv, only
the packages needed to replay these results are installed on GitHub, so
the site must be rendered locally ('quarto render' within 'scripts/')
before pushing. With `renv = TRUE` the packages recorded in 'renv.lock'
are installed on GitHub, so pages that have not been rendered locally
are run there (data used must be committed too). In this case a
'scripts/.Rprofile' file is added so renv is also activated when quarto
renders the site from the 'scripts' folder. To publish the site, push
the project to GitHub and set 'Source' to 'GitHub Actions' in the
repository Settings \> Pages. Note that [quarto](https://quarto.org)
must be installed.

## References

Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom
Research Compendiums. R package (run `citation("sketchy")` for the
current version).

Marwick, B., Boettiger, C., & Mullen, L. (2018). Packaging Data
Analytical Work Reproducibly Using R (and Friends). American
Statistician, 72(1), 80-88.

Alston, J., & Rick, J. (2020). A Beginners Guide to Conducting
Reproducible Research.

## See also

[`compendiums`](https://marce10.github.io/brmsish/reference/compendiums.md),
[`print_skeleton`](https://marce10.github.io/brmsish/reference/print_skeleton.md)

## Author

Marcelo Araya-Salas (<marcelo.araya@ucr.ac.cr>)

## Examples

``` r
{
data(compendiums)

# default format
make_compendium(name = "mycompendium", path = tempdir(), format = "basic",
force = TRUE)

# quarto website to be published on GitHub Pages
make_compendium(name = "my_site_compendium", path = tempdir(),
 format = "github_site", force = TRUE)

# custom format
make_compendium(name = "my_second_compendium", path = tempdir(),
 format = c("folder_1", "folder_1/subfolder_1", "folder_1/subfolder_2"),
 force = TRUE)
}
#> Creating directories ...
#> mycompendium
#> ├─data/
#> │ ├─processed/ # modified/rearranged data
#> │ └─raw/ # original data
#> ├─manuscript/ # manuscript/poster figures
#> ├─output/ # all non-data products of data analysis
#> └─scripts/ # code
#> Done.
#> Creating directories ...
#> my_site_compendium
#> ├─.github/ # GitHub settings
#> │ └─workflows/ # GitHub action that renders and publishes the site
#> ├─archive/ # files no longer used (see spot_unused_files())
#> ├─data/
#> │ ├─processed/ # modified/rearranged data
#> │ └─raw/ # original data
#> ├─manuscript/ # manuscript/poster files
#> ├─output/ # all non-data products of data analysis
#> └─scripts/ # quarto website: code + reports (index.qmd is the home page)
#> 
#> To publish the site on GitHub Pages:
#>   1. Replace 'USER' with your GitHub user name in 'scripts/_quarto.yml' and 'scripts/index.qmd'
#>   2. Render the site locally ('quarto render' within 'scripts/') and commit the 'scripts/_freeze' folder (use 'renv = TRUE' to run pages on GitHub instead)
#>   3. Push the project to a GitHub repository
#>   4. In the repository go to Settings > Pages and set 'Source' to 'GitHub Actions'
#> 
#> Done.
#> Creating directories ...
#> my_second_compendium
#> └─folder_1/
#>   ├─subfolder_1/
#>   └─subfolder_2/
#> Done.
#> 
```
