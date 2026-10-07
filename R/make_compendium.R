#' Generate folder structures for research compendiums
#'
#' \code{make_compendium} generates the folder structure of a research compendium.
#' @usage make_compendium(name = "research_compendium", path = ".", force = FALSE,
#' format = "basic", packrat = FALSE,
#' git = FALSE, clone = NULL, readme = TRUE, Rproj = FALSE, renv = FALSE)
#' @param name character string: the research compendium directory name. No special characters should be used. Default is "research_compendium".
#' @param path Path to put the project directory in. Default is current directory.
#' @param force Logical controlling whether existing folders with the same name are used for setting the folder structure. The function will never overwrite existing files or folders.
#' @param format A character vector of length 1 with the name of the built-in compendiums available in the example object `compendiums` (see \code{\link{compendiums}} for available formats). Default is 'basic'. Alternatively, it can be a character vector with 2 or more elements with the names of the folders and subfolders to be included (e.g. \code{c("folder_1", "folder_1/subfolder_1", "folder_1/subfolder_2")}).
#' @param packrat Deprecated (packrat has been superseded by renv). Use 'renv' instead.
#' @param git Logical to control if a git repository is initialized (\code{git2r::init()}) when creating the compendium. Default is \code{FALSE}.
#' @param clone Path to a directory containing a folder structure to be cloned. Default is \code{NULL}. If provided 'format' is ignored. The folders '.git', '.Rproj.user', '..Rcheck' and '.quarto' (and their sub-folders) are ignored.
#' @param readme Logical. Controls if a readme file (in Rmd format) is added to the project. The file has predefined fields for documenting objectives and current status of the project. Default is \code{TRUE}.
#' @param Rproj Logical. If \code{TRUE} a R project is created (i.e. a .Rproj file is saved in the main project directory).
#' @param renv Logical to control if \href{https://rstudio.github.io/renv/}{renv} is initialized (\code{renv::init()}) when creating the compendium. renv records the exact version of the packages used in the project (in the 'renv.lock' file) so they can be restored later or by other users with \code{renv::restore()}. renv is set to record all packages installed in the project library (\code{renv::settings$snapshot.type("all")}), so packages installed by the templates' package lists are recorded when running \code{renv::snapshot()}. The project is not activated in the current R session (it is activated when the project is opened in a new R session). Default is \code{FALSE}.
#' @return A folder skeleton for a research compendium. In addition the structure of the compendium is printed in the console. Template files are also added depending on the format (existing files are never overwritten):
#' \itemize{
#'  \item If the compendium includes a "manuscript" folder: a manuscript template in Rmarkdown format ("manuscript.Rmd"), a BibTex file ("references.bib", for showing how to add citations) and an APA citation style file ("apa.csl").
#'  \item \code{format = "sketchy"}: analysis templates in Rmarkdown ("analysis_template_rmarkdown.Rmd") and quarto ("analysis_template_quarto.qmd") format, with their style files ("rmd.css" and "qmd.css"), in the "scripts" folder.
#'  \item \code{format = "github_site"}: a quarto website in the "scripts" folder and a GitHub action to publish it (see details).
#'  \item \code{readme = TRUE}: "README.Rmd" (and its rendered "README.md").
#'  \item \code{Rproj = TRUE}: an R project file ("name.Rproj").
#'  \item \code{renv = TRUE}: renv files ("renv.lock", ".Rprofile" and "renv" folder).
#' }
#' @seealso \code{\link{compendiums}}, \code{\link{print_skeleton}}
#' @export
#' @name make_compendium
#' @details The function takes predefined folder structures to generate the directory skeleton of a research compendium.
#'
#' The format "github_site" sets up a project that is published as a website on GitHub Pages (see \url{https://github.com/maRce10/suwo_publication} for an example). The 'scripts' folder is a quarto website ('_quarto.yml', 'index.qmd' home page and 'analysis.qmd' analysis template) and '.github/workflows/publish.yml' contains a GitHub action that renders and publishes the site every time changes are pushed to the 'main' (or 'master') branch. Pages rendered locally are not re-run on GitHub: their results are taken from the 'scripts/_freeze' folder (\code{execute: freeze: true}), which must be committed. Without renv, only the packages needed to replay these results are installed on GitHub, so the site must be rendered locally ('quarto render' within 'scripts/') before pushing. With \code{renv = TRUE} the packages recorded in 'renv.lock' are installed on GitHub, so pages that have not been rendered locally are run there (data used must be committed too). In this case a 'scripts/.Rprofile' file is added so renv is also activated when quarto renders the site from the 'scripts' folder. To publish the site, push the project to GitHub and set 'Source' to 'GitHub Actions' in the repository Settings > Pages. Note that \href{https://quarto.org}{quarto} must be installed.
#' @examples {
#' data(compendiums)
#'
#' # default format
#' make_compendium(name = "mycompendium", path = tempdir(), format = "basic",
#' force = TRUE)
#'
#' # quarto website to be published on GitHub Pages
#' make_compendium(name = "my_site_compendium", path = tempdir(),
#'  format = "github_site", force = TRUE)
#'
#' # custom format
#' make_compendium(name = "my_second_compendium", path = tempdir(),
#'  format = c("folder_1", "folder_1/subfolder_1", "folder_1/subfolder_2"),
#'  force = TRUE)
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references
#' Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom Research Compendiums. R package (run \code{citation("sketchy")} for the current version).
#'
#' Marwick, B., Boettiger, C., & Mullen, L. (2018). Packaging Data Analytical Work Reproducibly Using R (and Friends). American Statistician, 72(1), 80-88.
#'
#' Alston, J., & Rick, J. (2020). A Beginners Guide to Conducting Reproducible Research.
#last modification on dec-26-2019 (MAS)

