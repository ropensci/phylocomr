#' pd - Faith's index of phylogenetic diversity
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file
#' @param phylo (character/phylo) phylogeny as a phylo object or a newick
#' string (will be written to a temp file if provided) - or a path to a
#' file with a newick string
#' @return A single data.frame, with the colums:
#' \itemize{
#'  \item sample - community name/label
#'  \item ntaxa - number of taxa
#'  \item PD - Faith's phylogenetic diversity
#'  \item treeBL - tree BL
#'  \item propTreeBL - proportion tree BL
#' }
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
  stopifnot(class(sample) %in% c('data.frame', 'character'))
  if (inherits(sample, "data.frame")) {
    sfile <- tempfile("sample_")
    utils::write.table(
      sample, file = sfile,
      quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
    sample <- sfile
  } else {
    stopifnot(file.exists(sample))
  }

  stopifnot(class(phylo) %in% c('phylo', 'character'))
  if (inherits(phylo, "phylo")) {
    tree <- ape::write.tree(phylo)
    pfile <- tempfile("phylo_")
    cat(tree, file = phylo, sep = "\n")
    phylo <- pfile
  } else {
    if (grepl("\\(\\(", phylo)) {
      pfile <- tempfile("phylo_")
      cat(phylo, file = pfile, sep = "\n")
      phylo <- pfile
    } else {
      stopifnot(file.exists(phylo))
    }
  }

  cdir <- getwd()
  bdir <- dirname(sample)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(paste0(c(
      "pd",
      paste0("-s ", basename(sample)),
      paste0("-f ", basename(phylo))
    ), collapse = " "), stdout = TRUE)
  )

  utils::read.table(text = out, header = TRUE, stringsAsFactors = FALSE)
}
