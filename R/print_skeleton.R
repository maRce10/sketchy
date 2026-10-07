#' Print folder structures
#'
#' \code{print_skeleton} prints the folder structure of a research compendium.
#' @usage print_skeleton(path = ".", comments = NULL, folders = NULL)
#' @param path path to the directory to be printed. Default is current directory.
#' @param comments A character vector with the comments to be added to folders in the graphical representation of the folder skeleton printed on the console. If named, names must match folder paths (e.g. \code{c("data/raw" = "raw data")}) and only some folders can be commented. If unnamed, it must have one element per folder (in alphabetical order of folder paths).
#' @param folders A character vector including the name of the sub-directories of the project. If supplied, 'path' is only used as the name of the root folder in the printed tree (e.g. \code{path = "my_project"}).
#' @return The folder skeleton is printed in the console. A \code{cli_tree} object (see \code{\link[cli]{tree}}) is returned invisibly.
#' @seealso \code{\link{compendiums}}, \code{\link{make_compendium}}
#' @export
#' @name print_skeleton
#' @details The function prints the folder structure of an existing project.
#' @examples {
#' data(compendiums)
#'
#'make_compendium(name = "my_other_compendium", path = tempdir(), format = "basic",
#' force = TRUE)
#'
#'print_skeleton(path = file.path(tempdir(), "my_other_compendium"))
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references
#' Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom Research Compendiums. R package (run \code{citation("sketchy")} for the current version).

print_skeleton <- function(path = ".", comments = NULL, folders = NULL)
  {

  # get structure
  folders_supplied <- !is.null(folders)
  if (!folders_supplied)
    folders <- list.dirs(path = path, full.names = FALSE, recursive = TRUE)

  # remove git R and devtools folders
  folders <- grep("^\\.git($|/)|^\\.Rproj.user|^\\.\\.Rcheck|^\\.quarto|^renv/|^packrat/", folders, value = TRUE, invert = TRUE)

  # remove empty elements and trailing slashes
  folders <- sub("/+$", "", folders[!folders %in% c("", " ")])

  # add missing parent folders (e.g. "a" for "a/b")
  parents <- unlist(lapply(strsplit(folders, "/", fixed = TRUE), function(x)
    if (length(x) > 1) vapply(seq_len(length(x) - 1), function(i) paste(x[seq_len(i)], collapse = "/"), character(1))))
  folders <- sort(unique(c(folders, parents)))

  # match comments to folders
  folder_comments <- rep("", length(folders))
  names(folder_comments) <- folders

  if (!is.null(comments)) {
    if (is.null(names(comments))) {
      if (length(comments) != length(folders))
        .stop(paste0(length(folders), " folders found but ", length(comments), " elements in 'comments' (use a named vector to comment only some folders)"))

      folder_comments[] <- comments
    } else {
      names(comments) <- sub("/+$", "", names(comments))

      if (!all(names(comments) %in% folders))
        .stop("not all names in 'comments' have a folder counterpart")

      folder_comments[names(comments)] <- comments
    }
  }

  folder_comments[is.na(folder_comments)] <- ""

  # get name of project to be printed (when 'folders' is supplied 'path' is only a label)
  name <- if (folders_supplied) basename(path) else basename(normalizePath(path, mustWork = FALSE))

  # build tree data: root + one node per folder
  parent <- ifelse(grepl("/", folders, fixed = TRUE), dirname(folders), ".root")

  labels <- paste0(basename(folders), "/")
  labels <- ifelse(folder_comments == "", labels, paste(labels, cli::col_silver(paste("#", folder_comments))))

  tree_data <- data.frame(
    id = c(".root", folders),
    stringsAsFactors = FALSE
  )
  tree_data$children <- lapply(tree_data$id, function(x) folders[parent == x])
  tree_data$label <- c(cli::style_bold(name), labels)

  folder_tree <- cli::tree(tree_data, root = ".root")

  print(folder_tree)

  invisible(folder_tree)
}