make_compendium <-
  function(name = "research_compendium",
           path = ".",
           force = FALSE,
           format = "basic",
           packrat = FALSE,
           git = FALSE,
           clone = NULL,
           readme = TRUE,
           Rproj = FALSE,
           renv = FALSE)
  {
    # packrat is deprecated
    if (packrat) {
      .warning("'packrat' is deprecated (packrat has been superseded by renv), use 'renv = TRUE' instead")
      renv <- TRUE
    }

    if (renv && !requireNamespace("renv", quietly = TRUE))
      .stop("must install 'renv' to use 'renv = TRUE'")

    # built-in formats (works even if sketchy is not attached)
    compendiums <- sketchy::compendiums

    # folder comments (only available for built-in formats)
    comments_vector <- NULL

    # save format
    org_format <- format[1]

    # allow format name or skeleton from list
    if (!is.character(format))
      .stop("'format' must either be a character vector") else
      if (length(format) == 1)
        if (!format %in% names(compendiums))
          .stop("'format' not found (must be one of those in 'names(compendiums)')") else {

        comments_vector <- compendiums[[format]]$comments

        format <- compendiums[[format]]$skeleton
    }

    # clone folder structure
    if (!is.null(clone)) {
      cat(crayon::green("Cloning directories ...\n"))

      # get clone structure
      format <-
        list.dirs(path = clone,
                  full.names = FALSE,
                  recursive = TRUE)

      # remove git R and devtools folders
      format <-
        grep(
          "^\\.git($|/)|^\\.Rproj.user|^\\.\\.Rcheck|^\\.quarto",
          format,
          value = TRUE,
          invert = TRUE
        )

      # remove empty elements
      format <- format[!format %in%  c("", " ")]

      # built-in comments don't apply to cloned structures
      comments_vector <- NULL
    }

    dir <- file.path(path, name)

    if (!file.exists(dir))
      cat(crayon::green("Creating directories ...\n")) else
      cat(crayon::green("Setting project on an existing directory ...\n"))

    if (dir_existed <- file.exists(dir) && !force)
      .stop(gettextf("directory '%s' already exists", dir),
            domain = NA) else
    .safe_dir_create(dir)

    for (i in format)
      .safe_dir_create(file.path(dir, i))

    if (any(basename(format) == "manuscript")) {
      # create manuscript.Rmd
      if (!file.exists(file.path(
        path,
        name,
        grep(
          "manuscript$|^docs$|^doc$",
          format,
          ignore.case = TRUE,
          value = TRUE
        )[1],
        "manuscript.Rmd"
      )))
        writeLines(
          internal_files$manuscript_template,
          file.path(
            path,
            name,
            grep(
              "manuscript$|^docs$|^doc$",
              format,
              ignore.case = TRUE,
              value = TRUE
            )[1],
            "manuscript.Rmd"
          )
        )

      # create apa.csl
      if (!file.exists(file.path(
        path,
        name,
        grep(
          "manuscript$|^docs$|^doc$",
          format,
          ignore.case = TRUE,
          value = TRUE
        )[1],
        "apa.csl"
      )))
        writeLines(internal_files$apa.csl,
                   file.path(
                     path,
                     name,
                     grep(
                       "manuscript$|^docs$|^doc$",
                       format,
                       ignore.case = TRUE,
                       value = TRUE
                     )[1],
                     "apa.csl"
                   ))

      # create example_library
      if (!file.exists(file.path(
        path,
        name,
        grep(
          "manuscript$|^docs$|^doc$",
          format,
          ignore.case = TRUE,
          value = TRUE
        )[1],
        "references.bib"
      )))
        writeLines(
          internal_files$example_library,
          file.path(
            path,
            name,
            grep(
              "manuscript$|^docs$|^doc$",
              format,
              ignore.case = TRUE,
              value = TRUE
            )[1],
            "references.bib"
          )
        )
    }

    if (org_format[1] == "sketchy") {
      # save analysis template in Rmarkdown format
      if (!file.exists(file.path(
        path,
        name,
        grep(
          "scripts$",
          format,
          ignore.case = TRUE,
          value = TRUE
        )[1],
        "analysis_template_rmarkdown.Rmd"
      ))){
        rmarkdown_template <- internal_files$analysis_template_rmarkdown
        rmarkdown_template[3] <- paste("subtitle:", name)

        writeLines(
          rmarkdown_template,
          file.path(
            path,
            name,
            grep(
              "scripts$",
              format,
              ignore.case = TRUE,
              value = TRUE
            )[1],
            "analysis_template_rmarkdown.Rmd"
          )
        )
        }

      # save analysis template in quarto format
      if (!file.exists(file.path(
        path,
        name,
        grep(
          "scripts$",
          format,
          ignore.case = TRUE,
          value = TRUE
        )[1],
        "analysis_template_quarto.qmd"
      ))){
        # change subtitle
        quarto_template <- internal_files$analysis_template_quarto
        quarto_template[3] <- paste("subtitle:", name)

        writeLines(
          quarto_template,
          file.path(
            path,
            name,
            grep(
              "scripts$",
              format,
              ignore.case = TRUE,
              value = TRUE
            )[1],
            "analysis_template_quarto.qmd"
          )
        )
}
      # save rmd.css
      if (!file.exists(file.path(
        path,
        name,
        grep(
          "scripts$",
          format,
          ignore.case = TRUE,
          value = TRUE
        )[1],
        "rmd.css"
      )))
        writeLines(internal_files$rmd_css,
                   file.path(
                     path,
                     name,
                     grep(
                       "scripts$",
                       format,
                       ignore.case = TRUE,
                       value = TRUE
                     )[1],
                     "rmd.css"
                   ))

      # save qmd_css
      if (!file.exists(file.path(
        path,
        name,
        grep(
          "scripts$",
          format,
          ignore.case = TRUE,
          value = TRUE
        )[1],
        "qmd.css"
      )))
        writeLines(internal_files$qmd_css,
                   file.path(
                     path,
                     name,
                     grep(
                       "scripts$",
                       format,
                       ignore.case = TRUE,
                       value = TRUE
                     )[1],
                     "qmd.css"
                   ))
    }

    if (org_format[1] == "github_site") {
      scripts_dir <- file.path(dir, "scripts")

      # github action to render and publish the quarto site
      .write_if_missing(internal_files$site_workflow,
                        file.path(dir, ".github", "workflows", "publish.yml"))

      # quarto website files
      .write_if_missing(gsub("PROJECT_NAME", name, internal_files$site_quarto_yml, fixed = TRUE),
                        file.path(scripts_dir, "_quarto.yml"))
      .write_if_missing(gsub("PROJECT_NAME", name, internal_files$site_index, fixed = TRUE),
                        file.path(scripts_dir, "index.qmd"))

      analysis_page <- internal_files$analysis_template_quarto
      analysis_page[3] <- paste("subtitle:", name)
      .write_if_missing(analysis_page, file.path(scripts_dir, "analysis.qmd"))

      .write_if_missing(internal_files$site_fig_download, file.path(scripts_dir, "fig_download.html"))
      .write_if_missing(internal_files$site_qmd_css, file.path(scripts_dir, "qmd.css"))
      .write_if_missing(internal_files$site_scripts_gitignore, file.path(scripts_dir, ".gitignore"))
      .write_if_missing(internal_files$site_gitignore, file.path(dir, ".gitignore"))
    }

    # initiate git
    if (git) {
      # error message if git2r is not installed
      if (!requireNamespace("git2r", quietly = TRUE))
        .stop("must install 'git2r' to use 'git'") else
        git2r::init(path = file.path(path, name))
    }

    # create Rproj file
    if (Rproj)  {
      x <-
        c(
          "Version: 1.0",
          "",
          "RestoreWorkspace: Default",
          "SaveWorkspace: Default",
          "AlwaysSaveHistory: Default",
          "",
          "EnableCodeIndexing: Yes",
          "UseSpacesForTab: Yes",
          "NumSpacesForTab: 4",
          "Encoding: UTF-8",
          "",
          "RnwWeave: knitr",
          "LaTeX: pdfLaTeX"
        )

      cat(paste(x, collapse = "\n"), file = file.path(dir, paste0(name, ".Rproj")))
    }

    if (readme)
      if (!file.exists(file.path(dir, "README.Rmd"))) {
        readme_file <- internal_files$readme_template

        # add project name to file
        readme_file[2] <- paste('title:', name)
        writeLines(readme_file, file.path(dir, "README.Rmd"))

        rmarkdown::render(file.path(dir, "README.Rmd"), quiet = TRUE, output_format = "md_document")
      } else
        cat(crayon::green("README.Rmd already exists.\n"))

    # initiate renv (after all files are written so their packages are recorded)
    if (renv) {
      # activate renv also when quarto renders the site from 'scripts/'
      if (org_format[1] == "github_site")
        .write_if_missing(internal_files$site_scripts_rprofile, file.path(dir, "scripts", ".Rprofile"))

      cat(crayon::green("Initializing renv ...\n"))
      # snapshot type "all" records all packages installed in the project library, including those
      # installed by the templates' package lists (not detected by renv's code scanning)
      renv::init(project = normalizePath(dir), settings = list(snapshot.type = "all"),
                 load = FALSE, restart = FALSE)
    }

    print_skeleton(path = file.path(path, name), comments = comments_vector)

    if (org_format[1] == "github_site")
      cat(crayon::magenta(paste0(
        "\nTo publish the site on GitHub Pages:\n",
        "  1. Replace 'USER' with your GitHub user name in 'scripts/_quarto.yml' and 'scripts/index.qmd'\n",
        if (renv)
          "  2. Pages are run on GitHub with the packages in 'renv.lock' (update it with renv::snapshot()). For heavy analyses or data not committed to the repository, render the site locally ('quarto render' within 'scripts/') and commit the 'scripts/_freeze' folder\n" else
          "  2. Render the site locally ('quarto render' within 'scripts/') and commit the 'scripts/_freeze' folder (use 'renv = TRUE' to run pages on GitHub instead)\n",
        "  3. Push the project to a GitHub repository\n",
        "  4. In the repository go to Settings > Pages and set 'Source' to 'GitHub Actions'\n\n"
      )))

    cat(crayon::green("Done.\n"))


  }

