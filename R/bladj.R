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
#' file. required. column names do not matter, and are discarded anyway.
#' the first column must be the node names, and the second column the node
#' ages
#' @template phylo
#' @return newick string with attributes for where ages and phylo files
#' used are stored
#' @section Common Errors:
#' A few issues to be aware of:
#' 
#' - the ages table must have a row for the root node with an age estimate.
#' bladj will not work without that. We attempt to check this but can only
#' check it if you pass in a phylo object; there's no easy way to parse a
#' newick string without requiring ape
#' - bladj is case sensitive. internally we lowercase all tip and node labels
#' and taxon names in your ages file to avoid any case sensitivity problems
#' 
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
    if (inherits(ages[,1], c("character", "factor")))
      ages[,1] <- tolower(ages[,1])
    utils::write.table(ages, file = afile, quote = FALSE, row.names = FALSE,
      col.names = FALSE)
    ages <- afile
  }
  check_root_node(phylo, ages)
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

check_root_node <- function(x, y) {
  if (!inherits(x, "phylo")) return()
  x$node.label <- tolower(x$node.label)
  ages_nodes <- utils::read.table(y, stringsAsFactors = FALSE)[,1]
  phylo_root <- x$node.label[1]
  if (nzchar(phylo_root)) {
    if (!phylo_root %in% ages_nodes) {
      warning(
        sprintf("bladj may fail; the root node '%s' is not in the ages nodes",
          phylo_root), immediate. = TRUE)
    }
  }
}
