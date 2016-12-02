#' phylomatic
#'
#' @export
#' @param taxa (character) all taxa as a character vector, will be written to
#' a temp file if provided
#' @param taxa_file (character) path to taxa file
#' @param phylo (character) phylogeny as a newick string, will be written to
#' a temp file if provided
#' @param phylo_file (character) path to phylo file
#' @param tabular (logical) Output a tabular representation of phylogeny.
#' Default: \code{FALSE}
#' @param lowercase (logical) Convert all chars in taxa file to lowercase.
#' Default: \code{FALSE}
#' @param nodes (logical) label all nodes with default names.
#' Default: \code{FALSE}
#' @examples
#' taxa_file <- system.file("examples/taxa", package = "phylocom")
#' phylo_file <- system.file("examples/phylo", package = "phylocom")
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
#' (tree <- ph_phylomatic(taxa_file = taxa_file2, phylo_file = phylo_file2))
#' library(ape)
#' plot(read.tree(text = tree))
#'
ph_phylomatic <- function(taxa = NULL, taxa_file = NULL, phylo = NULL,
                          phylo_file = NULL, tabular = FALSE,
                          lowercase = FALSE, nodes = FALSE) {
  stopifnot(xor(!is.null(taxa), !is.null(taxa_file)))
  stopifnot(xor(!is.null(phylo), !is.null(phylo_file)))
  if (!is.null(taxa)) {
    taxa_file <- tempfile("taxa_")
    cat(taxa, file = taxa_file, sep = "\n")
  }
  if (!is.null(phylo)) {
    phylo_file <- tempfile("phylo_")
    cat(phylo, file = phylo_file, sep = "\n")
  }

  out <- suppressWarnings(
    phylomatic(paste0(c(
      paste0("-t ", taxa_file),
      paste0("-f ", phylo_file),
      if (tabular) "-y ",
      if (lowercase) "-l ",
      if (nodes) "-n "
    ), collapse = " "), stdout = TRUE)
  )[1]
  attr(out, "taxa_file") <- taxa_file
  attr(out, "phylo_file") <- phylo_file
  out
}
