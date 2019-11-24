#' aot
#'
#' AOT conducts univariate and bivariate tests of phylogenetic signal and
#' trait correlations, respectively, and node-level analyses of trait
#' means and diversification.
#'
#' @export
#' @param traits (data.frame/character) trait data.frame or path to
#' traits file. required. See Details.
#' @template phylo
#' @param randomizations (numeric) number of randomizations. Default: 999
#' @param trait_contrasts (numeric) Specify which trait should be used as 'x'
#' variable for contrasts. Default: 1
#' @param ebl_unstconst (logical) Use equal branch lengths and unstandardized
#' contrasts. Default: `FALSE`
#' @return a list of data.frames
#' @details See [phylocomr-inputs] for expected input formats
#' @section Taxon name case:
#' In the `traits` table, if you're passing in a file, the names in the
#' first column must be all lowercase; if not, we'll lowercase them for you.
#' If you pass in a data.frame, we'll
#' lowercase them for your. All phylo tip/node labels are also lowercased
#' to avoid any casing problems
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
  tfile <- tempfile("trait_")
  if (inherits(traits, "data.frame")) {
    if (colnames(traits)[1] != "name") {
      stop("first column name in `traits` must be `name`", call. = FALSE)
    }
    if (inherits(traits[,1], c("character", "factor")))
      traits[,1] <- tolower(traits[,1])
    utils::write.table(prep_traits(traits), file = tfile,
                       quote = FALSE, row.names = FALSE)
  } else {
    stopifnot(file.exists(traits))
    zz <- tolower(readLines(traits))
    cat(zz, file = tfile, sep = "\n")
  }

  phylo <- phylo_check(phylo)

  cdir <- getwd()
  bdir <- dirname(tfile)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(c(
      "aotf",
      "-t", basename(tfile),
      "-f", basename(phylo),
      "-r", randomizations,
      "-x", trait_contrasts,
      if (ebl_unstconst) "-e "
    ), intern = TRUE)
  )

  phylocom_error(out)
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
