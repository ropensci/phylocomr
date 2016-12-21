#' @section Null models:
#' \itemize{
#'  \item 0 - Phylogeny shuffle: This null model shuffles species labels across
#'  the entire phylogeny. This randomizes phylogenetic relationships among
#'  species.
#'  \item 1 - Species in each sample become random draws from sample pool:
#'  This null model maintains the species richness of each sample, but the
#'  identities of the species occurring in each sample are randomized. For
#'  each sample, species are drawn without replacement from the list of all
#'  species actually occurring in at least one sample. Thus, species in the
#'  phylogeny that are not actually observed to occur in a sample will not
#'  be included in the null communities
#'  \item 2 - Species in each sample become random draws from phylogeny pool:
#'  This null model maintains the species richness of each sample, but the
#'  identities of the species occurring in each sample are randomized. For
#'  each sample, species are drawn without replacement from the list of all
#'  species in the phylogeny pool. All species in the phylogeny will have
#'  equal probability of being included in the null communities. By changing
#'  the phylogeny, different species pools can be simulated. For example, the
#'  phylogeny could include the species present in some larger region.
#'  \item 3 - Independent swap: The independent swap algorithm (Gotelli and
#'  Entsminger, 2003); also known as ‘SIM9’ (Gotelli, 2000) creates swapped
#'  versions of the sample/species matrix.
#' }
