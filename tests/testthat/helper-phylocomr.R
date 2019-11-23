make_sample <- function(x) {
  if (NCOL(x) != 3) stop("'sample' files should contain 3 columns, see docs",
    call.=FALSE)
  if (!inherits(x[,3], c("character", "factor"))) {
    stop("the 3rd column of 'sample' should be character or factor",
      call.=FALSE)
  }
  x_tmp <- tempfile("sample_")
  unlink(x_tmp, force = TRUE)
  utils::write.table(x, file = x_tmp, quote = FALSE, row.names = FALSE,
    col.names = FALSE, sep = "\t")
  return(x_tmp)
}
sample_check_nolower <- function(x) {
  stopifnot(inherits(x, c('data.frame', 'character')))
  if (inherits(x, "data.frame")) {
    make_sample(x)
  } else {
    stopifnot(file.exists(x))
    tab <- utils::read.table(x, stringsAsFactors = FALSE,
      header = has_header(x))
    make_sample(tab)
  }
}
