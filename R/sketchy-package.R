#' sketchy: create custom research compendiums
#'
#' `sketchy` is intended to facilitate the use of research compendiums for data analysis in the R environment. Standard research compendiums provide a easily recognizable means for organizing digital materials, allowing  other researchers to inspect, reproduce, and build upon that research.
#'
#' The main features of the package are:
#'   \itemize{
#'   \item Creation of (customized) folder structure
#'   \item Simplify the inclusion of big data files with version control software and online collaborative platforms (e.g. github)
#'   }
#'
#' @import utils
#' @import knitr
#' @importFrom packrat init
#' @importFrom rmarkdown render
#' @importFrom stringr fixed str_detect
#' @importFrom stringi stri_unescape_unicode
#' @importFrom crayon cyan bold
#' @importFrom cli style_bold style_italic make_ansi_style num_ansi_colors
#' @importFrom xaringanExtra use_clipboard
#' @importFrom remotes install_github install_bitbucket install_cran install_gitlab install_bioc
#' @author Marcelo Araya-Salas, Beatriz Willink & Andrea Arriaga
#'
#'   Maintainer: Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#'
#' @docType package
#' @details License: GPL (>= 2)
#' @keywords internal
"_PACKAGE"
NULL
#> NULL
#'
