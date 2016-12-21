#' comdist
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file
#' @param phylo (character/phylo) phylogeny as a phylo object or a newick
#' string (will be written to a temp file if provided) - or a path to a
#' file with a newick string
#' @template com_args
#' @template com_null_models
#' @return data.frame
#' @examples
#' sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
#' pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")
#'
#' # from data.frame
#' sampledf <- read.table(sfile, header = FALSE,
#'   stringsAsFactors = FALSE)
#' phylo_str <- readLines(pfile)
#' ph_comdist(sample = sampledf, phylo = phylo_str)
#' ph_comdistnt(sample = sampledf, phylo = phylo_str)
#'
#' # from files
#' sample_str <- paste0(readLines(sfile), collapse = "\n")
#' sfile2 <- tempfile()
#' cat(sample_str, file = sfile2, sep = '\n')
#' pfile2 <- tempfile()
#' cat(phylo_str, file = pfile2, sep = '\n')
#' ph_comdist(sample = sfile2, phylo = pfile2)
#' ph_comdistnt(sample = sfile2, phylo = pfile2)
ph_comdist <- function(sample, phylo, null_model = 0, randomizations = 999,
                       abundance = TRUE) {
  com_dist(sample, phylo, null_model = 0, randomizations = 999,
           abundance = TRUE, "comdist")
}

#' @export
#' @rdname ph_comdist
ph_comdistnt <- function(sample, phylo, null_model = 0, randomizations = 999,
                         abundance = TRUE) {
  com_dist(sample, phylo, null_model = 0, randomizations = 999,
           abundance = TRUE, "comdistnt")
}

com_dist <- function(sample, phylo, null_model = 0, randomizations = 999,
                       abundance = TRUE, method) {

  stopifnot(class(sample) %in% c('data.frame', 'character'))
  if (inherits(sample, "data.frame")) {
    sfile <- tempfile("sample_")
    utils::write.table(
      sample, file = sfile,
      quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
    sample <- sfile
  } else {
    stopifnot(file.exists(sample))
  }

  stopifnot(class(phylo) %in% c('phylo', 'character'))
  if (inherits(phylo, "phylo")) {
    tree <- ape::write.tree(phylo)
    pfile <- tempfile("phylo_")
    cat(tree, file = phylo, sep = "\n")
    phylo <- pfile
  } else {
    if (grepl("\\(\\(", phylo)) {
      pfile <- tempfile("phylo_")
      cat(phylo, file = pfile, sep = "\n")
      phylo <- pfile
    } else {
      stopifnot(file.exists(phylo))
    }
  }

  cdir <- getwd()
  bdir <- dirname(sample)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(paste0(c(
      method,
      paste0("-s ", basename(sample)),
      paste0("-f ", basename(phylo)),
      paste0("-m ", null_model),
      paste0("-r ", randomizations),
      if (abundance) "-a "
    ), collapse = " "), stdout = TRUE)
  )

  utils::read.table(text = out, header = TRUE, stringsAsFactors = FALSE)
}
