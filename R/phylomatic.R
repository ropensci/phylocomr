#' phylomatic
#'
#' @export
#' @param taxa (character) all taxa as a character vector (will be written to
#' a temp file if provided) - OR a path to taxa file. Required. See Details.
#' @param phylo (character/phylo) phylogeny as a \code{phylo} object, a newick
#' string (both will be written to a temp file if provided) - OR a path to a
#' file with the newick string. Required.
#' @param tabular (logical) Output a tabular representation of phylogeny.
#' Default: \code{FALSE}
#' @param lowercase (logical) Convert all chars in taxa file to lowercase.
#' Default: \code{FALSE}
#' @param nodes (logical) label all nodes with default names.
#' Default: \code{FALSE}
#'
#' @details The \code{taxa} character vector must have each element of the
#' form \code{family/genus/genus_epithet}. If a file is passed in, each
#' line should have a \code{family/genus/genus_epithet} string - make sure
#' only one per line, and a newline (i.e., press ENTER) at the end of
#' each line
#'
#' @examples
#' library(phytools)
#'
#' taxa_file <- system.file("examples/taxa", package = "phylocomr")
#' phylo_file <- system.file("examples/phylo", package = "phylocomr")
#'
#' # from strings
#' (taxa_str <- readLines(taxa_file))
#' (phylo_str <- readLines(phylo_file))
#' (tree <- ph_phylomatic(taxa = taxa_str, phylo = phylo_str))
#'
#' # from files
#' taxa_file2 <- tempfile()
#' cat(taxa_str, file = taxa_file2, sep = '\n')
#' phylo_file2 <- tempfile()
#' cat(phylo_str, file = phylo_file2, sep = '\n')
#' (tree <- ph_phylomatic(taxa = taxa_file2, phylo = phylo_file2))
#' library(ape)
#' plot(read.newick(text = tree))
ph_phylomatic <- function(taxa, phylo, tabular = FALSE, lowercase = FALSE,
                          nodes = FALSE) {
  taxa <- taxa_check(taxa)
  phylo <- phylo_check(phylo)
  out <- suppressWarnings(
    phylomatic(c(
      "-t", taxa,
      "-f", phylo,
      if (tabular) "-y",
      if (lowercase) "-l",
      if (nodes) "-n"
    ), stdout = FALSE)
  )[1]
  attr(out, "taxa_file") <- taxa
  attr(out, "phylo_file") <- phylo
  out
}
