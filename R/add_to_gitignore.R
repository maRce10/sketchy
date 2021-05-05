#' Add entries to gitignore
#'
#' \code{add_to_gitignore} adds entries to gitignore files
#' @usage add_to_gitignore(add.to.gitignore = FALSE, cutoff = 99, extension = NULL)
#' @param add.to.gitignore Logical to control if files are added to 'gitignore' or just printed on the console.
#' @param cutoff Numeric. Defines the file size (in MB) cutoff used to find files (i.e. only files above the threshold would returned). 99 (MB) is recommended when hosting projects at github as the current file size limit is 100 MB. Default is 99.
#' @param extension Character string to define the file extension of the files to be searched for.
#' @return Prints the name of the files matching the searching parameters. If \code{add.to.ignore = TRUE} the files matching the search parameters ('cutoff' and/or 'extension') would be added 'gitignore' (a file used by git to exclude files form version control, including adding them to github). Hence this can be used to avoid conflicts when working with large files or just avoid adding non-binary files to remote repositories.
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
#' # add_to_gitignore(add.to.gitignore = TRUE)
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references {
#' Araya-Salas, M., Willink, B., Arriaga, A. (2020), sketchy: research compendiums for data analysis in R. R package version 1.0.0.
#' }
#last modification on apr-2021 (MAS)

add_to_gitignore <- function(add.to.gitignore = FALSE, cutoff = 99, extension = NULL){

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

  # check gitignore
  if (file.exists(".gitignore")){

    gitignore <- gsub(" # large file", "", readLines(".gitignore"))

    files_found_not_ignore <- files_found[!files_found %in% gitignore]

    to_gitignore <- unique(c(gitignore, files_found_not_ignore))

    to_gitignore <- to_gitignore[to_gitignore != ""]

    to_gitignore <- paste(to_gitignore, "# large file")

    } else{
      to_gitignore <- paste(files_found, "# large file") # if no gitignore file
      gitignore <- vector()
      }

  if (add.to.gitignore){

    # if (!file.exists(".gitignore"))
    #   stop("'.gitignore' file not found, has git been initialized on this repository?")

  writeLines(text = to_gitignore, con = ".gitignore")
  }

  if (length(files_found) > 0){
  if (is.null(extension))
  exit_ms <- paste0(crayon::magenta("The following file(s) exceed(s) the cutoff size:"),"\n", paste(files_found, collapse = "\n"), "\n") else
    exit_ms <- paste0(crayon::magenta("The following file(s) match(es) the extension and exceed(s) the cutoff size:"),"\n", paste(files_found, collapse = "\n"), "\n")

  } else exit_ms <- paste0(crayon::magenta("No files were found"))

  cat(exit_ms)

  if (add.to.gitignore)
    if (all(files_found %in% gitignore))
       cat(crayon::magenta("\nThe files were already in '.gitignore' (no new files added)")) else
         cat(paste0(crayon::magenta("\nFile(s) added to '.gitignore':"),"\n", paste(setdiff(files_found, gitignore), collapse = "\n"), "\n"))


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
