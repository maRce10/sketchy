#internal function

# stop function that doesn't print call
.stop <- function(...) {
  stop(..., call. = FALSE)
}

# create directory without replacing it
.safe_dir_create <- function(path) {
  if (!dir.exists(path) && !dir.create(path))
    .stop(gettextf("cannot create directory '%s'", path),
          domain = NA)
}

## copied from utils:::.format_object_size
.format_object_size <- function (x, units = "b", standard = "auto", digits = 1L, ...)
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
            .stop("For SI units, specify 'standard = \"SI\"'")
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
      .stop(gettextf("Unit \"%s\" is not part of standard \"%s\"",
                     sQuote(units), sQuote(standard)), domain = NA)
  }
  unit <- units_map[power + 1L]
  if (power == 0 && standard == "legacy")
    unit <- "bytes"
  paste(round(x/base^power, digits = digits), unit)
}

# warning function that doesn't print call
.warning <- function(x, color = "magenta") {
  warning(.colortext(x, as = color), call. = FALSE)
}

# message function that changes colors
.message <- function(x, color = "black") {
  message(.colortext(x, as = color))
}

# coloring text
.colortext <-
  function(text,
           as = c("red",
                  "blue",
                  "green",
                  "magenta",
                  "cyan",
                  "orange",
                  "black",
                  "silver")) {
    if (.has_color()) {
      unclass(cli::make_ansi_style(.baRulho_style(as))(text))
    } else {
      text
    }
  }

.has_color <- function() {
  cli::num_ansi_colors() > 1
}

.baRulho_style <-
  function(color = c("red",
                     "blue",
                     "green",
                     "magenta",
                     "cyan",
                     "orange",
                     "black",
                     "silver")) {
    type <- match.arg(color)

    c(
      red = "red",
      blue = "blue",
      green = "green",
      magenta = "magenta",
      cyan = "cyan",
      orange = "orange",
      black = "black",
      silver = "silver"
    )[[color]]
  }


# Flatten copy

# #details
# Copy all `.Rmd`, `.qmd`, and `.md` files from source to destination,
# rename the `.qmd` and `.md` files with an additional `.Rmd` extension,
# and get a flat destination structure with path-preserving file names.
# #param from Source directory path.
# #param to Destination directory path.
# taken from https://nanx.me/blog/post/rmarkdown-quarto-link-checker/
#
# #return Destination directory path.
.flatten_copy <- function(from, to) {
  rmd <- list.files(from, pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  xmd <- list.files(from, pattern = "\\.qmd$|\\.md$", recursive = TRUE, full.names = TRUE)

  src <- c(rmd, xmd)
  dst <- c(rmd, paste0(xmd, ".Rmd"))

  # Remove starting `./` (if any)
  dst <- gsub("^\\./", replacement = "", x = dst)
  # Replace the forward slash in path with Unicode big solidus
  dst <- gsub("/", replacement = "\u29F8", x = dst)

  file.copy(src, to = file.path(to, dst))

  invisible(to)
}


# Function to list all files with specific extensions in a directory
.list_files <- function(directory, extensions) {
  files <- list.files(directory, pattern = paste0(paste0(".", extensions, "$"), collapse = "|"), full.names = TRUE, recursive = TRUE)
  files <- normalizePath(files)
  return(files)
}

# Function to check if an image file is referenced in a code file
.is_file_used <- function(file.name, code_files) {
  image_name <- basename(file.name)
  for (code_file in code_files) {
    file_content <- readLines(code_file, warn = FALSE)
    if (any(str_detect(file_content, fixed(image_name)))) {
      return(TRUE)
    }
  }
  return(FALSE)
}

