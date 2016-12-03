#' bladj
#'
#' @export
#' @param ages (data.frame) ages data.frame
#' @param ages_file (character) path to traits file
#' @param phylo (character) phylogeny as a newick string, will be written to
#' a temp file if provided
#' @param phylo_file (character) path to phylo file
#' @return newick string
#' @examples
#' library(phytools)
#'
#' ages_file <- system.file("examples/ages", package = "phylocom")
#' phylo_file <- system.file("examples/phylo_bladj", package = "phylocom")
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
#' (res <- ph_bladj(ages_file = ages_file2, phylo_file = phylo_file2))
#' plot(phytools::read.newick(text = res))

ph_bladj <- function(ages = NULL, ages_file = NULL, phylo = NULL,
                     phylo_file = NULL) {

  stopifnot(xor(!is.null(ages), !is.null(ages_file)))
  stopifnot(xor(!is.null(phylo), !is.null(phylo_file)))
  if (!is.null(ages)) {
    ages_file <- file.path(tempdir(), "ages")
    utils::write.table(ages, file = ages_file, quote = FALSE, row.names = FALSE)
  }
  if (!is.null(phylo)) {
    phylo_file <- file.path(tempdir(), "phylo")
    cat(phylo, file = phylo_file, sep = "\n")
  }

  cdir <- getwd()
  bdir <- dirname(ages_file)
  stopifnot(bdir == dirname(phylo_file))
  setwd(bdir)
  on.exit(setwd(cdir))

  suppressWarnings(
    phylocom(paste0(c(
      "bladj",
      paste0("-f ", basename(phylo_file))
    ), collapse = " "), stdout = TRUE)
  )[1]
}
