#' Spot/remove unused files
#'
#' \code{spot_unused_files}
#' @param path A character string with the path to the directory to be analyzed. Default is current directory.
#' @param file.extensions A character vector with the file extensions to be considered. Default is c("png", "jpg", "jpeg", "gif", "bmp", "tiff", "tif", "csv", "xls", "xlsx", "txt").
#' @param script.extensions A character vector with the script extensions to be considered. Default is c("R", "Rmd", "qmd").
#' @param archive A logical value indicating whether to archive the unused files. If \code{TRUE} the spotted files will be move into the folder "./unused_files". Default is \code{FALSE}.
#' @param ignore.folder A character string with the path or paths to the directory(ies) to be ignored. Default is "./docs".
#' @seealso \code{\link{add_to_gitignore}}, \code{\link{make_compendium}}
#' @export
#' @name spot_unused_files
#' @returns Returns a data frame with 2 columns: file.name (self explanatory) and folder (where the file is found).
#' @details This function is used to spot/remove unused files in a project directory. It is useful to keep the project directory clean and organized. It is recommended to first run the function with a the argument \code{archive = FALSE} to spot which files are being spotted and then run \code{archive = TRUE} if they need to be removed.
#' @examples {
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references {
#' Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for data analysis in R. R package version 1.0.3.
#' }


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
           ignore.folder = "./docs") {
    # List all files in the specified directory with the specified extensions
    # List all images and code files
    all_files <-
      .list_files(directory = path, extensions = file.extensions)
    script_files <- .list_files(directory = path, script.extensions)

    # Check which images are referenced
    used_files <-
      sapply(all_files, .is_file_used, code_files = script_files)

    # Create a data frame with the results
    results <- data.frame(
      file.name = basename(all_files),
      folder = paste0(dirname(all_files), "/"),
      used = used_files,
      row.names = NULL
    )

    results <- results[basename(results$folder) != "unused_files",]

    # ignore folders
    results <-
      results[grep(paste(paste0(normalizePath(ignore.folder), "/"),  collapse = "|"), results$folder, invert = TRUE),]

    # keep only unused files
    results <- results[!results$used,]

    # Move unused files to "unused" folder
    if (nrow(results) == 0) {
      message("All files are referenced in the code.")
    } else
      if (archive) {
        unused_folder <- file.path(".", "unused_files")

        # Create "unused" folder if it doesn't exist
        if (!dir.exists(unused_folder)) {
          dir.create(unused_folder)
        }

        # Move unused images
        if (any(!results$used)) {
          copied <-
            file.copy(from = file.path(results$folder, results$file.name),
                      to = unused_folder)

          if (any(copied))
            unlink(file.path(results$folder, results$file.name)[copied])
          else
            warning("No files were copied")
        }
      }

    if (nrow(results) > 0)
      return(results[, c(1, 2)])
  }
