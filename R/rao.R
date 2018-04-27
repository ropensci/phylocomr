#' rao - Rao's quadratic entropy
#'
#' A measure of within- and among-community diversity taking species
#' dissimilarity (phylogenetic dissimilarity) into account
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file
#' @template phylo
#' @return A list of 6 data.frame's:
#' **Diversity components**:
#' 
#' - overall alpha (within-site)
#' - beta (among-site)
#' - total diversity
#' - Fst statistic of differentiation for diversity and phylogenetic
#'  diversity
#'
#' **Within-community diversity**:
#'
#' - Plot - Plot name
#' - NSpp - Number of species
#' - NIndiv - Number of individuals
#' - PropIndiv - Proportion of all individuals found in this plot
#' - D - Diversity (= Simpson’s diversity)
#' - Dp - Phylogenetic diversity (= Diversity weighted by interspecific
#'  phylogenetic distances)
#'
#' The remaining 4 tables compare each community pairwise:
#' 
#' - among_community_diversity_d - Among-community diversities
#' - among_community_diversity_h - Among-community diversities excluding
#'  within-community diversity
#' - among_community_phylogenetic_diversity_dp - Among-community
#'  phylogenetic diversities
#' - among_community_phylogenetic_diversity_hp - Among-community
#'  phylogenetic diversities excluding within-community diversity
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
      "rao",
      "-s", basename(sample),
      "-f", basename(phylo)
    ), intern = TRUE)
  )

  out <- strsplit(out, split = "\n")[[1]]

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
