#' ecovolve
#'
#' Ecovolve generates a phylogeny via a random birth and death process,
#' generates a traits file with five randomly evolving, in-dependent traits,
#' and a sample file with a single sample unit (‘alive’) containing all
#' extant members of the phylogeny.
#'
#' @export
#' @param speciation (numeric) Probability of speciation per unit time.
#' Default: 0.05
#' @param extinction (numeric) Probability of extinction per unit time.
#' Default: 0.01
#' @param time_units (integer) Time units to simulate over. Default: 100
#' @param out_mode (integer) Output mode (2 = LTT; 3 = newick). Default: 3
#' @param prob_env (character) Probability envelope for character change.
#' must be a string of 10 integers. Default: 3211000000
#' @param extant_lineages (logical) Stop simulation after this number of
#' extant lineages. Default: `FALSE`
#' @param only_extant (logical) Output phylogeny pruned only for extant taxa.
#' Default: `FALSE`
#' @param taper_change (numeric/integer) Taper character change by
#' `e^(-time/F)`. This produces more conservatism in traits
#' (see Kraft et al., 2007). Default: `NULL`, not passed
#' @param competition (logical) Simulate competition, with trait proximity
#' increasing extinction. Default: `FALSE`
#' @return a list with three elements:
#' 
#' - phylogeny - a phylogeny as a newick string. In the case of
#'  `out_mode = 2` gives a Lineage Through Time data.frame instead of a
#'  newick phylogeny
#' - sample - a data.frame with three columns, "sample" (all "alive"),
#'  "abundance" (all 1's), "name" (the species code). In the case of
#'  `out_mode = 2` gives an empty data.frame
#' - traits - a data.frame with first column with spcies code ("name"),
#'  then 5 randomly evolved and independent traits. In the case of
#'  `out_mode = 2` gives an empty data.frame
#'
#' @section Clean up:
#' Two files, "ecovolve.sample" and "ecovolve.traits" are written to the
#' current working directory when this function runs - we read these files
#' in, then delete the files via [unlink]
#'
#' @section Failure behavior:
#' Function occasionally fails with error "call to 'ecovolve' failed
#' with status 8. only 1 taxon; > 1 required" - this just means that only
#' 1 taxon was created in the random process, so the function can't proceed
#'
#' @examples \dontrun{
#' # ph_ecovolve(speciation = 0.05)
#' # ph_ecovolve(speciation = 0.1)
#' # ph_ecovolve(extinction = 0.005)
#' # ph_ecovolve(time_units = 50)
#' # ph_ecovolve(out_mode = 2)
#' # ph_ecovolve(extant_lineages = TRUE)
#' # ph_ecovolve(extant_lineages = FALSE)
#' # ph_ecovolve(only_extant = FALSE)
#' # ph_ecovolve(only_extant = TRUE, speciation = 0.1)
#' # ph_ecovolve(taper_change = 2)
#' # ph_ecovolve(taper_change = 10)
#' # ph_ecovolve(taper_change = 500)
#'
#' if (requireNamespace("ape")) {
#'   # library(ape)
#'   # x <- ph_ecovolve(speciation = 0.05)
#'   # plot(read.tree(text = x$phylogeny))
#' }
#' 
#' }

ph_ecovolve <- function(speciation = 0.05, extinction = 0.01, time_units = 100,
  out_mode = 3, prob_env = '3211000000', extant_lineages = FALSE,
  only_extant = FALSE, taper_change = NULL, competition = FALSE) {

  assert(speciation, c("numeric", "integer"))
  assert(extinction, c("numeric", "integer"))
  assert(time_units, c("numeric", "integer"))
  assert(out_mode, c("numeric", "integer"))
  stopifnot(out_mode %in% 2:3)
  assert(prob_env, "character")
  assert(extant_lineages, "logical")
  assert(only_extant, "logical")
  assert(taper_change, c("numeric", "integer"))
  assert(competition, "logical")

  # run and collect newick string
  out <- suppressWarnings(
    ecovolve(c(
      "-s", speciation,
      "-e", extinction,
      "-t", time_units,
      "-m", out_mode,
      "-c", prob_env,
      if (extant_lineages) "-l", extant_lineages,
      if (only_extant) "-p", only_extant,
      if (!is.null(taper_change)) "-d ", taper_change,
      if (competition) "-x"
    ), intern = TRUE)
  )

  # collect ecovolve files
  e_sample <- e_traits <- astbl()
  if (out_mode == 3) {
    efiles <- list.files(pattern = "ecovolve.", full.names = TRUE)
    on.exit(unlink(efiles, force = TRUE))
    e_sample <- stats::setNames(
      astbl(utils::read.table(grep(".sample", efiles, value = TRUE),
                              header = FALSE, stringsAsFactors = FALSE)),
      c('sample', 'abundance', 'name')
    )
    e_traits <- astbl(utils::read.table(grep(".traits", efiles, value = TRUE),
                                        skip = 1, header = TRUE,
                                        stringsAsFactors = FALSE))
  } else {
    out <- astbl(utils::read.table(text = out, header = FALSE,
                             stringsAsFactors = FALSE))
  }

  # return stuff
  return(list(phylogeny = out, sample = e_sample, traits = e_traits))
}
