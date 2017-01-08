#' aot
#'
#' @export
#' @param traits (data.frame) trait data.frame
#' @param traits_file (character) path to traits file
#' @param phylo (character) phylogeny as a newick string, will be written to
#' a temp file if provided
#' @param phylo_file (character) path to phylo file
#' @param randomizations (numeric) number of randomizations. Default: 999
#' @param trait_contrasts (numeric) Specify which trait should be used as 'x'
#' variable for contrasts. Default: 1
#' @param ebl_unstconst (logical) Use equal branch lengths and unstandardized
#' contrasts. Default: \code{FALSE}
#' @examples
#' traits_file <- system.file("examples/traits_aot", package = "phylocomr")
#' phylo_file <- system.file("examples/phylo_aot", package = "phylocomr")
#'
#' # from data.frame
#' traitsdf_file <- system.file("examples/traits_aot_df",
#'   package = "phylocomr")
#' traits <- read.table(text = readLines(traitsdf_file), header = TRUE,
#'   stringsAsFactors = FALSE)
#' phylo_str <- readLines(phylo_file)
#' (res <- ph_aot(traits = traits, phylo = phylo_str))
#'
#' # from files
#' traits_str <- paste0(readLines(traits_file), collapse = "\n")
#' traits_file2 <- tempfile()
#' cat(traits_str, file = traits_file2, sep = '\n')
#' phylo_file2 <- tempfile()
#' cat(phylo_str, file = phylo_file2, sep = '\n')
#' (res <- ph_aot(traits_file = traits_file2, phylo_file = phylo_file2))

ph_aot <- function(traits = NULL, traits_file = NULL, phylo = NULL,
                   phylo_file = NULL, randomizations = 999,
                   trait_contrasts = 1, ebl_unstconst = FALSE) {

  stopifnot(xor(!is.null(traits), !is.null(traits_file)))
  stopifnot(xor(!is.null(phylo), !is.null(phylo_file)))
  if (!is.null(traits)) {
    traits_file <- tempfile("trait_")
    utils::write.table(prep_traits(traits), file = traits_file,
                       quote = FALSE, row.names = FALSE)
  }
  if (!is.null(phylo)) {
    phylo_file <- tempfile("phylo_")
    cat(phylo, file = phylo_file, sep = "\n")
  }

  cdir <- getwd()
  bdir <- dirname(traits_file)
  stopifnot(bdir == dirname(phylo_file))
  setwd(bdir)
  on.exit(setwd(cdir))
  # on.exit(unlink(traits_file), add = TRUE)
  # on.exit(unlink(phylo_file), add = TRUE)

  out <- suppressWarnings(
    phylocom(paste0(c(
      "aotf",
      paste0("-t ", basename(traits_file)),
      paste0("-f ", basename(phylo_file)),
      paste0("-r ", randomizations),
      paste0("-x ", trait_contrasts),
      if (ebl_unstconst) "-e "
    ), collapse = " "), stdout = TRUE)
  )

  out
  # list(
  #   trait_conservatism = {
  #     astbl(utils::read.delim(text = out[
  #       seq(from = grep("Trait conservatism by node", out) + 1,
  #           to = grep("Output of independent contrast", out) - 2)
  #     ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
  #   },
  #   independent_contrasts = {
  #     astbl(utils::read.delim(text = out[
  #       seq(from = grep("Output of independent contrast", out) + 1,
  #           to = grep("Phylogenetic signal", out) - 2)
  #       ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
  #   },
  #   phylogenetic_signal = {
  #     astbl(utils::read.delim(text = out[
  #       seq(from = grep("Phylogenetic signal", out) + 1,
  #           to = grep("Independent contrast correlations", out) - 2)
  #       ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
  #   },
  #   ind_contrast_corr = {
  #     astbl(utils::read.delim(text = out[
  #       seq(from = grep("Independent contrast correlations", out) + 1,
  #           to = length(out))
  #       ], header = TRUE, stringsAsFactors = FALSE, sep = "\t"))
  #   }
  # )
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
