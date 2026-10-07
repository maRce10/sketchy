# Install and load packages

`load_packages` installs and loads packages from different repositories.

## Usage

``` r
load_packages(packages, quiet = FALSE, upgrade.deps = FALSE, quite = NULL)
```

## Arguments

- packages:

  Character vector with the packages to be installed (if missing) and
  loaded. Packages can be given as [pak package
  specifications](https://pak.r-lib.org/reference/pak_package_sources.html):
  a package name for CRAN (e.g. `"kableExtra"`), `"bioc::package"` for
  Bioconductor, `"user/repo"` for GitHub, `"gitlab::user/repo"` for
  GitLab or `"git::url"` for any git repository. Specific versions can
  be requested (e.g. `"user/repo@v1.0"` or `"kableExtra@1.4.0"`).
  Alternatively, the vector names can indicate the repository: 'cran',
  'github', 'gitlab', 'bitbucket' or 'bioconductor' (for 'github',
  'gitlab' and 'bitbucket' the string must be in the form
  'user/package').

- quiet:

  Logical argument to control if installation output and package startup
  messages are suppressed. Default is `FALSE` (messages are printed).

- upgrade.deps:

  Logical argument to control if dependencies of the packages being
  installed are upgraded to their latest version. Default is `FALSE`
  (dependencies are only upgraded if required). Packages that are
  already installed are never upgraded.

- quite:

  Deprecated. Use 'quiet' instead.

## Value

Invisibly returns a named logical vector indicating which packages were
successfully loaded.

## Details

**Superseded**: this function will keep working, but it is no longer
recommended. Using it in reports or scripts makes projects depend on
'sketchy'. Install packages with
[`pak::pkg_install()`](https://pak.r-lib.org/reference/pkg_install.html)
and load them with [`library()`](https://rdrr.io/r/base/library.html)
instead (as in the templates added by
[`make_compendium`](https://marce10.github.io/brmsish/reference/make_compendium.md)),
and use `make_compendium(renv = TRUE)` to record the package versions
used in a project. For example:


    packages <- c("kableExtra", "bioc::ggtree", "maRce10/Rraven")
    package_names <- sub(".*[/:]", "", sub("@.*$", "", packages))
    missing <- !vapply(package_names, requireNamespace, logical(1), quietly = TRUE)
    if (any(missing)) pak::pkg_install(packages[missing])
    invisible(lapply(package_names, library, character.only = TRUE))

The function installs missing packages and loads (attaches) all packages
in a single call. Packages that are already installed are just loaded
(no internet connection is needed). Installation is done with
[`pkg_install`](https://pak.r-lib.org/reference/pkg_install.html) (the
'pak' package is installed from CRAN if needed). The package name to
load is taken from the package specification (e.g. "Rraven" for
"maRce10/Rraven"), so it won't work for repositories in which the
package name differs from the repository name or the package is in a
sub-folder.

## References

Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom
Research Compendiums. R package (run `citation("sketchy")` for the
current version).

## See also

[`pkg_install`](https://pak.r-lib.org/reference/pkg_install.html),
[`make_compendium`](https://marce10.github.io/brmsish/reference/make_compendium.md)

## Author

Marcelo Araya-Salas (<marcelo.araya@ucr.ac.cr>)

## Examples

``` r
if (FALSE) { # \dontrun{
# CRAN, Bioconductor and GitHub packages
load_packages(packages = c("kableExtra", "bioc::ggtree", "maRce10/Rraven"))

# same packages using vector names to indicate the repository
load_packages(packages = c("kableExtra", bioconductor = "ggtree",
github = "maRce10/Rraven"), quiet = TRUE)
} # }
```
