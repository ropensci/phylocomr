astbl <- function(x) tibble::as_data_frame(x)

sample_check <- function(x, name = "sample") {
  stopifnot(class(x) %in% c('data.frame', 'character'))
  if (inherits(x, "data.frame")) {
    sfile <- tempfile(paste0(name, "_"))
    utils::write.table(
      x, file = sfile,
      quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
    return(sfile)
  } else {
    stopifnot(file.exists(x))
    return(x)
  }
}

taxa_check <- function(x, name = "taxa") {
  stopifnot(class(x) %in% c('data.frame', 'character'))
  if (!file.exists(x[1])) {
    sfile <- tempfile(paste0(name, "_"))
    cat(x, file = sfile, sep = "\n")
    return(sfile)
  } else {
    stopifnot(file.exists(x))
    return(x)
  }
}

phylo_check <- function(x) {
  stopifnot(class(x) %in% c('phylo', 'character'))
  if (inherits(x, "phylo")) {
    tree <- ape::write.tree(x)
    pfile <- tempfile("phylo_")
    cat(tree, file = pfile, sep = "\n")
    return(pfile)
  } else {
    if (grepl("\\(\\(", x)) {
      pfile <- tempfile("phylo_")
      cat(x, file = pfile, sep = "\n")
      return(pfile)
    } else {
      stopifnot(file.exists(x))
      return(x)
    }
  }
}
