#' comstruct
#'
#' Calculates mean phylogenetic distance (MPD) and mean nearest
#' phylogenetic taxon distance (MNTD; aka MNND) for each sample, and
#' compares them to MPD/MNTD values for randomly generated samples
#' (null communities) or phylogenies.
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file
#' @template phylo
#' @param swaps (numeric) number of swaps. Default: 1000
#' @template com_args
#' @template com_null_models
#' @return data.frame
#' @details See [phylocomr-inputs] for expected input formats
#' @section Taxon name case:
#' In the `sample` table, if you're passing in a file, the names in the
#' third column must be all lowercase; if not, we'll lowercase them for you.
#' If you pass in a data.frame, we'll lowercase them for your. All phylo
#' tip/node labels are also lowercased to avoid any casing problems
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
#' # ph_comstruct(sample = sfile2, phylo = pfile2, null_model = 3)

ph_comstruct <- function(sample, phylo, null_model = 0, randomizations = 999,
                         swaps = 1000, abundance = TRUE) {

  assert(sample, c("character", "data.frame"))
  assert(phylo, c("character", "phylo"))
  assert(null_model, c("numeric", "integer"))
  assert(randomizations, c("numeric", "integer"))
  assert(swaps, c("numeric", "integer"))
  assert(abundance, "logical")
  stopifnot(null_model %in% 0:3)

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
    ), intern = TRUE)
  )
  phylocom_error(out)
  astbl(utils::read.table(
    text = out, skip = 1, header = TRUE,
    stringsAsFactors = FALSE
  ))
}
