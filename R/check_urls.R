#' Check urls in dynamic report files
#'
#' \code{check_urls} Check urls in dynamic report files (.md, .Rmd & .qmd)
#' @param path Path to the directory containing the files to be checked. Default is current directory.
#' @return A url_checker_db object with an added class with a custom print method.
#' @seealso \code{\link{add_to_gitignore}}, \code{\link{make_compendium}}
#' @export
#' @name check_urls
#' @details The function can be used to check if url addresses in dynamic reports are broken. Taken from Nan Xiao's blogpost (\url{https://nanx.me/blog/post/rmarkdown-quarto-link-checker/}).
#' @examples {
#' data(compendiums)
#'
#' # make compendiums
#' make_compendium(name = "my_compendium", path = tempdir(),
#' format = "basic", force = TRUE)
#'
#' # check urls in scripts
#' check_urls(path = file.path(tempdir(), "./scripts"))
#' }
#'
#' @author Nan Xiao (\email{me@@nanx.me})
#' @references {
#' Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for data analysis in R. R package version 1.0.3.
#' Xiao, N. (2023). A General-Purpose Link Checker for R Markdown and Quarto Projects. Blog post. https://nanx.me/blog/post/rmarkdown-quarto-link-checker/
#' }

check_urls <- function(path = ".") {
  # Create a source package directory
  pkg <- tempfile()
  dir.create(pkg)

  # Flatten copy relevant files
  vig <- file.path(pkg, "vignettes")
  dir.create(vig)
  .flatten_copy(path, vig)

  # Create a minimal DESCRIPTION file
  write("VignetteBuilder: knitr", file = file.path(pkg, "DESCRIPTION"))

  # Make the copied files look like vignettes
  lapply(
    list.files(vig, full.names = TRUE),
    function(x) {
      write(
        "---\nvignette: >\n  %\\VignetteEngine{knitr::rmarkdown}\n---",
        file = x, append = TRUE
      )
    }
  )

  url_checks <- urlchecker::url_check(pkg)

  return(url_checks)
}
