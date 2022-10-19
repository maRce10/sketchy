#' Generate folder structures for research compendiums
#'
#' \code{make_compendium} generates the folder structure of a research compendium.
#' @usage make_compendium(name = "research_compendium", path = ".", force = FALSE,
#' format = "basic", comments = TRUE, packrat = FALSE,
#' git = FALSE, clone = NULL, readme = TRUE, Rproj = FALSE)
#' @param name character string: the research compendium directory name. No special characters should be used. Default is "research_compendium".
#' @param path Path to put the project directory in. Default is current directory.
#' @param force Logical controlling whether existing folders with the same name are used for setting the folder structure. The function will never overwrite existing files or folders.
#' @param format A character vector of length 1 with the name of the built-in compendiums available in the example object `compendiums` (see \code{\link{compendiums}} for available formats). Default is 'basic'. Alternatively, it can be a character vector with 2 or more elements with the names of the folders and subfolders to be included.
#' @param comments A logical argument to control if comments of default formats are shown in the graphical representation of the folder skeleton printed on the console. Alternatively, a character string with the comments can be supplied (most useful when using a custom format). Default is \code{TRUE}.
#' @param packrat Logical to control if packrat is initialized (\code{packrat::init()}) when creating the compendium. Default is \code{FALSE}.
#' @param git Logical to control if a git repository is initialized (\code{git2r::init()}) when creating the compendium. Default is \code{FALSE}.
#' @param clone Path to a directory containing a folder structure to be cloned. Default is \code{NULL}. If provided 'format' is ignored. Folders starting with \code{^\\.git|^\.Rproj.user|^\\.\\.Rcheck} will be ignored.
#' @param readme Logical. Controls if a readme file (in Rmd format) is added to the project. The file has predefined fields for documenting objectives and current status of the project. Default is \code{TRUE}.
#' @param Rproj Logical. If \code{TRUE} a R project is created (i.e. a .Rproj file is saved in the main project directory).
#' @return A folder skeleton for a research compendium. In addition the structure of the compendium is printed in the console. If the compendium format includes a "manuscript" or "doc(s)" folder the function saves a manuscript template in Rmarkdown format ("manuscript.Rmd"), a BibTex file ("example_library.bib", for showing how to add citations) and APA citation style file ("apa.csl") inside that folder.
#' @seealso \code{\link{compendiums}}, \code{\link{print_skeleton}}
#' @export
#' @name make_compendium
#' @details The function takes predefined folder structures to generate the directory skeleton of a research compendium.
#' @examples {
#' data(compendiums)
#'
#'make_compendium(name = "mycompendium", path = tempdir(), format = "basic",
#' force = TRUE)
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references {
#' Araya-Salas, M., Willink, B., Arriaga, A. (2020), sketchy: research compendiums for data analysis in R. R package version 1.0.2.
#'
#' Marwick, B., Boettiger, C., & Mullen, L. (2018). Packaging Data Analytical Work Reproducibly Using R (and Friends). American Statistician, 72(1), 80-88.
#'
#' Alston, J., & Rick, J. (2020). A Beginners Guide to Conducting Reproducible Research.
#' }
#last modification on dec-26-2019 (MAS)

make_compendium <- function(name = "research_compendium", path = ".", force = FALSE, format = "basic", comments = TRUE, packrat = FALSE, git = FALSE, clone = NULL, readme = TRUE, Rproj = FALSE)
  {
    safe.dir.create <- function(path) {
      if (!dir.exists(path) && !dir.create(path))
        stop2(gettextf("cannot create directory '%s'", path),
             domain = NA)
    }

    # save format
    org_format <- format[1]

    # allow format name or skeleton from list
    if (!is.character(format))
      stop2("'format' must either be a character vector") else
        if (length(format) == 1)
          if (!format %in% names(compendiums))
            stop2("'format' not found (must be one of those in 'names(compendiums)')") else {
              if (is.logical(comments)){
                comments_vector <- if (comments)
                compendiums[[format]]$comments else NULL
              } else
              if (is.character(comments))
                comments_vector <- comments

              format <- compendiums[[format]]$skeleton
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
      stop2(gettextf("directory '%s' already exists", dir),
           domain = NA)
      safe.dir.create(dir)

    for(i in format)
      safe.dir.create(file.path(dir, i))

    if (any(basename(format) == "manuscript")){

      # create manuscript.Rmd
      if (!file.exists(file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "manuscript.Rmd")))
      writeLines(internal_files$manuscript_template, file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "manuscript.Rmd"))

      # create apa.csl
      if (!file.exists(file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "apa.csl")))
      writeLines(internal_files$apa.csl, file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "apa.csl"))

      # create example_library
      if (!file.exists(file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "references.bib")))
        writeLines(internal_files$example_library, file.path(path, name, grep("manuscript$|^docs$|^doc$", format, ignore.case = TRUE, value = TRUE)[1], "references.bib"))
    }

      if (org_format[1] == "sketchy"){

        # save analysis template
        if (!file.exists(file.path(path, name, grep("scripts$", format, ignore.case = TRUE, value = TRUE)[1], "analysis_template.Rmd")))
          writeLines(internal_files$analysis_template, file.path(path, name, grep("scripts$", format, ignore.case = TRUE, value = TRUE)[1], "analysis_template.Rmd"))

        # save extra.css
        if (!file.exists(file.path(path, name, grep("scripts$", format, ignore.case = TRUE, value = TRUE)[1], "extra.css")))
          writeLines(internal_files$extra_css, file.path(path, name, grep("scripts$", format, ignore.case = TRUE, value = TRUE)[1], "extra.css"))
      }

    # initiate git
    if (git) {
      # error message if git2r is not installed
      if (!requireNamespace("git2r",quietly = TRUE))
        stop2("must install 'git2r' to use 'git'") else
          git2r::init(path = file.path(path, name))
    }

    # create Rproj file
  if (Rproj)  {
    x <- c("Version: 1.0", "", "RestoreWorkspace: Default", "SaveWorkspace: Default",
           "AlwaysSaveHistory: Default", "", "EnableCodeIndexing: Yes",
           "UseSpacesForTab: Yes", "NumSpacesForTab: 4", "Encoding: UTF-8",
           "", "RnwWeave: knitr", "LaTeX: pdfLaTeX")

    cat(paste(x, collapse="\n"), file=file.path(dir, paste0(name, ".Rproj")))
  }

    if (packrat){
      packrat::init(project = file.path(path, name))
      format <- c(format, "packrat")
    }


    if (readme)
      if (!file.exists(file.path(dir, "README.Rmd"))) {
        readme_file <- internal_files$readme_template

        # add project name to file
        readme_file[2] <- paste('title:', name)
        writeLines(readme_file, file.path(dir, "README.Rmd"))

        rmarkdown::render(file.path(dir, "README.Rmd"), quiet = TRUE)
        } else
        cat(crayon::green("README.Rmd already exists.\n"))

      # convert comments
    if (!exists("comments_vector"))
      comments_vector <- if (is.character(comments)) comments else NULL

      print_skeleton(path = file.path(path, name), comments = comments_vector)

  cat(crayon::green("Done.\n"))


}
