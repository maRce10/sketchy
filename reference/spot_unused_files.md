# Spot/remove unused image and data files

`spot_unused_files` allow user to identify and optionally archive unused
image or data files in a project directory

## Usage

``` r
spot_unused_files(
  path = ".",
  file.extensions = c("png", "jpg", "jpeg", "gif", "bmp", "tiff", "tif", "csv", "xls",
    "xlsx", "txt"),
  script.extensions = c("R", "Rmd", "qmd"),
  archive = FALSE,
  ignore.folder = NULL
)
```

## Arguments

- path:

  A character string with the path to the directory to be analyzed.
  Default is current directory.

- file.extensions:

  A character vector with the file extensions to be considered. By
  default the function looks for the following image and file
  extensions: "png", "jpg", "jpeg", "gif", "bmp", "tiff", "tif", "csv",
  "xls", "xlsx" and "txt".

- script.extensions:

  A character vector with the script extensions to be considered.
  Default is c("R", "Rmd", "qmd").

- archive:

  A logical value indicating whether to archive the unused files. If
  `TRUE` the spotted files will be move into the folder
  "./unused_files". Default is `FALSE`.

- ignore.folder:

  A character string with the path or paths to the directory(ies) to be
  ignored. Default is `NULL`.

## Value

Returns a data frame with 2 columns: file.name (self explanatory) and
folder (where the file is found).

## Details

This function is used to spot/remove unused files in a project
directory. The function will find all R script files (extensions R, Rmd
and qmd) and all files recursively It is useful to keep the project
directory clean and organized. It is recommended to first run the
function with a the argument `archive = FALSE` to spot which files are
being spotted and then run `archive = TRUE` if they need to be removed.

## References

Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for
data analysis in R. R package version 1.0.3.

## See also

[`add_to_gitignore`](https://marce10.github.io/brmsish/reference/add_to_gitignore.md),
[`make_compendium`](https://marce10.github.io/brmsish/reference/make_compendium.md)

## Author

Marcelo Araya-Salas (<marcelo.araya@ucr.ac.cr>)

## Examples

``` r
if (FALSE) { # \dontrun{
spot_unused_files(path = "path/to/your/project")
} # }
```
