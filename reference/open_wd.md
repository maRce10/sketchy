# Open working directory

`open_wd` opens the working directory in the default file browser.

## Usage

``` r
open_wd(path = ".", verbose = TRUE)
```

## Arguments

- path:

  Directory path to be opened. By default it's the working directory.

- verbose:

  Logical to control whether the 'path' is printed in the console.
  Default is `TRUE`.

## Value

Opens the working directory using the default file browser.

## Details

The function opens the working directory using the default file browser
and prints the working directory in the R console. This function aims to
simplify the manipulation of files and folders in a project.

## References

Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for
data analysis in R. R package version 1.0.3.

## See also

[`spot_unused_files`](https://marce10.github.io/brmsish/reference/spot_unused_files.md)

## Author

Marcelo Araya-Salas (<marcelo.araya@ucr.ac.cr>)

## Examples

``` r
{
open_wd()
}
#> [1] "/home/runner/work/sketchy/sketchy/docs/reference opened in file browser"
```
