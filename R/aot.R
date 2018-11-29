#' aot
#'
#' AOT conducts univariate and bivariate tests of phylogenetic signal and
#' trait correlations, respectively, and node-level analyses of trait
#' means and diversification.
#'
#' @export
#' @param traits (data.frame/character) trait data.frame or path to
#' traits file. required
#' @template phylo
#' @param randomizations (numeric) number of randomizations. Default: 999
#' @param trait_contrasts (numeric) Specify which trait should be used as 'x'
#' variable for contrasts. Default: 1
#' @param ebl_unstconst (logical) Use equal branch lengths and unstandardized
#' contrasts. Default: `FALSE`
#' @return a list of data.frames
#' @examples \dontrun{
#' traits_file <- system.file("examples/traits_aot", package = "phylocomr")
#' phylo_file <- system.file("examples/phylo_aot", package = "phylocomr")
#'
#' # from data.frame
#' traitsdf_file <- system.file("examples/traits_aot_df",
#'   package = "phylocomr")
#' traits <- read.table(text = readLines(traitsdf_file), header = TRUE,
#'   stringsAsFactors = FALSE)
#' phylo_str <- readLines(phylo_file)
#' (res <- ph_aot(traits, phylo = phylo_str))
#'
#' # from files
#' traits_str <- paste0(readLines(traits_file), collapse = "\n")
#' traits_file2 <- tempfile()
#' cat(traits_str, file = traits_file2, sep = '\n')
#' phylo_file2 <- tempfile()
#' cat(phylo_str, file = phylo_file2, sep = '\n')
#' (res <- ph_aot(traits_file2, phylo_file2))
#' }
ph_aot <- function(traits, phylo, randomizations = 999, trait_contrasts = 1,
                   ebl_unstconst = FALSE) {
  assert(traits, c("data.frame", "character"))
  assert(phylo, c("phylo", "character"))
  assert(randomizations, c('integer', 'numeric'))
  assert(trait_contrasts, c('integer', 'numeric'))
  assert(ebl_unstconst, 'logical')

  stopifnot(class(traits) %in% c('data.frame', 'character'))
  if (inherits(traits, "data.frame")) {
    tfile <- tempfile("trait_")
    utils::write.table(prep_traits(traits), file = tfile,
                       quote = FALSE, row.names = FALSE)
    traits <- tfile
  }

  phylo <- phylo_check(phylo)

  cdir <- getwd()
  bdir <- dirname(traits)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(c(
      "aotf",
      "-t", basename(traits),
      "-f", basename(phylo),
      "-r", randomizations,
      "-x", trait_contrasts,
      if (ebl_unstconst) "-e "
    ), intern = TRUE)
  )

  out <- strsplit(out, split = "\n")[[1]]

  list(
    trait_conservatism = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("Trait conservatism by node", out) + 1,
            to = grep("Output of independent contrast", out) - 2)
      ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    },
    independent_contrasts = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("Output of independent contrast", out) + 1,
            to = grep("Phylogenetic signal", out) - 2)
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    },
    phylogenetic_signal = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("Phylogenetic signal", out) + 1,
            to = grep("Independent contrast correlations", out) - 2)
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    },
    ind_contrast_corr = {
      astbl(utils::read.delim(text = out[
        seq(from = grep("Independent contrast correlations", out) + 1,
            to = length(out))
        ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
    }
  )
}

prep_traits <- function(x) {
  hd <- names(x)
  x <- rbind(hd, x)
  types <- unname(apply(x[,-1], 2, function(z) {
      if (length(unique(z)) == 2) {
        0
      } else {
        3
      }
    }))
  stats::setNames(x, c("type", types))
}
