# Install and load packages

`load_packages` installs and loads packages from different repositories.

## Usage

``` r
load_packages(packages, quite = FALSE, upgrade.deps = FALSE)
```

## Arguments

- packages:

  Character vector with the names of the packages to be installed. The
  vector names indicate the repositories from which packages will be
  installed. If no name is included CRAN will be used as the default
  repository. Available repositories are: 'cran', 'github', 'gitlab',
  'bitbucket' and 'bioconductor'. Note that for 'github', 'gitlab' and
  'bitbucket' the string must include the user name in the form
  'user/package'.

- quite:

  Logical argument to control if package startup messages are printed.
  Default is `FALSE` (messages are printed).

- upgrade.deps:

  Logical argument to control if package dependencies are
  upgraded.Default is `FALSE`.

## Value

No object is returned.

## Details

The function installs and loads packages from different repositories in
a single call.

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
if (FALSE) { # \dontrun{
load_packages(packages = c("kableExtra", bioconductor = "ggtree",
github = "maRce10/Rraven"), quite = TRUE)
} # }
```
