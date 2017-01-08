#' rao - Rao's quadratic entropy
#'
#' A measure of within- and among-community diversity taking species
#' dissimilarity (phylogenetic dissimilarity) into account
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file
#' @param phylo (character/phylo) phylogeny as a phylo object or a newick
#' string (will be written to a temp file if provided) - or a path to a
#' file with a newick string
#' @return A list of 6 data.frame's:
#' \strong{Diversity components}:
#' \itemize{
#'  \item overall alpha (within-site)
#'  \item beta (among-site)
#'  \item total diversity
#'  \item Fst statistic of differentiation for diversity and phylogenetic
#'  diversity
#' }
#'
#' \strong{Within-community diversity}:
#' \itemize{
#'  \item Plot - Plot name
#'  \item NSpp - Number of species
#'  \item NIndiv - Number of individuals
#'  \item PropIndiv - Proportion of all individuals found in this plot
#'  \item D - Diversity (= Simpson’s diversity)
#'  \item Dp - Phylogenetic diversity (= Diversity weighted by interspecific
#'  phylogenetic distances)
#' }
#'
#' The remaining 4 tables compare each community pairwise:
#' \itemize{
#'  \item among_community_diversity_d - Among-community diversities
#'  \item among_community_diversity_h - Among-community diversities excluding
#'  within-community diversity
#'  \item among_community_phylogenetic_diversity_dp - Among-community
#'  phylogenetic diversities
#'  \item among_community_phylogenetic_diversity_hp - Among-community
#'  phylogenetic diversities excluding within-community diversity
#' }
#'
#' @family phylogenetic-diversity
#' @examples
#' sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
#' pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")
#'
#' # sample from data.frame, phylogeny from a string
#' sampledf <- read.table(sfile, header = FALSE,
#'   stringsAsFactors = FALSE)
#' phylo_str <- readLines(pfile)
#'
#' ph_rao(sample = sampledf, phylo = phylo_str)
#'
#' # both from files
#' sample_str <- paste0(readLines(sfile), collapse = "\n")
#' sfile2 <- tempfile()
#' cat(sample_str, file = sfile2, sep = '\n')
#' pfile2 <- tempfile()
#' phylo_str <- readLines(pfile)
#' cat(phylo_str, file = pfile2, sep = '\n')
#'
#' ph_rao(sample = sfile2, phylo = pfile2)
ph_rao <- function(sample, phylo) {
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
      "rao",
      paste0("-s ", basename(sample)),
      paste0("-f ", basename(phylo))
    ), collapse = " "), stdout = TRUE)
  )

  list(
    diversity_components = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("DIVERSITY COMPONENTS", out) + 1,
            to = grep("WITHIN-COMMUNITY DIVERSITY", out) - 1)
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    },
    within_community_diveristy = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("WITHIN-COMMUNITY DIVERSITY", out) + 1,
            to = grep("AMONG-COMMUNITY DIVERSITY \\(D\\)", out) - 1)
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    },
    among_community_diversity_d = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("AMONG-COMMUNITY DIVERSITY \\(D\\)", out) + 1,
            to = grep("AMONG-COMMUNITY DIVERSITY \\(H\\)", out) - 1)
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    },
    among_community_diversity_h = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("AMONG-COMMUNITY DIVERSITY \\(H\\)", out) + 1,
            to = grep("AMONG-COMMUNITY PHYLOGENETIC DIVERSITY \\(Dp\\)", out) - 1)
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    },
    among_community_phylogenetic_diversity_dp = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("AMONG-COMMUNITY PHYLOGENETIC DIVERSITY \\(Dp\\)", out) + 1,
            to = grep("AMONG-COMMUNITY PHYLOGENETIC DIVERSITY \\(Hp\\)", out) - 1)
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    },
    among_community_phylogenetic_diversity_hp = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("AMONG-COMMUNITY PHYLOGENETIC DIVERSITY \\(Hp\\)", out) + 1,
            to = length(out))
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    }
  )
}
