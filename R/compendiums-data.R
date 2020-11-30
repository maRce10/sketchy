#' List with compendium skeletons
#'
#' @format A list with 13 compendium formats: \describe{
#'  \item{basic}{basic sketchy format}
#'  \item{figures}{similar to basic, but including output/figures folders}
#'  \item{project_template}{following Kenton White's \href{http://projecttemplate.net/index.html}{ProjectTemplate}}
#'  \item{pakillo}{following Francisco Rodriguez-Sanchez' \href{https://github.com/Pakillo/template.git}{template}}
#'  \item{boettiger}{following Carl Boettiger's \href{https://github.com/cboettig/template.git}{blog}}
#'  \item{wilson}{following Wilson et al. (2017) format}
#'  \item{small_compendium}{following Marwick et al (2018) small compendium format}
#'  \item{medium_compendium}{following Marwick et al (2018) medium compendium format}
#'  \item{large_compendium}{following Marwick et al (2018) large compendium format}
#'  \item{vertical}{ollowing Vuorre et a.(2018) (\href{https://github.com/CrumpLab/vertical}{R package vertical})}
#'  \item{rrtools}{following Marwick (2018) (\href{https://github.com/benmarwick/rrtools}{R package rrtools})}
#'  \item{rdir}{following folder structure described on this \href{https://r-dir.com/blog/2013/11/folder-structure-for-data-analysis.html}{r-dir blog post}}
#'  \item{workflowr}{following Blischak et al 2019 (\href{https://jdblischak.github.io/workflowr/}{R package workflowr})}
#' }
#'
#' @description \code{compendiums} is a list containing the format of 13 different project folder skeletons. For each format 3 elements are provided: `$skeleton` (folder structure), `$comments` and `$info` (reference to the original source).
#'
#'
#' @usage data(compendiums)
#'
#'@references {
#'
#' Blischak, J. D., Carbonetto, P., & Stephens, M. (2019). Creating and sharing reproducible research code the workflowr way. F1000Research, 8.
#'
#' Marwick, B. 2018. rrtools: Creates a reproducible research compendium.
#'
#' Marwick, B., Boettiger, C., & Mullen, L. (2018). Packaging data analytical work reproducibly using R (and friends). The American Statistician, 72(1), 80-88.
#'
#' Vuorre, Matti, and Matthew J. C. Crump. 2020. "Sharing and Organizing Research Products as R Packages." PsyArXiv. January 15.
#'
#' Wilson G, Bryan J, Cranston K, Kitzes J, Nederbragt L, et al. (2017) Good enough practices in scientific computing. PLOS Computational Biology 13(6): e1005510.
#'
#'}
#'
"compendiums"
