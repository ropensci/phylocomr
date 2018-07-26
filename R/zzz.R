astbl <- function(x = NULL) {
  if (NCOL(x) > 0 && !is.null(x)) {
    names(x) <- tolower(names(x))
  }
  tibble::as_data_frame(x)
}

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

trait_check <- function(x, binary) {
  stopifnot(class(x) %in% c('data.frame', 'character'))
  if (inherits(x, "data.frame")) {
    stopifnot(!is.null(binary))
    stopifnot(is.logical(binary))
    sfile <- tempfile("trait_")
    top <- matrix("3", ncol = NCOL(x) - 1)
    top[binary] <- 0
    utils::write.table(data.frame("type", top), file = sfile,
      quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t",
      append = TRUE)
    utils::write.table(matrix(names(x), nrow = 1),
      file = sfile,
      quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t",
      append = TRUE)
    utils::write.table(
      x, file = sfile,
      quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t",
      append = TRUE)
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
    tree <- write_tree_(x)
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

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!class(x) %in% y) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}
