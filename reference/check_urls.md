# Check urls in dynamic report files

`check_urls` Check urls in dynamic report files (.md, .Rmd & .qmd)

## Usage

``` r
check_urls(path = ".")
```

## Arguments

- path:

  Path to the directory containing the files to be checked. Default is
  current directory.

## Value

A url_checker_db object with an added class with a custom print method.

## Details

The function can be used to check if url addresses in dynamic reports
are broken. Taken from Nan Xiao's blogpost
(<https://nanx.me/blog/post/rmarkdown-quarto-link-checker/>).

## References

Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for
data analysis in R. R package version 1.0.3.

Xiao, N. (2023). A General-Purpose Link Checker for R Markdown and
Quarto Projects. Blog post.
https://nanx.me/blog/post/rmarkdown-quarto-link-checker/

## See also

[`add_to_gitignore`](https://marce10.github.io/brmsish/reference/add_to_gitignore.md),
[`make_compendium`](https://marce10.github.io/brmsish/reference/make_compendium.md)

## Author

Nan Xiao (<me@nanx.me>)

## Examples

``` r
{
data(compendiums)

# make compendiums
make_compendium(name = "my_compendium", path = tempdir(),
format = "basic", force = TRUE)

# check urls in scripts
check_urls(path = file.path(tempdir(), "./scripts"))
}
#> Setting project on an existing directory ...
#> README.Rmd already exists.
#> my_compendium
#> │   
#> ├── data/  
#> │   ├── processed/  # modified/rearranged data
#> │   └── raw/  # original data
#> ├── manuscript/  # manuscript/poster figures
#> ├── output/  # all non-data products of data analysis
#> └── scripts/  # code
#> Done.
#> 
#> ✔ All URLs are correct!
```
