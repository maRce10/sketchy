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

  A character string with the comments to be added to each folder in the
  graphical representation of the folder skeleton printed on the
  console.

- folders:

  A character vector including the name of the sub-directories of the
  project.

## Value

The folder skeleton is printed in the console.

## Details

The function prints the folder structure of an existing project.

## References

Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for
data analysis in R. R package version 1.0.3.

## See also

[`compendiums`](https://marce10.github.io/brmsish/reference/compendiums.md),
[`make_compendium`](https://marce10.github.io/brmsish/reference/make_compendium.md)

## Author

Marcelo Araya-Salas (<marcelo.araya@ucr.ac.cr>)

## Examples

``` r
{
data(compendiums)

make_compendium(name = "my_other_compendium", path = tempdir(), format = "basic")

print_skeleton(path = file.path(tempdir(), "mycompendium"))
}
#> Creating directories ...
#> my_other_compendium
#> │   
#> ├── data/  
#> │   ├── processed/  # modified/rearranged data
#> │   └── raw/  # original data
#> ├── manuscript/  # manuscript/poster figures
#> ├── output/  # all non-data products of data analysis
#> └── scripts/  # code
#> Done.
#> mycompendium
#> │   
#> ├── data/  
#> │   ├── processed/  
#> │   └── raw/  
#> ├── manuscript/  
#> ├── output/  
#> └── scripts/  
```
