#' comdist
#'
#' Outputs the phylogenetic distance between samples, based on phylogenetic
#' distances of taxa in one sample to the taxa in the other
#'
#' @export
#' @param sample (data.frame/character) sample data.frame or path to a
#' sample file
#' @template phylo
#' @param rand_test (logical) do you want to use null models? 
#' Default: `FALSE`
#' @template com_args
#' @template com_null_models
#' @return data.frame or a list of data.frame's if use null models
#' @details See [phylocomr-inputs] for expected input formats
#' @section Taxon name case:
#' In the `sample` table, if you're passing in a file, the names in the
#' third column must be all lowercase; if not, we'll lowercase them for you.
#' If you pass in a data.frame, we'll lowercase them for your. All phylo
#' tip/node labels are also lowercased to avoid any casing problems
#' @examples
#' sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
#' pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")
#'
#' # from data.frame
#' sampledf <- read.table(sfile, header = FALSE,
#'   stringsAsFactors = FALSE)
#' phylo_str <- readLines(pfile)
#' ph_comdist(sample = sampledf, phylo = phylo_str)
#' ph_comdistnt(sample = sampledf, phylo = phylo_str)
#' ph_comdist(sample = sampledf, phylo = phylo_str, rand_test = TRUE)
#' ph_comdistnt(sample = sampledf, phylo = phylo_str, rand_test = TRUE)
#'
#' # from files
#' sample_str <- paste0(readLines(sfile), collapse = "\n")
#' sfile2 <- tempfile()
#' cat(sample_str, file = sfile2, sep = '\n')
#' pfile2 <- tempfile()
#' cat(phylo_str, file = pfile2, sep = '\n')
#' ph_comdist(sample = sfile2, phylo = pfile2)
#' ph_comdistnt(sample = sfile2, phylo = pfile2)
#' ph_comdist(sample = sfile2, phylo = pfile2, rand_test = TRUE)
#' ph_comdistnt(sample = sfile2, phylo = pfile2, rand_test = TRUE)
ph_comdist <- function(sample, phylo, rand_test = FALSE, null_model = 0, randomizations = 999,
                       abundance = TRUE) {
  com_dist(sample, phylo, rand_test = rand_test, null_model = null_model,
           randomizations = randomizations, abundance = abundance, "comdist")
}

#' @export
#' @rdname ph_comdist
ph_comdistnt <- function(sample, phylo, rand_test = FALSE, null_model = 0, randomizations = 999,
                         abundance = TRUE) {
  com_dist(sample, phylo, rand_test = rand_test, null_model = null_model,
           randomizations = randomizations, abundance = abundance, "comdistnt")
}

com_dist <- function(sample, phylo, rand_test = FALSE, null_model = 0, randomizations = 999,
                     abundance = TRUE, method) {

  assert(sample, c("character", "data.frame"))
  assert(phylo, c("character", "phylo"))
  assert(rand_test, "logical")
  assert(null_model, c("numeric", "integer"))
  assert(randomizations, c("numeric", "integer"))
  assert(abundance, "logical")
  stopifnot(null_model %in% 0:3)

  sample <- sample_check(sample)
  phylo <- phylo_check(phylo)

  cdir <- getwd()
  bdir <- dirname(sample)
  stopifnot(bdir == dirname(phylo))
  setwd(bdir)
  on.exit(setwd(cdir))

  if(rand_test){
    out <- suppressWarnings(
      phylocom(c(
        method,
        "-s", basename(sample),
        "-f", basename(phylo),
        "-m", null_model,
        "-r", randomizations,
        if (rand_test) "-n",
        if (abundance) "-a"
      ), intern = TRUE)
    )
  } else {
    out <- suppressWarnings(
      phylocom(c(
        method,
        "-s", basename(sample),
        "-f", basename(phylo),
        if (abundance) "-a"
      ), intern = TRUE)
    )
  }

  phylocom_error(out)
  if(rand_test == FALSE){
    tmp <- astbl(utils::read.table(text = out, header = TRUE, stringsAsFactors = FALSE))
    names(tmp)[1] = 'name'
  } else {
    tmp <- utils::read.table(text = out, header = FALSE, stringsAsFactors = FALSE)
    # split output into a list of 4 data frames
    tmp <- clean_null_results(tmp)
  }
  return(tmp)
}

set_names_null_results <- function(df){
  names(df) <- c('name', df[1, -1]) # use the first row as column names
  df <- df[-1,] # then remove the first row
  rownames(df) <- NULL # reset row names
  df[, -1] = apply(df[, -1], 2, as.numeric) # phylocom returns characters
  df
}

# split output of null models into a list of 4 data frames
clean_null_results <- function(tmp){
  n_per_df <- nrow(tmp) / 4 # four parts: observed, mean of null, sd of null, and NRI
  obs <- set_names_null_results(tmp[1:n_per_df,])
  null_mean <- set_names_null_results(tmp[(1 + n_per_df):(2 * n_per_df), ])
  null_sd <- set_names_null_results(tmp[(1 + 2 * n_per_df):(3 * n_per_df), ])
  SES <- set_names_null_results(tmp[(1 + 3 * n_per_df):(4 * n_per_df), ])
  tmp <- list(obs = obs, null_mean = null_mean,
              null_sd = null_sd, NRI_or_NTI = SES)
  tmp
}
