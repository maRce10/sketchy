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
  ignore.folder = NULL,
  remove.empty = FALSE
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
  `TRUE` the spotted files will be moved into the folder "archive"
  within 'path', keeping their original sub-folder structure. Default is
  `FALSE`.

- ignore.folder:

  A character string with the path or paths to the directory(ies) to be
  ignored. Default is `NULL`.

- remove.empty:

  A logical value indicating whether to remove empty folders within
  'path' after moving the unused files. Hidden folders (e.g. '.git') and
  their contents are never removed. Default is `FALSE`.

## Value

A data frame with 2 columns: file.name (self explanatory) and folder
(where the file was found) with the unused files. If no unused files are
found `NULL` is returned invisibly.

## Details

This function is used to spot/archive unused files in a project
directory. The function searches recursively for all script files
('script.extensions') and all files with the target extensions
('file.extensions'). A file is considered unused when its name is not
found in any of the scripts. Files already in the "archive" folder are
ignored. It is useful to keep the project directory clean and organized.
It is recommended to first run the function with `archive = FALSE` to
check which files are spotted and then run `archive = TRUE` to move them
into the "archive" folder.

## References

Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom
Research Compendiums. R package (run `citation("sketchy")` for the
current version).

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
