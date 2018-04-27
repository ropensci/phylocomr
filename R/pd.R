#' pd - Faith's index of phylogenetic diversity
#'
#' Calculates Faith’s (1992) index of phylogenetic diversity (PD) for
#' each sample in the phylo.
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file. required
#' @template phylo
#' @return A single data.frame, with the colums:
#' 
#' - sample - community name/label
#' - ntaxa - number of taxa
#' - pd - Faith's phylogenetic diversity
#' - treebl - tree BL
#' - proptreebl - proportion tree BL
#' 
#' @family phylogenetic-diversity
#' @examples
#' sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
#' pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")
#'
#' # from data.frame
#' sampledf <- read.table(sfile, header = FALSE,
#'   stringsAsFactors = FALSE)
#' phylo_str <- readLines(pfile)
#' ph_pd(sample = sampledf, phylo = phylo_str)
#'
#' # from files
#' sample_str <- paste0(readLines(sfile), collapse = "\n")
#' sfile2 <- tempfile()
#' cat(sample_str, file = sfile2, sep = '\n')
#' pfile2 <- tempfile()
#' phylo_str <- readLines(pfile)
#' cat(phylo_str, file = pfile2, sep = '\n')
#'
#' ph_pd(sample = sfile2, phylo = pfile2)
ph_pd <- function(sample, phylo) {
  assert(sample, c("data.frame", "character"))
  assert(phylo, c("phylo", "character"))

  sample <- sample_check(sample)
  phylo <- phylo_check(phylo)

  cdir <- getwd()
  bdir <- dirname(sample)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(c(
      "pd",
      "-s", basename(sample),
      "-f", basename(phylo)
    ), intern = TRUE)
  )

  astbl(utils::read.table(text = out, header = TRUE, stringsAsFactors = FALSE))
}
