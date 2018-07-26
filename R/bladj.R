#' bladj
#'
#' Bladj take a phylogeny and fixes the root node at a specified age,
#' and fixes other nodes you might have age estimates for. It then sets all
#' other branch lengths by placing the nodes evenly between dated nodes,
#' and between dated nodes and terminals (beginning with the longest
#' 'chains').
#'
#' @export
#' @param ages (data.frame/character) ages data.frame, or path to an ages
#' file. required.
#' @template phylo
#' @return newick string with attributes for where ages and phylo files
#' used are stored
#' @examples \dontrun{
#' ages_file <- system.file("examples/ages", package = "phylocomr")
#' phylo_file <- system.file("examples/phylo_bladj", package = "phylocomr")
#'
#' # from data.frame
#' ages_df <- data.frame(
#'   a = c('malpighiales','eudicots','ericales_to_asterales','plantaginaceae',
#'         'malvids', 'poales'),
#'   b = c(81, 20, 56, 76, 47, 71)
#' )
#' phylo_str <- readLines(phylo_file)
#' (res <- ph_bladj(ages = ages_df, phylo = phylo_str))
#' if (requireNamespace("ape")) {
#'   library(ape)
#'   plot(read.tree(text = res))
#' }
#'
#' # from files
#' ages_file2 <- file.path(tempdir(), "ages")
#' write.table(ages_df, file = ages_file2, row.names = FALSE,
#'   col.names = FALSE, quote = FALSE)
#' phylo_file2 <- tempfile()
#' cat(phylo_str, file = phylo_file2, sep = '\n')
#' (res <- ph_bladj(ages_file2, phylo_file2))
#' if (requireNamespace("ape")) {
#'   library(ape)
#'   plot(read.tree(text = res))
#' }
#'
#' # using a ape phylo phylogeny object
#' x <- read.tree(text = phylo_str)
#' if (requireNamespace("ape")) {
#'   library(ape)
#'   plot(x)
#' }
#' 
#' (res <- ph_bladj(ages_file2, x))
#' if (requireNamespace("ape")) {
#'   library(ape)
#'   tree <- read.tree(text = res)
#'   plot(tree)
#' }
#' }

ph_bladj <- function(ages, phylo) {
  assert(ages, c("data.frame", "character"))
  assert(phylo, c("phylo", "character"))

  if (inherits(ages, "data.frame")) {
    afile <- file.path(tempdir(), "ages")
    unlink(afile, force = TRUE)
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
    ), intern = TRUE)
  )[1]
  attr(out, "ages_file") <- ages
  attr(out, "phylo_file") <- phylo
  return(out)
}
