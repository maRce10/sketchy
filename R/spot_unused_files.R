#' Spot/remove unused image and data files
#'
#' \code{spot_unused_files} allow user to identify and optionally archive unused image or data files in a project directory
#' @param path A character string with the path to the directory to be analyzed. Default is current directory.
#' @param file.extensions A character vector with the file extensions to be considered. By default the function looks for the following image and file extensions: "png", "jpg", "jpeg", "gif", "bmp", "tiff", "tif", "csv", "xls", "xlsx" and "txt".
#' @param script.extensions A character vector with the script extensions to be considered. Default is c("R", "Rmd", "qmd").
#' @param archive A logical value indicating whether to archive the unused files. If \code{TRUE} the spotted files will be moved into the folder "archive" within 'path', keeping their original sub-folder structure. Default is \code{FALSE}.
#' @param ignore.folder A character string with the path or paths to the directory(ies) to be ignored. Default is \code{NULL}.
#' @param remove.empty A logical value indicating whether to remove empty folders within 'path' after moving the unused files. Hidden folders (e.g. '.git') and their contents are never removed. Default is \code{FALSE}.
#' @seealso \code{\link{add_to_gitignore}}, \code{\link{make_compendium}}
#' @export
#' @name spot_unused_files
#' @returns A data frame with 2 columns: file.name (self explanatory) and folder (where the file was found) with the unused files. If no unused files are found \code{NULL} is returned invisibly.
#' @details This function is used to spot/archive unused files in a project directory. The function searches recursively for all script files ('script.extensions') and all files with the target extensions ('file.extensions'). A file is considered unused when its name is not found in any of the scripts. Files already in the "archive" folder are ignored. It is useful to keep the project directory clean and organized. It is recommended to first run the function with \code{archive = FALSE} to check which files are spotted and then run \code{archive = TRUE} to move them into the "archive" folder.
#' @examples
#' \dontrun{
#' spot_unused_files(path = "path/to/your/project")
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references
#' Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom Research Compendiums. R package (run \code{citation("sketchy")} for the current version).
#'

spot_unused_files <-
  function(path = ".",
           file.extensions = c("png",
                               "jpg",
                               "jpeg",
                               "gif",
                               "bmp",
                               "tiff",
                               "tif",
                               "csv",
                               "xls",
                               "xlsx",
                               "txt"),
           script.extensions = c("R", "Rmd", "qmd"),
           archive = FALSE,
           ignore.folder = NULL,
           remove.empty = FALSE) {
    path <- normalizePath(path, winslash = "/")
    archive_folder <- file.path(path, "archive")

    # List all target format files
    all_files <-
      .list_files(directory = path, extensions = file.extensions)
    script_files <- .list_files(directory = path, extensions = script.extensions)

    # exclude files already archived
    all_files <- all_files[!startsWith(all_files, paste0(archive_folder, "/"))]

    # ignore folders
    if (!is.null(ignore.folder)) {
      ignore.folder <- paste0(normalizePath(ignore.folder, winslash = "/", mustWork = FALSE), "/")
      ignored <- vapply(all_files, function(x) any(startsWith(x, ignore.folder)), logical(1))
      all_files <- all_files[!ignored]
    }

    # Check which files are referenced
    used_files <-
      vapply(all_files, .is_file_used, code_files = script_files, FUN.VALUE = logical(1))

    # Create a data frame with the results
    results <- data.frame(
      file.name = basename(all_files),
      folder = if (length(all_files) > 0) paste0(dirname(all_files), "/") else character(0),
      used = used_files,
      row.names = NULL
    )

    if (nrow(results) == 0) {
      message("No files with the specified extensions were found.")
    }

    # keep only unused files
    results <- results[!results$used, , drop = FALSE]

    if (nrow(results) == 0 && length(all_files) > 0) {
      message("All files are referenced in the code.")
    }

    # Move unused files to "archive" folder keeping sub-folder structure
    if (archive && nrow(results) > 0) {
      from <- file.path(results$folder, results$file.name)
      to <- file.path(archive_folder, substring(from, nchar(path) + 2))

      for (d in unique(dirname(to)))
        dir.create(d, recursive = TRUE, showWarnings = FALSE)

      copied <- file.copy(from = from, to = to, overwrite = FALSE)

      if (any(copied))
        unlink(from[copied])

      if (any(!copied))
        .warning(paste0("The following files could not be archived (a file with the same name may already exist in 'archive'): ",
                        paste(from[!copied], collapse = ", ")))
    }

    # remove empty folders
    if (remove.empty) {
      # find empty folders, skipping 'path' itself and hidden folders
      all_dirs <- list.dirs(path, recursive = TRUE, full.names = TRUE)
      all_dirs <- all_dirs[all_dirs != path]
      rel_dirs <- substring(all_dirs, nchar(path) + 2)
      all_dirs <- all_dirs[!grepl("(^|/)\\.", rel_dirs)]

      empty_dirs <- all_dirs[vapply(all_dirs, function(x) length(list.files(x, all.files = TRUE, no.. = TRUE)) == 0, logical(1))]

      if (length(empty_dirs) > 0) {
        message(paste("Removing", length(empty_dirs), "empty folders:"))
        print(empty_dirs)

        # remove empty folders
        unlink(empty_dirs, recursive = TRUE)
      }
    }

    if (nrow(results) > 0)
      return(results[, c("file.name", "folder")]) else
        return(invisible(NULL))
  }
