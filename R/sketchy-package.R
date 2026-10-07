#' sketchy: create custom research compendiums
#'
#' `sketchy` is intended to facilitate the use of research compendiums for data analysis in the R environment. Standard research compendiums provide a easily recognizable means for organizing digital materials, allowing  other researchers to inspect, reproduce, and build upon that research.
#'
#' The main features of the package are:
#'   \itemize{
#'   \item Creation of (customized) folder structures, including templates for analysis reports (Rmarkdown/quarto) and manuscripts
#'   \item Creation of projects published as websites on GitHub Pages (format "github_site")
#'   \item Recording package versions with renv
#'   \item Simplify the inclusion of big data files with version control software and online collaborative platforms (e.g. github)
#'   \item Spotting/archiving unused files and checking urls in dynamic reports
#'   }
#'
#' @import utils
#' @import knitr
#' @importFrom rmarkdown render
#' @importFrom stringr fixed str_detect
#' @importFrom crayon cyan bold
#' @importFrom cli style_bold style_italic make_ansi_style num_ansi_colors
#' @author Marcelo Araya-Salas & Andrea Yure Arriaga Madrigal
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
