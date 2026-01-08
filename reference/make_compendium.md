# Generate folder structures for research compendiums

`make_compendium` generates the folder structure of a research
compendium.

## Usage

``` r
make_compendium(name = "research_compendium", path = ".", force = FALSE,
format = "basic", packrat = FALSE,
git = FALSE, clone = NULL, readme = TRUE, Rproj = FALSE)
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

  Logical to control if packrat is initialized
  ([`packrat::init()`](https://rdrr.io/pkg/packrat/man/init.html)) when
  creating the compendium. Default is `FALSE`.

- git:

  Logical to control if a git repository is initialized
  ([`git2r::init()`](https://docs.ropensci.org/git2r/reference/init.html))
  when creating the compendium. Default is `FALSE`.

- clone:

  Path to a directory containing a folder structure to be cloned.
  Default is `NULL`. If provided 'format' is ignored. Folders starting
  with `^\.git|^\.Rproj.user|^\.\.Rcheck` will be ignored.

- readme:

  Logical. Controls if a readme file (in Rmd format) is added to the
  project. The file has predefined fields for documenting objectives and
  current status of the project. Default is `TRUE`.

- Rproj:

  Logical. If `TRUE` a R project is created (i.e. a .Rproj file is saved
  in the main project directory).

## Value

A folder skeleton for a research compendium. In addition the structure
of the compendium is printed in the console. If the compendium format
includes a "manuscript" or "doc(s)" folder the function saves a
manuscript template in Rmarkdown format ("manuscript.Rmd"), a BibTex
file ("example_library.bib", for showing how to add citations) and APA
citation style file ("apa.csl") inside that folder.

## Details

The function takes predefined folder structures to generate the
directory skeleton of a research compendium.

## References

Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for
data analysis in R. R package version 1.0.3.Marwick, B., Boettiger, C.,
& Mullen, L. (2018). Packaging Data Analytical Work Reproducibly Using R
(and Friends). American Statistician, 72(1), 80-88.Alston, J., & Rick,
J. (2020). A Beginners Guide to Conducting Reproducible Research.

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

# custom format
make_compendium(name = "my_second_compendium", path = tempdir(),
 format = c("folder_1", "folder_1/subfolder_1", "folder_1/subfolder_2"),
 force = TRUE)
}
#> Creating directories ...
#> mycompendium
#> │   
#> ├── data/  
#> │   ├── processed/  # modified/rearranged data
#> │   └── raw/  # original data
#> ├── manuscript/  # manuscript/poster figures
#> ├── output/  # all non-data products of data analysis
#> └── scripts/  # code
#> Done.
#> Creating directories ...
#> my_second_compendium
#> │   
#> └── folder_1/  
#>     ├── subfolder_1/  
#>     └── subfolder_2/  
#> Done.
#> 
```
