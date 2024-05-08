#' Add entries to gitignore
#'
#' \code{add_to_gitignore} adds entries to gitignore based on file extension or file size
#' @usage add_to_gitignore(add.to.gitignore = FALSE, cutoff = NULL, extension = NULL, path = ".")
#' @param add.to.gitignore Logical to control if files are added to 'gitignore' or just printed on the console.
#' @param cutoff Numeric. Defines the file size (in MB) cutoff used to find files (i.e. only files above the threshold would returned). 99 (MB) is recommended when hosting projects at github as the current file size limit is 100 MB.
#' @param extension Character string to define the file extension of the files to be searched for.
#' @param path Path to the project directory. Default is current directory.
#' @return Prints the name of the files matching the searching parameters. If \code{add.to.ignore = TRUE} the files matching the search parameters ('cutoff' and/or 'extension') would be added 'gitignore' (a file used by git to exclude files form version control, including adding them to github).
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
#' @references {
#' Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for data analysis in R. R package version 1.0.3.
#' }

add_to_gitignore <- function(add.to.gitignore = FALSE, cutoff = NULL, extension = NULL, path = "."){

  if (is.null(cutoff) & is.null(extension))
    .stop("'cutoff' and/or 'extension' must be supplied")

  # get files list
  if (is.null(extension))
    fls <- list.files(recursive = TRUE, full.names = FALSE, path = path) else
      fls <- list.files(recursive = TRUE, full.names = FALSE, pattern = paste0("\\.", gsub(".", "", extension, fixed = TRUE), "$"), path = path)

    if (is.null(cutoff))
      cutoff <- -1

    #  get size info
    fi <- file.info(file.path(path, fls))

    # order by size
    fi <- fi[order(-fi$size), ]

    # get size in MB
    # file_size <- sapply(fi$size, function(x) .format_object_size(x, "MB"))
    file_size <- fi$size / 1000000

    # put it in a data.frame
    file_size_df <- data.frame(file.path = rownames(fi), file_size_Mb = as.numeric(gsub(" Mb","", file_size)))

    # get big files
    files_found <- file_size_df$file.path[file_size_df$file_size_Mb > cutoff]

    # remove project directory
    files_found <- gsub(path, "", files_found)

    # remove ./
    files_found <- gsub("^./", "", files_found)
    files_found <- gsub("^/", "", files_found)

    if (!file.exists(file.path(path, ".gitignore"))){
      writeLines(text = "", con = file.path(path, ".gitignore"))
      cat(crayon::magenta("'.gitignore' file not found so it was created"))
      gitignore <- vector()
    } else
      gitignore <- readLines(file.path(path, ".gitignore"))

    files_found_not_ignore <- if (length(gitignore) > 0) grep(paste(gitignore, collapse = "|"), files_found, value = TRUE, invert = TRUE) else files_found

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

    if (length(files_found_not_ignore) > 0 & add.to.gitignore & length(files_found) > 0) cat(paste0(crayon::magenta("\nFile(s) added to '.gitignore':"),"\n", paste(files_found_not_ignore, collapse = "\n"), "\n"))

    if (length(files_found_not_ignore) == 0 & add.to.gitignore) cat(crayon::magenta("\nNo new files were added '.gitignore'"))

}
