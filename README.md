sketchy
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/sketchy)](https://cran.r-project.org/package=sketchy) -->
<!-- [![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/sketchy)](http://www.r-pkg.org/pkg/sketchy) -->
<!-- [![Total downloads](https://cranlogs.r-pkg.org/badges/grand-total/sketchy?color=blue)](https://r-pkg.org/pkg/sketchy) -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)

The package is intended to facilitate the use of research compendiums
for data analysis in the R environment. Standard research compendiums
provide a easily recognizable means for organizing digital materials,
allowing other researchers to inspect, reproduce, and build upon that
research.

<!-- Unlike other packages for setting up research compendiums, `sketchy` has very simple functionality. Hence, users can focus on the research project itself rather than on learning how to use a new R package. -->

Unlike other R packages for creating research compendiums
(e.g. [vertical](https://github.com/CrumpLab/vertical),
[rrtools](https://github.com/benmarwick/rrtools)), `sketchy` isn’t
wedded to a particular folder structure. Currently the package provides
13 alternative structures (see object `compendiums`) and allows users to
modify or input their own structures.

To install the latest developmental version from
[github](https://github.com/) you will need the R package
[devtools](https://cran.r-project.org/package=devtools):

``` r
# From github
devtools::install_github("maRce10/sketchy")

# load package
library(sketchy)
```

## Default compendium skeletons

Compendiums can be set up with the function `make_compendium()`. The
function creates the folder/subfolder structure and prints a diagram of
the skeleton in the console:

### Basic compendium

``` r
path = tempdir()

make_compendium(name = "proyect_x", path = path, format = "basic")
## Creating directories ...
## proyect_x
## │   
## ├── data/  
## │   ├── processed/  # modified/rearranged data
## │   └── raw/  # original data
## ├── manuscript/  # manuscript/poster figures
## ├── output/  # all non-data products of data analysis
## └── scripts/  # code
## Done.
```

 

(*in these examples the compendiums are created in a temporary
directory, change ‘path’ to create it in a different directory*)

### Alternative structures

We can use folder structures from other sources. For instance, in this
example we use the structured suggested by Wilson *et al.* (2017):

``` r
make_compendium(name = "proyect_y", path = path, format = "sketchy")
## Creating directories ...
## proyect_y
## │   
## ├── data/  
## │   ├── processed/  # modified/rearranged data
## │   └── raw/  # original data
## ├── manuscript/  # manuscript/poster figures
## ├── output/  # all non-data products of data analysis
## └── scripts/  # code
## Done.
```

 

We can also add comments to the folders to explain what kind of files
they are supposed to contain:

``` r
make_compendium(name = "proyect_z", path = path, format = "large_compendium", comments = compendiums$large_compendium$comments)
## Creating directories ...
## proyect_z
## │   
## ├── analysis/  # Data, scripts, RMarkdown reports and Makefile
## │   ├── data/  # Raw data in open formats, not changed once created
## │   └── scripts/  # R code used to analyse and visualise data
## ├── man/  # Auto-generated documentation for the custom R functions
## ├── R/  # Custom R functions used repeatedly throughout the project
## └── tests/  # Unit tests of R functions to ensure they perform as expected
## Done.
```

 

When creating a compendium that includes a “manuscript” folder the
package adds a “manuscript_template.Rmd” file for facilitating paper
writing within the compendium itself.

We can check all compendium structure available as follows:

``` r
for (i in 1:length(compendiums)) {
    print("---------------", quote = FALSE)
    print(names(compendiums)[i], quote = FALSE)
    print_skeleton(folders = compendiums[[i]]$skeleton)
}
## [1] ---------------
## [1] basic
## .
## │   
## ├── data/  
## │   ├── processed/  
## │   └── raw/  
## ├── manuscript/  
## ├── output/  
## └── scripts/  
## [1] ---------------
## [1] figures
## .
## │   
## ├── data/  
## │   ├── processed/  
## │   └── raw/  
## ├── manuscript/  
## ├── output/  
## │   └── figures/  
## │       ├── exploratory/  
## │       └── final/  
## └── scripts/  
## [1] ---------------
## [1] project_template
## .
## │   
## ├── cache/  
## ├── config/  
## ├── data/  
## ├── diagnostics/  
## ├── docs/  
## ├── graphs/  
## ├── lib/  
## ├── logs/  
## ├── munge/  
## ├── profiling/  
## ├── reports/  
## ├── src/  
## └── tests/  
## [1] ---------------
## [1] pakillo
## .
## │   
## ├── analyses/  
## ├── data/  
## ├── data-raw/  
## ├── docs/  
## ├── inst/  
## ├── man/  
## ├── manuscript/  
## ├── R/  
## └── tests/  
## [1] ---------------
## [1] boettiger
## .
## │   
## ├── man/  
## ├── R/  
## ├── tests/  
## └── vignettes/  
## [1] ---------------
## [1] wilson
## .
## │   
## ├── data/  
## ├── doc/  
## ├── requirements/  
## ├── results/  
## └── src/  
## [1] ---------------
## [1] small_compendium
## .
## │   
## ├── analysis/  
## └── data/  
## [1] ---------------
## [1] medium_compendium
## .
## │   
## ├── analysis/  
## ├── data/  
## ├── man/  
## └── R/  
## [1] ---------------
## [1] large_compendium
## .
## │   
## ├── analysis/  
## │   ├── data/  
## │   └── scripts/  
## ├── man/  
## ├── R/  
## └── tests/  
## [1] ---------------
## [1] vertical
## .
## │   
## ├── data/  
## ├── data-raw/  
## ├── docs/  
## ├── experiments/  
## ├── man/  
## ├── manuscripts/  
## ├── model/  
## ├── posters/  
## ├── R/  
## ├── slides/  
## └── vignettes/  
## [1] ---------------
## [1] rrtools
## .
## │   
## ├── analysis/  
## ├── data/  
## ├── figures/  
## ├── paper/  
## └── templates/  
## [1] ---------------
## [1] rdir
## .
## │   
## ├── code/  
## │   ├── processed/  
## │   ├── raw/  
## │   ├── clean/  
## │   └── raw/  
## ├── figures/  
## │   ├── exploratory/  
## │   └── final/  
## └── text/  
##     ├── final/  
##     └── notes/  
## [1] ---------------
## [1] workflowr
## .
## │   
## ├── analysis/  
## ├── code/  
## ├── data/  
## ├── docs/  
## └── output/  
## [1] ---------------
## [1] sketchy
## .
## │   
## ├── data/  
## │   ├── processed/  
## │   └── raw/  
## ├── manuscript/  
## ├── output/  
## └── scripts/
```

------------------------------------------------------------------------

Please cite [sketchy](https://marce10.github.io/sketchy/) as follows:

Araya-Salas, M., Willink, B., Arriaga, A. (2020), *sketchy: research
compendiums for data analysis in R*. R package version 1.0.0.

# References

1.  Alston, J., & Rick, J. (2020). *A Beginner’s Guide to Conducting
    Reproducible Research*.

2.  Marwick, B., Boettiger, C., & Mullen, L. (2018). *Packaging Data
    Analytical Work Reproducibly Using R (and Friends)*. American
    Statistician, 72(1), 80–88.

3.  Wilson G, Bryan J, Cranston K, Kitzes J, Nederbragt L. & Teal, T.
    K.. 2017. *Good enough practices in scientific computing*. PLOS
    Computational Biology 13(6): e1005510.
