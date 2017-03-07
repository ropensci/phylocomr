#' comtrait
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file
#' @param traits (data.frame/character) traits data.frame or path to a
#' traits file
#' @param binary (logical) a logical vector indicating what columns are to
#' be treated as binary characters - all others are treated as continuous
#' @param metric (integer) metric to calculate. One of variance, mpd, mntd,
#' or range (converted to phylocom integer format internally)
#' @template com_args
#'
#' @section Null models:
#' \itemize{
#'  \item 0 - This null model shuffles trait values across species.
#'  \item 1 - Species in each sample become random draws from sample pool.
#'  This null model maintains the species richness of each sample, but
#'  the identities of the species occurring in each sample are randomized.
#'  For each sample, species are drawn without replacement from the list of
#'  all species actually occurring in at least one sample
#'  \item 2 - Species in each sample become random draws from traits data.
#'  This null model maintains the species richness of each sample, but the
#'  identities of the species occurring in each sample are randomized. For
#'  each sample, species are drawn without replacement from the list of all
#'  species with trait values. This function is redundant since by definition
#'  the sample and trait species must match, but is included for consistency
#'  with the comstruct function.
#'  \item 3 - Independent swap: Same as for \code{\link{ph_comdist}} and
#'  \code{\link{ph_comstruct}}
#' }
#'
#' @details
#' If you give a data.frame to `traits` parameter it expects data.frame like
#' \itemize{
#'  \item species - the taxon labels matching the sample data to `sample`
#'  parameter
#'  \item col1,col2,col3,etc. - any number of trait columns - column names do
#'  not matter
#' }
#'
#' When giving a data.frame to `traits` make sure to pass in a binary
#' vector for what traits are to be treated as binary.
#'
#' @return data.frame of the form:
#' \itemize{
#'  \item trait - Trait name
#'  \item sample - Sample name
#'  \item ntaxa - Number of taxa in sample
#'  \item mean - Mean value of trait in sample
#'  \item metric - Observed metric in sample
#'  \item meanrndmetric - Mean value of metric in null models
#'  \item sdrndmetric - Standard deviation of metric in null models
#'  \item sesmetric - Standardized effect size of metric
#'  \item ranklow - Number of randomizations with metric lower than observed
#'  \item rankhigh - Number of randomizations with metric higher than observed
#'  \item runs - Number of randomizations
#' }
#' @examples
#' sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
#' tfile <- system.file("examples/traits_aot", package = "phylocomr")
#'
#' # from files
#' sample_str <- paste0(readLines(sfile), collapse = "\n")
#' sfile2 <- tempfile()
#' cat(sample_str, file = sfile2, sep = '\n')
#'
#' traits_str <- paste0(readLines(tfile), collapse = "\n")
#' tfile2 <- tempfile()
#' cat(traits_str, file = tfile2, sep = '\n')
#'
#' ph_comtrait(sample = sfile2, traits = tfile2)
#'
#' # from data.frame
#' sampledf <- read.table(sfile, header = FALSE,
#'   stringsAsFactors = FALSE)
#' traitsdf_file <- system.file("examples/traits_aot_df",
#'   package = "phylocomr")
#' traitsdf <- read.table(text = readLines(traitsdf_file), header = TRUE,
#'   stringsAsFactors = FALSE)
#' ph_comtrait(sample = sampledf, traits = traitsdf,
#'   binary = c(FALSE, FALSE, FALSE, TRUE))
ph_comtrait <- function(sample, traits, binary = NULL, metric = "variance",
                        null_model = 0, randomizations = 999,
                        abundance = TRUE) {

  sample <- sample_check(sample)
  traits <- trait_check(x = traits, binary)

  metric <- switch(
    metric,
    variance = 1, mpd = 2, mntd = 3, range = 4,
    stop('metric not in acceptable set, see docs', call. = FALSE))

  cdir <- getwd()
  bdir <- dirname(sample)
  stopifnot(bdir == dirname(traits))
  setwd(bdir)
  on.exit(setwd(cdir))

  out <- suppressWarnings(
    phylocom(c(
      "comtrait",
      "-s", basename(sample),
      "-t", basename(traits),
      "-m", null_model,
      "-r", randomizations,
      "-x", metric,
      if (abundance) "-a"
    ), stdout = TRUE)
  )

  astbl(utils::read.table(text = out, skip = 1, header = TRUE,
                    stringsAsFactors = FALSE))
}
