# List with compendium skeletons

`compendiums` is a list containing the format of 14 different project
folder skeletons. For each format 3 elements are provided:
\`\$skeleton\` (folder structure), \`\$comments\` and \`\$info\`
(reference to the original source).

## Usage

``` r
data(compendiums)
```

## Format

A list with 14 compendium formats:

- basic:

  basic sketchy format

- figures:

  similar to basic, but including output/figures folders

- project_template:

  following Kenton White's
  [ProjectTemplate](http://projecttemplate.net/index.md)

- pakillo:

  following Francisco Rodriguez-Sanchez'
  [template](https://github.com/Pakillo/template)

- boettiger:

  following Carl Boettiger's
  [blog](https://github.com/cboettig/template)

- wilson:

  following Wilson et al. (2017) format

- small_compendium:

  following Marwick et al (2018) small compendium format

- medium_compendium:

  following Marwick et al (2018) medium compendium format

- large_compendium:

  following Marwick et al (2018) large compendium format

- vertical:

  following Vuorre *et al.* (2018) [R package
  vertical](https://github.com/CrumpLab/vertical)

- rrtools:

  following Marwick (2018) ([R package
  rrtools](https://github.com/benmarwick/rrtools))

- rdir:

  following folder structure described on at a r-dir blog post (although
  seems like it was removed)

- workflowr:

  following Blischak *et al.* (2019) [R package
  workflowr](https://workflowr.github.io/workflowr/)

- sketchy:

  same skeleton than 'basic' but including a custom Rmarkdown and quarto
  files for documenting data analyses

## References

Blischak, J. D., Carbonetto, P., & Stephens, M. 2019. *Creating and
sharing reproducible research code the workflowr way*. F1000Research, 8.
Marwick, B. 2018. *rrtools: Creates a reproducible research compendium*.
Marwick, B., Boettiger, C., & Mullen, L. 2018. *Packaging data
analytical work reproducibly using R (and friends)*. The American
Statistician, 72(1), 80-88. Vuorre, Matti, and Matthew J. C. Crump.
2020. *Sharing and Organizing Research Products as R Packages*.
PsyArXiv. January 15. Wilson G, Bryan J, Cranston K, Kitzes J,
Nederbragt L. & Teal, T. K.. 2017. *Good enough practices in scientific
computing*. PLOS Computational Biology 13(6): e1005510.
