# Add entries to gitignore

`add_to_gitignore` adds entries to gitignore based on file extension or
file size

## Usage

``` r
add_to_gitignore(add.to.gitignore = FALSE, cutoff = NULL, extension = NULL, path = ".")
```

## Arguments

- add.to.gitignore:

  Logical to control if files are added to 'gitignore' or just printed
  on the console.

- cutoff:

  Numeric. Defines the file size (in MB) cutoff used to find files (i.e.
  only files above the threshold would returned). 99 (MB) is recommended
  when hosting projects at github as the current file size limit is 100
  MB.

- extension:

  Character string to define the file extension of the files to be
  searched for.

- path:

  Path to the project directory. Default is current directory.

## Value

Prints the name of the files matching the searching parameters. If
`add.to.ignore = TRUE` the files matching the search parameters
('cutoff' and/or 'extension') would be added 'gitignore' (a file used by
git to exclude files form version control, including adding them to
github).

## Details

The function can be used to avoid conflicts when working with large
files or just avoid adding non-binary files to remote repositories. It
mostly aims to simplify spotting/excluding large files. Note that file
names can be manually added to the '.gitignore' file using a text
editor.

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

make_compendium(name = "my_compendium", path = tempdir(),
 format = "basic", force = TRUE)

# save a file
write.csv(iris, file.path(tempdir(), "my_compendium", "iris.csv"))

# add the file to gitignore
add_to_gitignore(add.to.gitignore = TRUE,
path = file.path(tempdir(), "my_compendium"), extension = "csv")
}
#> Creating directories ...
#> my_compendium
#> │   
#> ├── data/  
#> │   ├── processed/  # modified/rearranged data
#> │   └── raw/  # original data
#> ├── manuscript/  # manuscript/poster figures
#> ├── output/  # all non-data products of data analysis
#> └── scripts/  # code
#> Done.
#> '.gitignore' file not found so it was created
#> The following file(s) match(es) the extension and exceed(s) the cutoff:
#> iris.csv
#> 
#> File(s) added to '.gitignore':
#> iris.csv
```
