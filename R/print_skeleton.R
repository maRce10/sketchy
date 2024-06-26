#' Print folder structures
#'
#' \code{print_skeleton} prints the folder structure of a research compendium.
#' @usage print_skeleton(path = ".", comments = NULL, folders = NULL)
#' @param path path to the directory to be printed. Default is current directory.
#' @param comments A character string with the comments to be added to each folder in the graphical representation of the folder skeleton printed on the console.
#' @param folders A character vector including the name of the sub-directories of the project.
#' @return The folder skeleton is printed in the console.
#' @seealso \code{\link{compendiums}}, \code{\link{make_compendium}}
#' @export
#' @name print_skeleton
#' @details The function prints the folder structure of an existing project.
#' @examples {
#' data(compendiums)
#'
#'make_compendium(name = "my_other_compendium", path = tempdir(), format = "basic")
#'
#'print_skeleton(path = file.path(tempdir(), "mycompendium"))
#' }
#'
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr})
#' @references {
#' Araya-Salas, M., Arriaga, A. (2023), sketchy: research compendiums for data analysis in R. R package version 1.0.3.
#' }
#last modification on dec-26-2019 (MAS)

print_skeleton <- function(path = ".", comments = NULL, folders = NULL)
  {

  # get structure
  if (is.null(folders))
  format <- list.dirs(path = path, full.names = FALSE, recursive = TRUE) else
    format <- folders

  # remove git R and devtools folders
  format <- grep("^\\.git|^\\.Rproj.user|^\\.\\.Rcheck", format, value = TRUE, invert = TRUE)

  # remove empty elements
  # comments <- comments[!format %in%  c("", " ")]
  format <- format[!format %in%  c("", " ")]

  # get name of project to be printed
  name <- basename(path)

    # fix comments vector
    if (!is.null(comments)){
      if(length(comments) != length(format))
        .stop(paste0(length(format), " folders found but only ", length(comments), " elements in comments"))

      if (!all(names(comments) %in% format))
        .stop("not all names in 'comments' have a folder counterpart") else
          comments <- comments[match(format, names(comments))]

    } else comments <- rep("", length(format))


    df <- data.frame(original_path = format, last.dir = paste0(basename(format), "/"), dir.name = dirname(format), subfolders = lengths(regmatches(format, gregexpr("/", format))), comments = comments)

    # order by original path
    df <- df[order(df$original_path),  ]

    # get names of folders and subfolders in a data frame
    folders_l <- lapply(df$original_path, function(x) strsplit(x, "\\/")[[1]])

    folders <- as.data.frame(t(data.frame(lapply(folders_l, function(x) c(x, rep("", max(sapply(folders_l, length)) - length(x)))))))
    rownames(folders) <- 1:nrow(folders)

    folders$level <- apply(folders, 1, function(x) length(x[x != ""]))

    edges <- as.data.frame(matrix(rep(NA, nrow(folders) * (ncol(folders) - 1)), ncol = ncol(folders) - 1))

    Tpipe <- crayon::cyan(stringi::stri_unescape_unicode("\\u251c\\u2500\\u2500"))
    Ipipe <- crayon::cyan(stringi::stri_unescape_unicode("\\u2502   "))
    Lpipe <- crayon::cyan(stringi::stri_unescape_unicode("\\u2514\\u2500\\u2500"))
    empty <- '    '

    # add Ts to bifurcations
    for(i in 1:(ncol(folders) - 1))
      edges[, i] <-  ifelse(folders$level == i, Tpipe, Ipipe)

    for (i in 1:nrow(folders)){

      # Remove Ts
      wich_t <- which(edges[i, ] == Tpipe)
      if (length(wich_t) > 0)
      if (wich_t < ncol(edges))
        edges[i, (wich_t + 1):ncol(edges)] <- ""

    # change Ts for Ls
      if (folders$level[i] > 1){
        if (max(which(folders$level == folders$level[i] & folders[, folders$level[i] - 1] == folders[i, folders$level[i] - 1])) == i)
        edges[i, folders$level[i]] <- gsub(Tpipe, Lpipe, fixed = TRUE, edges[i, folders$level[i]])
    }
    }

    # remove | below and L
    for(i in 1:nrow(folders)){
      if(any(edges[i, ] == Lpipe)){
        previous_Ls <- which(edges[,which(edges[i, ] == Lpipe) - 1] ==  Lpipe)

        if (any(previous_Ls < i)){
            previous_L <- max(previous_Ls[previous_Ls < i])
        edges[previous_L:i, which(edges[i, ] == Lpipe) - 1] <- gsub(Ipipe, empty, edges[previous_L:i, which(edges[i, ] == Lpipe) - 1], fixed = TRUE)
        }
      }
    }

  # Fix empty spaces above an L
  for(e in 1:ncol(edges)){

    for (u in 1:nrow(edges)){

      if (edges[u, e] == Lpipe){
        wich_Ts <- which(edges[,e] == Tpipe)
        wich_Ts <- wich_Ts[wich_Ts < u]

        if (length(wich_Ts) > 0){
          wich_Ts <- max(wich_Ts)
        edges[(wich_Ts + 1):(u - 1), e] <-  gsub(empty, Ipipe,  edges[(wich_Ts + 1):(u - 1), e], fixed = TRUE)
        }
      }
    }
  }

    # Fix empty spaces below a T
    if (ncol(edges) > 1){
    for(e in 2:ncol(edges)){

      for (u in 1:nrow(edges)){

        if (edges[u, e] == Tpipe)
          edges[u:max(which(df$dir.name == df$dir.name[u])),e] <-  gsub(empty, Ipipe, edges[u:max(which(df$dir.name == df$dir.name[u])),e], fixed = TRUE)

        if (edges[u, e] == Tpipe)
          edges[u:max(which(df$dir.name == df$dir.name[u])),e] <-  gsub(empty, Ipipe, edges[u:max(which(df$dir.name == df$dir.name[u])),e], fixed = TRUE)

        if (u > 1)
          if (edges[u, e] == Ipipe &  edges[u - 1, e] %in% c(empty, Lpipe, ""))
          edges[u, e] <- empty


      if (u < nrow(edges)){
        if (edges[u, e] == Lpipe &  edges[u + 1, e] %in% c(Tpipe, Lpipe))
          edges[u, e] <- Tpipe

        if (edges[u, e] == Ipipe &  edges[u + 1, e] %in% c(empty, ""))
          edges[u, e] <- empty

        if (edges[u, e] == Tpipe &  edges[u + 1, e] %in% c("", empty))
          edges[u, e] <- Lpipe
        }
      }
    }

    # Fix empty spaces below a T
    for(e in 2:ncol(edges)){

      for (u in nrow(edges):1){

        if (edges[u, e] == Tpipe)
          edges[u:max(which(df$dir.name == df$dir.name[u])),e] <-  gsub(empty, Ipipe, edges[u:max(which(df$dir.name == df$dir.name[u])),e], fixed = TRUE)

        if (edges[u, e] == Tpipe)
          edges[u:max(which(df$dir.name == df$dir.name[u])),e] <-  gsub(empty, Ipipe, edges[u:max(which(df$dir.name == df$dir.name[u])),e], fixed = TRUE)

        if (u > 1)
          if (edges[u, e] == Ipipe &  edges[u - 1, e] %in% c(empty, Lpipe, ""))
            edges[u, e] <- empty


          if (u < nrow(edges)){
            if (edges[u, e] == Lpipe &  edges[u + 1, e] %in% c(Tpipe, Lpipe))
              edges[u, e] <- Tpipe

            if (edges[u, e] == Ipipe &  edges[u + 1, e] %in% c(empty, ""))
              edges[u, e] <- empty

            if (edges[u, e] == Tpipe &  edges[u + 1, e] %in% c("", empty))
              edges[u, e] <- Lpipe
          }
      }
    }
}
    # replace last T in backbone
    last_T_col1 <- max(which(edges[, 1] == Tpipe))
    edges[last_T_col1, 1] <- Lpipe

    # remove | after L in first column
    if (last_T_col1 < nrow(edges))
      edges[(last_T_col1 + 1):nrow(edges), 1] <- empty


      # add comments to dir name
      df$last.dir <- sapply(1:nrow(df), function(x) paste(df$last.dir[x], crayon::silver(paste(if(df$comments[x] == "") ""  else " #", df$comments[x]))))


    # put all in a single vector
    edge <- paste(apply(edges, 1, paste, collapse = ""), df$last.dir)

    # add page breaks
    folder_structure <- paste0(crayon::bold(name), "\n", crayon::bold(Ipipe),"\n", paste(edge, collapse = "\n"), "\n")

    # print
    on.exit(cat(folder_structure))
}
