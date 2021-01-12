#' Generate folder structures for research compendiums
#'
#' \code{make_compendium} generates the folder structure of a research compendium.
#' @usage make_compendium(name = "research_compendium", path = ".", force = FALSE, format,
#' comments = NULL, packrat = FALSE, git = FALSE, clone = NULL)
#' @param name character string: the research compendium directory name. No special characters should be used. Default is "research_compendium".
#' @param path Path to put the package directory in. Default is current directory.
#' @param force Logical controlling whether existing folders with the same name are used for setting the folder structure. The function will never overwrite existing files or folders.
#' @param format A character vector with the names of the folders and subfolders to be included. Take a look at `compendiums$basic` for an example.
#' @param comments A character string with the comments to be added to each folder in the graphical representation of the folder skeleton printed on the console.
#' @param packrat Logical to control if packrat is initialized (\code{packrat::init()}) when creating the compendium. Default is \code{FALSE}.
#' @param git Logical to control if a git repository is initialized (\code{git2r::init()}) when creating the compendium. Default is \code{FALSE}.
#' @param clone Path to a directory containing a folder structure to be cloned. Default is  \code{NULL}. If provided 'format' is ignored. Folders starting with \code{^\\.git|^\.Rproj.user|^\\.\\.Rcheck} will be ignored.
#' @return A folder skeleton for a research compendium. In addition the structure of the compendium is printed in the console. If the compendium format includes a "manuscript" or "doc(s)" folder the function saves a manuscript template in Rmarkdown format ("manuscript_template.Rmd") and APA citation style file ("apa.csl") inside that folder.
#' @seealso \code{\link{compendiums}}, \code{\link{print_skeleton}}
#' @export
#' @name make_compendium
#' @details The function takes predefined folder structures to generate the directory skeleton of a research compendium.
#' @examples {
#' data(compendiums)
#'
#'make_compendium(name = "mycompendium", path = tempdir(), format = compendiums$basic$skeleton,
#' force = TRUE)
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references {
#' Araya-Salas, M., Willink, B., Arriaga, A. (2020), sketchy: research compendiums for data analysis in R. R package version 1.0.0.
#'
#' Marwick, B., Boettiger, C., & Mullen, L. (2018). Packaging Data Analytical Work Reproducibly Using R (and Friends). American Statistician, 72(1), 80-88.
#'
#' Alston, J., & Rick, J. (2020). A Beginners Guide to Conducting Reproducible Research.
#' }
#last modification on dec-26-2019 (MAS)

make_compendium <- function(name = "research_compendium", path = ".", force = FALSE, format, comments = NULL, packrat = FALSE, git = FALSE, clone = NULL)
  {
    safe.dir.create <- function(path) {
      if (!dir.exists(path) && !dir.create(path))
        stop(gettextf("cannot create directory '%s'", path),
             domain = NA)
    }

    # clone folder structure
    if (!is.null(clone)){
      cat(crayon::green("CLoning directories ...\n"))

      # get clone structure
      format <- list.dirs(path = clone, full.names = FALSE, recursive = TRUE)

      # remove git R and devtools folders
      format <- grep("^\\.git|^\\.Rproj.user|^\\.\\.Rcheck", format, value = TRUE, invert = TRUE)

      # remove empty elements
      format <- format[!format %in%  c("", " ")]
}

    dir <- file.path(path, name)

    if (!file.exists(dir))
    cat(crayon::green("Creating directories ...\n")) else
      cat(crayon::green("Setting project on an existing directory ...\n"))

    if (file.exists(dir) && !force)
      stop(gettextf("directory '%s' already exists", dir),
           domain = NA)
    safe.dir.create(dir)

    for(i in format)
    safe.dir.create(file.path(dir, i))

    if (any(basename(format) == "manuscript")){
      if (!file.exists(file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "manuscript.Rmd")))
      writeLines(internal_files$manuscript_template, file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "manuscript.Rmd"))

      if (!file.exists(file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "apa.csl")))
      writeLines(internal_files$apa.csl, file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "apa.csl"))
      }

    cat(crayon::green("Done.\n"))

    if (packrat){
     packrat::init(project = file.path(path, name))

      format <- c(format, "packrat")
    }

    if (git) git2r::init(path = file.path(path, name))

  print_skeleton(path = file.path(path, name), comments = comments)
}
