#' comstruct
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file
#' @param phylo (character/phylo) phylogeny as a phylo object or a newick
#' string (will be written to a temp file if provided) - or a path to a
#' file with a newick string
#' @param swaps (numeric) number of swaps. Default: 1000
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
#' (res <- ph_comstruct(sample = sampledf, phylo = phylo_str))
#'
#' # from files
#' sample_str <- paste0(readLines(sfile), collapse = "\n")
#' sfile2 <- tempfile()
#' cat(sample_str, file = sfile2, sep = '\n')
#' pfile2 <- tempfile()
#' cat(phylo_str, file = pfile2, sep = '\n')
#' (res <- ph_comstruct(sample = sfile2, phylo = pfile2))
#'
#' # different null models
#' ph_comstruct(sample = sfile2, phylo = pfile2, null_model = 0)
#' ph_comstruct(sample = sfile2, phylo = pfile2, null_model = 1)
#' ph_comstruct(sample = sfile2, phylo = pfile2, null_model = 2)
#' ph_comstruct(sample = sfile2, phylo = pfile2, null_model = 3)

ph_comstruct <- function(sample, phylo, null_model = 0, randomizations = 999,
                         swaps = 1000, abundance = TRUE) {

  sample <- sample_check(sample)
  phylo <- phylo_check(phylo)

  cdir <- getwd()
  bdir <- dirname(sample)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(c(
      "comstruct",
      "-s", basename(sample),
      "-f", basename(phylo),
      "-m", null_model,
      "-w", swaps,
      "-r", randomizations,
      if (abundance) "-a"
    ), stdout = TRUE)
  )

  astbl(utils::read.table(
    text = out, skip = 1, header = TRUE,
    stringsAsFactors = FALSE
  ))
}
