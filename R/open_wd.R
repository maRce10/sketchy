#' Open working directory
#' 
#' \code{open_wd} opens the working directory in the default file browser.
#' @param path Directory path to be opened. By default it's the working directory. 
#' @param verbose Logical to control whether the 'path' is printed in the console. Default is \code{TRUE}.
#' @family data manipulation
#' @seealso \code{\link{spot_unused_files}} 
#' @export
#' @name open_wd
#' @details The function opens the working directory using the default file browser 
#' and prints the working directory in the R console. This function aims to simplify
#' the manipulation of files and folders in a project.
#' @return Opens the working directory using the default file browser. 
#' @examples
#' {
#' \donttest{open_wd()}
#' }
#' 
#' @references {
#' Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for data analysis in R. R package version 1.0.3.
#' }
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})


open_wd <- function(path = ".", verbose = TRUE){
  
  #check path to working directory
  if (!dir.exists(path)) .stop("'path' provided does not exist") else
    path <- normalizePath(path)
  
    if (.Platform['OS.type'] == "windows"){
    shell.exec(path)
  } else {
    system(paste(Sys.getenv("R_BROWSER"), path), ignore.stdout = TRUE, ignore.stderr = TRUE)
  }

  if (verbose)
  print(paste(path, "opened in file browser"))
}
