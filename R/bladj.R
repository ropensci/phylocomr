#' bladj
#'
#' @export
#' @param ages (data.frame/character) ages data.frame, or path to an ages
#' file. required.
#' @param phylo (character) phylogeny as a newick string, will be written to
#' a temp file if provided - OR path to file with a newick string. required.
#' @return newick string
#' @examples
#' library(phytools)
#'
#' ages_file <- system.file("examples/ages", package = "phylocomr")
#' phylo_file <- system.file("examples/phylo_bladj", package = "phylocomr")
#'
#' # from data.frame
#' ages_df <- data.frame(
#'   a = c('malpighiales','salicaceae','fabaceae','rosales','oleaceae',
#'         'gentianales','apocynaceae','rubiaceae'),
#'   b = c(81,20,56,76,47,71,18,56)
#' )
#' phylo_str <- readLines(phylo_file)
#' (res <- ph_bladj(ages = ages_df, phylo = phylo_str))
#' plot(phytools::read.newick(text = res))
#'
#' # from files
#' ages_file2 <- file.path(tempdir(), "ages")
#' write.table(ages_df, file = ages_file2, row.names = FALSE,
#'   col.names = FALSE, quote = FALSE)
#' phylo_file2 <- tempfile()
#' cat(phylo_str, file = phylo_file2, sep = '\n')
#' (res <- ph_bladj(ages_file2, phylo_file2))
#' plot(phytools::read.newick(text = res))

ph_bladj <- function(ages, phylo) {
  stopifnot(class(ages) %in% c('data.frame', 'character'))
  if (inherits(ages, "data.frame")) {
    afile <- file.path(tempdir(), "ages")
    utils::write.table(ages, file = afile, quote = FALSE, row.names = FALSE)
    ages <- afile
  }
  phylo <- phylo_check(phylo)

  cdir <- getwd()
  bdir <- dirname(ages)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(c(
      "bladj",
      "-f", basename(phylo)
    ), stdout = TRUE)
  )[1]
  attr(out, "ages_file") <- ages
  attr(out, "phylo_file") <- phylo
  return(out)
}
