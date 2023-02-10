#' Install and load packages
#'
#' \code{load_packages} installs and loads packages from different repositories.
#' @usage load_packages(packages, quite = FALSE, upgrade.deps = FALSE)
#' @param packages Character vector with the names of the packages to be installed. The vector names indicate the repositories from which packages will be installed. If no name is included CRAN will be used as the default repository. Available repostories are: 'cran', 'github', 'gitlab', 'bitbucket' and 'bioconductor'. Note that for 'github', 'gitlab' and 'bitbucket' the string must include the user name in the form 'user/package'.
#' @param quite Logical argument to control if package startup messages are printed. Default is \code{FALSE} (messages are printed).
#' @param upgrade.deps Logical argument to control if package dependecies are upgraded.Default is \code{FALSE}.
#' @return No object is returned.
#' @seealso \code{\link{compendiums}}, \code{\link{make_compendium}}
#' @export
#' @name load_packages
#' @details The function installs and loads packages from different repositories.
#' @examples \dontrun{
#'load_packages(packages = c("kableExtra", bioconductor = "ggtree",
#'github = "maRce10/Rraven"), quite = TRUE)
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references {
#' Araya-Salas, M., Willink, B., Arriaga, A. (2020), sketchy: research compendiums for data analysis in R. R package version 1.0.2.
#' }

load_packages <-
  function(packages,
           quite = FALSE,
           upgrade.deps = FALSE)
  {
    # fix names
    if (is.null(names(packages)))
      names(packages) <- rep("", length(packages))

    # install/ load packages
    load_results_l <- vapply(seq_along(packages), function(x) {
      # get package
      user_pkg <- packages[x]

      if (grepl("/", user_pkg)) {
        user_pkg_vector <- strsplit(user_pkg, "/")[[1]]
        user <- user_pkg_vector[1]
        pkg <- user_pkg_vector[2]
      } else {
        user <- ""
        pkg <- user_pkg
      }

      # check if installed, if not then install
      if (!pkg %in% installed.packages()[, "Package"])  {
        # get repository
        repo <- tolower(names(packages)[x])

        if (repo == "" | repo == "cran")
          remotes::install_cran(pkgs = pkg,
                                force = TRUE,
                                quiet = quite,
                                upgrade = upgrade.deps)

        if (repo == "bioconductor")
          remotes::install_bioc(repo = pkg,
                                force = TRUE,
                                quite = quite,
                                upgrade = upgrade.deps)

        if (repo == "github")
          remotes::install_github(
            repo = paste(user, pkg, sep = "/"),
            force = TRUE,
            quite = quite,
            upgrade = upgrade.deps
          )

        if (repo == "bitbucket")
          remotes::install_bitbucket(
            paste(user, pkg, sep = "/"),
            force = TRUE,
            quite = quite,
            upgrade = upgrade.deps
          )

        if (repo == "gitlab")
          remotes::install_gitlab(
            paste(user, pkg, sep = "/"),
            force = TRUE,
            quite = quite,
            upgrade = upgrade.deps
          )
      }

      # load package
      result <- require(pkg, character.only = TRUE, quietly = quite)

      if (!result)
        try_remove <- try(remove.packages(pkg), silent = TRUE)

      return(result)

    }, FUN.VALUE = logical(1))

    if (any(!load_results_l))
      message2(paste(
        c("the following packages were not installed/loaded:"),
        paste(packages, collapse = ", ")
      ))
  }
