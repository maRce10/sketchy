#' Install and load packages
#'
#' \code{load_packages} installs and loads packages from different repositories.
#'
#' \strong{Superseded}: this function will keep working, but it is no longer recommended. Using it in reports or scripts makes projects depend on 'sketchy'. Install packages with \code{pak::pkg_install()} and load them with \code{library()} instead (as in the templates added by \code{\link{make_compendium}}), and use \code{make_compendium(renv = TRUE)} to record the package versions used in a project. For example:
#' \preformatted{
#' packages <- c("kableExtra", "bioc::ggtree", "maRce10/Rraven")
#' package_names <- sub(".*[/:]", "", sub("@.*$", "", packages))
#' missing <- !vapply(package_names, requireNamespace, logical(1), quietly = TRUE)
#' if (any(missing)) pak::pkg_install(packages[missing])
#' invisible(lapply(package_names, library, character.only = TRUE))
#' }
#' @usage load_packages(packages, quiet = FALSE, upgrade.deps = FALSE, quite = NULL)
#' @param packages Character vector with the packages to be installed (if missing) and loaded. Packages can be given as \href{https://pak.r-lib.org/reference/pak_package_sources.html}{pak package specifications}: a package name for CRAN (e.g. \code{"kableExtra"}), \code{"bioc::package"} for Bioconductor, \code{"user/repo"} for GitHub, \code{"gitlab::user/repo"} for GitLab or \code{"git::url"} for any git repository. Specific versions can be requested (e.g. \code{"user/repo@v1.0"} or \code{"kableExtra@1.4.0"}). Alternatively, the vector names can indicate the repository: 'cran', 'github', 'gitlab', 'bitbucket' or 'bioconductor' (for 'github', 'gitlab' and 'bitbucket' the string must be in the form 'user/package').
#' @param quiet Logical argument to control if installation output and package startup messages are suppressed. Default is \code{FALSE} (messages are printed).
#' @param upgrade.deps Logical argument to control if dependencies of the packages being installed are upgraded to their latest version. Default is \code{FALSE} (dependencies are only upgraded if required). Packages that are already installed are never upgraded.
#' @param quite Deprecated. Use 'quiet' instead.
#' @return Invisibly returns a named logical vector indicating which packages were successfully loaded.
#' @seealso \code{\link[pak]{pkg_install}}, \code{\link{make_compendium}}
#' @export
#' @name load_packages
#' @details The function installs missing packages and loads (attaches) all packages in a single call. Packages that are already installed are just loaded (no internet connection is needed). Installation is done with \code{\link[pak]{pkg_install}} (the 'pak' package is installed from CRAN if needed). The package name to load is taken from the package specification (e.g. "Rraven" for "maRce10/Rraven"), so it won't work for repositories in which the package name differs from the repository name or the package is in a sub-folder.
#' @examples \dontrun{
#' # CRAN, Bioconductor and GitHub packages
#' load_packages(packages = c("kableExtra", "bioc::ggtree", "maRce10/Rraven"))
#'
#' # same packages using vector names to indicate the repository
#' load_packages(packages = c("kableExtra", bioconductor = "ggtree",
#' github = "maRce10/Rraven"), quiet = TRUE)
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references
#' Araya-Salas, M., & Arriaga Madrigal, A. Y. sketchy: Create Custom Research Compendiums. R package (run \code{citation("sketchy")} for the current version).

load_packages <-
  function(packages,
           quiet = FALSE,
           upgrade.deps = FALSE,
           quite = NULL)
  {
    # deprecated argument
    if (!is.null(quite)) {
      .warning("'quite' is deprecated, use 'quiet' instead")
      quiet <- quite
    }

    # get pak specifications and package names
    pkgs <- .pkg_specs(packages)

    # install missing packages
    missing <- !vapply(pkgs$name, requireNamespace, logical(1), quietly = TRUE)
    installed <- !missing

    if (any(missing)) {
      if (!requireNamespace("pak", quietly = TRUE)) {
        .message("installing 'pak' (used to install packages)")
        utils::install.packages("pak", quiet = quiet)
      }

      install <- function(specs) {
        res <- try(if (quiet)
          suppressMessages(pak::pkg_install(specs, upgrade = upgrade.deps, ask = FALSE)) else
            pak::pkg_install(specs, upgrade = upgrade.deps, ask = FALSE),
          silent = quiet)
        !inherits(res, "try-error")
      }

      # install all together and, if that fails, one by one to find out which failed
      if (install(pkgs$spec[missing]))
        installed[missing] <- TRUE else
          installed[missing] <- vapply(pkgs$spec[missing], install, logical(1))
    }

    # load packages
    load_results_l <- vapply(seq_along(pkgs$name), function(x) {
      if (!installed[x])
        return(FALSE)

      if (quiet)
        suppressPackageStartupMessages(require(pkgs$name[x], character.only = TRUE, quietly = TRUE)) else
          require(pkgs$name[x], character.only = TRUE)
    }, FUN.VALUE = logical(1))

    names(load_results_l) <- pkgs$name

    if (any(!load_results_l))
      .message(paste(
        "the following packages were not installed/loaded:",
        paste(pkgs$name[!load_results_l], collapse = ", ")
      ))

    invisible(load_results_l)
  }
