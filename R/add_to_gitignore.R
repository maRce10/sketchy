#' Add entries to gitignore
#'
#' \code{add_to_gitignore} adds entries to gitignore based on file extension or file size
#' @usage add_to_gitignore(add.to.gitignore = FALSE, cutoff = NULL, extension = NULL, path = ".")
#' @param add.to.gitignore Logical to control if files are added to 'gitignore' or just printed on the console.
#' @param cutoff Numeric. Defines the file size (in MB) cutoff used to find files (i.e. only files above the threshold would returned). 99 (MB) is recommended when hosting projects at github as the current file size limit is 100 MB.
#' @param extension Character string to define the file extension of the files to be searched for.
#' @param path Path to the project directory. Default is current directory.
#' @return Prints the name of the files matching the searching parameters and invisibly returns them (paths relative to 'path'). If \code{add.to.gitignore = TRUE} the files matching the search parameters ('cutoff' and/or 'extension') are added to '.gitignore' (a file used by git to exclude files from version control, including adding them to github), using their path relative to 'path'. Files already listed in '.gitignore' are not added again.
#' @seealso \code{\link{compendiums}}, \code{\link{make_compendium}}
#' @export
#' @name add_to_gitignore
#' @details The function can be used to avoid conflicts when working with large files or just avoid adding non-binary files to remote repositories. It mostly aims to simplify spotting/excluding large files. Note that file names can be manually added to the '.gitignore' file using a text editor.
#' @examples {
#' data(compendiums)
#'
#' make_compendium(name = "my_compendium", path = tempdir(),
#'  format = "basic", force = TRUE)
#'
#' # save a file
#' write.csv(iris, file.path(tempdir(), "my_compendium", "iris.csv"))
#'
#' # add the file to gitignore
#' add_to_gitignore(add.to.gitignore = TRUE,
#' path = file.path(tempdir(), "my_compendium"), extension = "csv")
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references
#' Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom Research Compendiums. R package (run \code{citation("sketchy")} for the current version).

add_to_gitignore <- function(add.to.gitignore = FALSE, cutoff = NULL, extension = NULL, path = "."){

  # ensure the path is in the correct format for your system
  path <- normalizePath(path)

  if (is.null(cutoff) & is.null(extension))
    .stop("'cutoff' and/or 'extension' must be supplied")

  # get files list (paths relative to 'path')
  if (is.null(extension))
    fls <- list.files(recursive = TRUE, full.names = FALSE, path = path) else
      fls <- list.files(recursive = TRUE, full.names = FALSE, pattern = paste0("\\.", gsub(".", "", extension, fixed = TRUE), "$"), path = path)

  # get size in MB
  file_size <- file.info(file.path(path, fls))$size / 1000000

  # get big files (ordered by size)
  size_cutoff <- if (is.null(cutoff)) -1 else cutoff
  files_found <- fls[order(-file_size)][sort(file_size, decreasing = TRUE) > size_cutoff]

  # use forward slashes as required by git
  files_found <- gsub("\\\\", "/", files_found)

  if (!file.exists(file.path(path, ".gitignore"))){
    writeLines(text = "", con = file.path(path, ".gitignore"))
    cat(crayon::magenta("'.gitignore' file not found so it was created"))
    gitignore <- vector()
  } else
    gitignore <- readLines(file.path(path, ".gitignore"))

  # files not already listed in .gitignore (exact match, with or without leading slash)
  files_found_not_ignore <- files_found[!files_found %in% sub("^/", "", trimws(gitignore))]

  gitignore2 <- unique(c(gitignore, files_found_not_ignore))

  gitignore2 <- gitignore2[gitignore2 != ""]

  if (add.to.gitignore)
    writeLines(text = gitignore2, con = file.path(path, ".gitignore"))

  if (length(files_found) > 0){
    if (is.null(extension))
      exit_ms <- paste0(crayon::magenta("\nThe following file(s) exceed(s) the cutoff size:"),"\n", paste(files_found, collapse = "\n"), "\n")

    if (is.null(cutoff))
      exit_ms <- paste0(crayon::magenta("\nThe following file(s) match(es) the extension:"),"\n", paste(files_found, collapse = "\n"), "\n")

    if (!is.null(cutoff) & !is.null(extension))
      exit_ms <- paste0(crayon::magenta("\nThe following file(s) match(es) the extension and exceed(s) the cutoff:"),"\n", paste(files_found, collapse = "\n"), "\n")

  } else exit_ms <- paste0(crayon::magenta("\nNo files were found"))

  cat(exit_ms)

  if (length(files_found_not_ignore) > 0 & add.to.gitignore) cat(paste0(crayon::magenta("\nFile(s) added to '.gitignore':"),"\n", paste(files_found_not_ignore, collapse = "\n"), "\n"))

  if (length(files_found_not_ignore) == 0 & add.to.gitignore & length(files_found) > 0) cat(crayon::magenta("\nNo new files were added to '.gitignore'\n"))

  invisible(files_found)
}
