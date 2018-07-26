#' phylomatic
#'
#' Phylomatic is a tool for extracting a phylogeny from a master
#' phylogeny using only a user-supplied list of taxa.
#'
#' @export
#' @param taxa (character) all taxa as a character vector (will be written to
#' a temp file if provided) - OR a path to taxa file. Required. See Details.
#' @template phylo
#' @param tabular (logical) Output a tabular representation of phylogeny.
#' Default: `FALSE`
#' @param lowercase (logical) Convert all chars in taxa file to lowercase.
#' Default: `FALSE`
#' @param nodes (logical) label all nodes with default names.
#' Default: `FALSE`
#'
#' @references Phylomatic is also available as a web service
#' (https://github.com/camwebb/phylomatic-ws) - but is based on a different
#' code base (https://github.com/camwebb/phylomatic-ws)
#' See [
#' Webb and Donoghue (2005)](https://doi.org/10.1111/j.1471-8286.2004.00829.x)
#' for more information on the goals of Phylomatic.
#'
#' @details The `taxa` character vector must have each element of the
#' form `family/genus/genus_epithet`. If a file is passed in, each
#' line should have a `family/genus/genus_epithet` string - make sure
#' only one per line, and a newline (i.e., press ENTER) at the end of
#' each line
#'
#' @examples
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
#' 
#' if (requireNamespace("ape")) {
#'   library(ape)
#'   plot(read.tree(text = tree))
#' }
ph_phylomatic <- function(taxa, phylo, tabular = FALSE, lowercase = FALSE,
                          nodes = FALSE) {
  assert(taxa, "character")
  assert(phylo, c("phylo", "character"))
  assert(tabular, "logical")
  assert(lowercase, "logical")
  assert(nodes, "logical")

  taxa <- taxa_check(taxa)
  phylo <- phylo_check(phylo)
  out <- suppressWarnings(
    phylomatic(c(
      "-t", taxa,
      "-f", phylo,
      if (tabular) "-y",
      if (lowercase) "-l",
      if (nodes) "-n"
    ), intern = TRUE)
  )
  attr(out, "taxa_file") <- taxa
  attr(out, "phylo_file") <- phylo
  return(out)
}
