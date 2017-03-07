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

  sample <- sample_check(sample)
  phylo <- phylo_check(phylo)

  cdir <- getwd()
  bdir <- dirname(sample)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(c(
      method,
      "-s", basename(sample),
      "-f", basename(phylo),
      "-m", null_model,
      "-r", randomizations,
      if (abundance) "-a"
    ), stdout = TRUE)
  )

  tmp <- astbl(utils::read.table(text = out, header = TRUE,
                                 stringsAsFactors = FALSE))
  stats::setNames(tmp, c('name', names(tmp)[-1]))
}
