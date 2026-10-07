# Print folder structures

`print_skeleton` prints the folder structure of a research compendium.

## Usage

``` r
print_skeleton(path = ".", comments = NULL, folders = NULL)
```

## Arguments

- path:

  path to the directory to be printed. Default is current directory.

- comments:

  A character vector with the comments to be added to folders in the
  graphical representation of the folder skeleton printed on the
  console. If named, names must match folder paths (e.g.
  `c("data/raw" = "raw data")`) and only some folders can be commented.
  If unnamed, it must have one element per folder (in alphabetical order
  of folder paths).

- folders:

  A character vector including the name of the sub-directories of the
  project. If supplied, 'path' is only used as the name of the root
  folder in the printed tree (e.g. `path = "my_project"`).

## Value

The folder skeleton is printed in the console. A `cli_tree` object (see
[`tree`](https://cli.r-lib.org/reference/tree.html)) is returned
invisibly.

## Details

The function prints the folder structure of an existing project.

## References

Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom
Research Compendiums. R package (run `citation("sketchy")` for the
current version).

## See also

[`compendiums`](https://marce10.github.io/brmsish/reference/compendiums.md),
[`make_compendium`](https://marce10.github.io/brmsish/reference/make_compendium.md)

## Author

Marcelo Araya-Salas (<marcelo.araya@ucr.ac.cr>)

## Examples

``` r
{
data(compendiums)

make_compendium(name = "my_other_compendium", path = tempdir(), format = "basic",
force = TRUE)

print_skeleton(path = file.path(tempdir(), "my_other_compendium"))
}
#> Creating directories ...
#> my_other_compendium
#> ├─data/
#> │ ├─processed/ # modified/rearranged data
#> │ └─raw/ # original data
#> ├─manuscript/ # manuscript/poster figures
#> ├─output/ # all non-data products of data analysis
#> └─scripts/ # code
#> Done.
#> my_other_compendium
#> ├─data/
#> │ ├─processed/
#> │ └─raw/
#> ├─manuscript/
#> ├─output/
#> └─scripts/
```
