#' Add entries to gitignore
#'
#' \code{add_to_gitignore} adds entries to gitignore files
#' @usage add_to_gitignore(add.to.gitignore = FALSE, cutoff = NULL, extension = NULL)
#' @param add.to.gitignore Logical to control if files are added to 'gitignore' or just printed on the console.
#' @param cutoff Numeric. Defines the file size (in MB) cutoff used to find files (i.e. only files above the threshold would returned). 99 (MB) is recommended when hosting projects at github as the current file size limit is 100 MB.
#' @param extension Character string to define the file extension of the files to be searched for.
#' @return Prints the name of the files matching the searching parameters. If \code{add.to.ignore = TRUE} the files matching the search parameters ('cutoff' and/or 'extension') would be added 'gitignore' (a file used by git to exclude files form version control, including adding them to github). Hence this can be used to avoid conflicts when working with large files or just avoid adding non-binary files to remote repositories. This function mostly aims to simplify spotting large files. Note that file names can be manually added to
#' @seealso \code{\link{compendiums}}, \code{\link{make_compendium}}
#' @export
#' @name add_to_gitignore
#' @details The function can be used large size files h.
#' @examples {
#' data(compendiums)
#'
#' make_compendium(name = "my_compendium", path = tempdir(),
#'  format = compendiums$basic$skeleton, force = TRUE)
#'
#' # must start git monitoring at this point
#'
#' # now can add files to gitignore
#' # add_to_gitignore(add.to.gitignore = TRUE)
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references {
#' Araya-Salas, M., Willink, B., Arriaga, A. (2020), sketchy: research compendiums for data analysis in R. R package version 1.0.0.
#' }
#last modification on dec-26-2019 (MAS)

add_to_gitignore <- function(add.to.gitignore = FALSE, cutoff = NULL, extension = NULL){

  if (is.null(cutoff) & is.null(extension))
    stop("'cutoff' and/or 'extension' must be supplied")

  # get files list
  if (is.null(extension))
    fls <- list.files(recursive = TRUE, full.names = TRUE) else
      fls <- list.files(recursive = TRUE, full.names = TRUE, pattern = paste0("\\.", gsub(".", "", extension, fixed = TRUE), "$"))

    if (is.null(cutoff))
      cutoff <- -1

    #  get size info
    fi <- file.info(fls)

    # order by size
    fi <- fi[order(-fi$size), ]

    # get size in MB
    file_size <- sapply(fi$size, function(x) format.object_size(x, "Mb"))

    # put it in a data.frame
    file_size_df <- data.frame(file.path = rownames(fi), file_size_Mb = as.numeric(gsub(" Mb","", file_size)))

    # get big files
    files_found <- file_size_df$file.path[file_size_df$file_size_Mb > cutoff]

    files_found <- gsub("^./", "", files_found)

    if (!file.exists(".gitignore")){
      writeLines(text = "", con = ".gitignore")
      cat(crayon::magenta("'.gitignore' file not found so it was created"))
      gitignore <- vector()
    } else
      gitignore <- readLines(".gitignore")

    files_found_not_ignore <- if (length(gitignore) > 0) grep(paste(gitignore, collapse = "|"), files_found, value = TRUE, invert = TRUE) else files_found

    gitignore2 <- unique(c(gitignore, files_found_not_ignore))

    gitignore2 <- gitignore2[gitignore2 != ""]

    if (add.to.gitignore)
      writeLines(text = gitignore2, con = ".gitignore")

    if (length(files_found) > 0){
      if (is.null(extension))
        exit_ms <- paste0(crayon::magenta("\nThe following file(s) exceed(s) the cutoff size:"),"\n", paste(files_found, collapse = "\n"), "\n") else
          exit_ms <- paste0(crayon::magenta("\nThe following file(s) match(es) the extension:"),"\n", paste(files_found, collapse = "\n"), "\n")

    } else exit_ms <- paste0(crayon::magenta("\nNo files were found"))

    cat(exit_ms)

    if (length(files_found_not_ignore) > 0 & add.to.gitignore & length(files_found) > 0) cat(paste0(crayon::magenta("\nFile(s) added to '.gitignore':"),"\n", paste(files_found_not_ignore, collapse = "\n"), "\n"))

    if (length(files_found_not_ignore) == 0 & add.to.gitignore) cat(crayon::magenta("\nNo new files were added '.gitignore'"))


}

################################################################################

## copied from utils:::format.object_size
format.object_size <- function (x, units = "b", standard = "auto", digits = 1L, ...)
{
  known_bases <- c(legacy = 1024, IEC = 1024, SI = 1000)
  known_units <- list(SI = c("B", "kB", "MB", "GB", "TB", "PB",
                             "EB", "ZB", "YB"), IEC = c("B", "KiB", "MiB", "GiB",
                                                        "TiB", "PiB", "EiB", "ZiB", "YiB"), legacy = c("b", "Kb",
                                                                                                       "Mb", "Gb", "Tb", "Pb"), LEGACY = c("B", "KB", "MB",
                                                                                                                                           "GB", "TB", "PB"))
  units <- match.arg(units, c("auto", unique(unlist(known_units),
                                             use.names = FALSE)))
  standard <- match.arg(standard, c("auto", names(known_bases)))
  if (is.null(digits))
    digits <- 1L
  if (standard == "auto") {
    standard <- "legacy"
    if (units != "auto") {
      if (endsWith(units, "iB"))
        standard <- "IEC" else if (endsWith(units, "b"))
          standard <- "legacy" else if (units == "kB")
            stop("For SI units, specify 'standard = \"SI\"'")
    }
  }
  base <- known_bases[[standard]]
  units_map <- known_units[[standard]]
  if (units == "auto") {
    power <- if (x <= 0)
      0L else min(as.integer(log(x, base = base)), length(units_map) -
                    1L)
  } else {
    power <- match(toupper(units), toupper(units_map)) -
      1L
    if (is.na(power))
      stop(gettextf("Unit \"%s\" is not part of standard \"%s\"",
                    sQuote(units), sQuote(standard)), domain = NA)
  }
  unit <- units_map[power + 1L]
  if (power == 0 && standard == "legacy")
    unit <- "bytes"
  paste(round(x/base^power, digits = digits), unit)
}
