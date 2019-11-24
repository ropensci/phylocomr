astbl <- function(x = NULL) {
  if (NCOL(x) > 0 && !is.null(x)) {
    names(x) <- tolower(names(x))
  }
  tibble::as_tibble(x)
}

# for: comtrait
lowerize_traits <- function(x) {
  tab <- utils::read.table(x, stringsAsFactors = FALSE, header = TRUE)
  tab[,3] <- tolower(tab[,3])
  x_tmp <- tempfile("traits_")
  utils::write.table(tab, file = x_tmp, row.names = FALSE)
}
trait_check <- function(x, binary) {
  stopifnot(inherits(x, c('data.frame', 'character')))
  sfile <- tempfile("trait_")
  if (inherits(x, "data.frame")) {
    if (colnames(x)[1] != "name") {
      stop("first column name in `traits` must be `name`", call. = FALSE)
    }
    stopifnot(!is.null(binary))
    stopifnot(is.logical(binary))
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
  } else {
    stopifnot(file.exists(x))
    x <- tolower(readLines(x))
    cat(x, file = sfile, sep = "\n")
  }
  return(sfile)
}

taxa_check <- function(x, name = "taxa") {
  stopifnot(inherits(x, c('data.frame', 'character')))
  if (!file.exists(x[1])) {
    sfile <- tempfile(paste0(name, "_"))
    cat(x, file = sfile, sep = "\n")
    return(sfile)
  } else {
    stopifnot(file.exists(x))
    return(x)
  }
}

lowerize <- function(x) {
  txt <- readLines(x)
  if (grepl("[[:upper:]]", txt)) tolower(txt) else txt
}

ages_check <- function(x) {
  afile <- file.path(tempdir(), "ages")
  if (inherits(x, "data.frame")) {
    unlink(afile, force = TRUE)
    if (inherits(x[,1], c("character", "factor")))
      x[,1] <- tolower(x[,1])
    write_table(x, afile)
  } else {
    tab <- utils::read.table(x, stringsAsFactors = FALSE, header = FALSE)
    tab[,1] <- tolower(tab[,1])
    write_table(tab, afile)
  }
  return(afile)
}

write_table <- function(x, file) {
  utils::write.table(x, file = file, quote = FALSE,
    row.names = FALSE, col.names = FALSE)
}

phylo_check <- function(x) {
  stopifnot(inherits(x, c('phylo', 'character')))
  pfile <- tempfile("phylo_")
  if (inherits(x, "phylo")) {
    # lowercase tip and nodel labels
    x$tip.label <- tolower(x$tip.label)
    x$node.label <- tolower(x$node.label)
    x <- write_tree_(x)
  } else {
    if (grepl("\\(\\(", x)) {
      # lowercase tip and nodel labels
      x <- tolower(x)
    } else {
      stopifnot(file.exists(x))
      x <- lowerize(x)
    }
  }
  cat(x, file = pfile, sep = "\n")
  return(pfile)
}

# for: comstruct, comdist, comtrait, rao, and pd
lowerize_sample <- function(x) {
  if (NCOL(x) != 3) stop("'sample' files should contain 3 columns, see docs",
    call.=FALSE)
  if (!inherits(x[,3], c("character", "factor"))) {
    stop("the 3rd column of 'sample' should be character or factor",
      call.=FALSE)
  }
  x[,3] <- tolower(x[,3])
  x_tmp <- tempfile("sample_")
  unlink(x_tmp, force = TRUE)
  utils::write.table(x, file = x_tmp, quote = FALSE, row.names = FALSE,
    col.names = FALSE, sep = "\t")
  return(x_tmp)
}
sample_check <- function(x) {
  stopifnot(inherits(x, c('data.frame', 'character')))
  if (inherits(x, "data.frame")) {
    lowerize_sample(x)
  } else {
    stopifnot(file.exists(x))
    tab <- utils::read.table(x, stringsAsFactors = FALSE,
      header = has_header(x))
    lowerize_sample(tab)
  }
}

has_header <- function(z) {
  no <- utils::read.table(z, stringsAsFactors = FALSE, header = TRUE, nrows = 1)
  yes <- utils::read.table(z, stringsAsFactors = FALSE, header = FALSE, nrows = 1)
  identical(names(yes), as.character(unname(yes[1,])))
}

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

lower_cols <- function(x) {
  if (!is.data.frame(x)) return(x)
  for (i in seq_along(x)) {
    if (inherits(x[,i], c("character", "factor")))
      x[,i] <- tolower(x[,i])
  }
  return(x)
}

phylocom_error <- function(x) {
  # "Exiting" is always an error AFAIK
  if (grepl("Exiting", x)) stop(x, call. = FALSE)
  # if an empty string, it clearly didn't work, but no reason given
  if (!nzchar(x)) stop("phylocom failed; no reason given; check inputs",
    call. = FALSE)
}
