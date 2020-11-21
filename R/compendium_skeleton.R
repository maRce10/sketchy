compendium_skeleton <- function(name = "research_compendium", list = character(),
            path = ".", force = FALSE, encoding = "unknown", format = format)
  {
    if (!grepl(sprintf("^%s$", .standard_regexps()$valid_package_name),
               name))
      stop("Malformed package name.")
    safe.dir.create <- function(path) {
      if (!dir.exists(path) && !dir.create(path))
        stop(gettextf("cannot create directory '%s'", path),
             domain = NA)
    }

    message("Creating directories ...", domain = NA)
    dir <- file.path(path, name)
    if (file.exists(dir) && !force)
      stop(gettextf("directory '%s' already exists", dir),
           domain = NA)
    safe.dir.create(dir)

    for(i in format)
    safe.dir.create(code_dir <- file.path(dir, i))


    message("Done.", domain = NA)

    df <- data.frame(org = format, last.dir = paste0(basename(format), "/"), dir.name = dirname(format), subfolers = lengths(regmatches(format, gregexpr("/", format))))

    backbone <- c("|     ", rep("      ", 100))

    df$edges <- sapply(1:nrow(df), function(x) paste(paste(if (df$subfolers[x] > 0) backbone[1:df$subfolers[x]] else "", collapse = ""), "├── ", df$last.dir[x], sep = ""))

    if (nrow(df) > 1)
      for(i in 2:nrow(df))
        if (df$dir.name[i - 1] != df$dir.name[i]) df$edges[i - 1] <- gsub("├──", "└──", df$edges[i - 1])

    # replace last T
    df$edges[nrow(df)] <- gsub("├──", "└──", df$edges[nrow(df)])

    # replace last T in backbone
    df$edges[max(which(df$dir.name == "."))] <- gsub("├──", "└──", df$edges[max(which(df$dir.name == "."))])


    # remove backbone in secondary subfolders
    df$edges[1:nrow(df) > max(which(df$dir.name == "."))] <- gsub("\\|", " ", df$edges[1:nrow(df) > max(which(df$dir.name == "."))])

    co <- paste(df$edges, collapse = "\n")

    cat(co)

    }


