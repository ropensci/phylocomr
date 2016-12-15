#' ecovolve
#'
#' FIXME: need to read in sample and trait files
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
#' extant lineages. Default: \code{FALSE}
#' @param only_extant (logical) Output phylogeny pruned only for extant taxa.
#' Default: \code{FALSE}
#' @param taper_change (character) Taper character change by \code{e^(-time/F)}.
#' This produces more conservatism in traits (see Kraft et al., 2007).
#' Default: NULL, not passed
#' @param competition (logical) Simulate competition, with trait proximity
#' increasing extinction. Default: \code{FALSE}
#' @examples
#' ph_ecovolve(speciation = 0.05)
#' ph_ecovolve(speciation = 0.1)
#' ph_ecovolve(extinction = 0.005)
#' ph_ecovolve(time_units = 50)
#' ph_ecovolve(out_mode = 2)
#' ph_ecovolve(extant_lineages = TRUE)
#' ph_ecovolve(extant_lineages = FALSE)
#' ph_ecovolve(only_extant = FALSE)
#' ph_ecovolve(only_extant = TRUE)
#' ph_ecovolve(taper_change = 2)
#' ph_ecovolve(taper_change = 10)
#' ph_ecovolve(taper_change = 500)
#' ph_ecovolve(competition = TRUE)
#' ph_ecovolve(competition = FALSE)
#'
#' # library(phytools)
#' # x <- ph_ecovolve(speciation = 0.05)
#' # plot(phytools::read.newick(text = x))

ph_ecovolve <- function(speciation = 0.05, extinction = 0.01, time_units = 100,
  out_mode = 3, prob_env = '3211000000', extant_lineages = FALSE,
  only_extant = FALSE, taper_change = NULL, competition = FALSE) {

  suppressWarnings(
    ecovolve(paste0(c(
      paste0("-s ", speciation),
      paste0("-e ", extinction),
      paste0("-t ", time_units),
      paste0("-m ", out_mode),
      paste0("-c ", prob_env),
      if (extant_lineages) paste0("-l ", extant_lineages),
      if (only_extant) paste0("-p ", only_extant),
      if (!is.null(taper_change)) paste0("-d ", taper_change),
      if (competition) "-x "
    ), collapse = " "), stdout = TRUE)
  )
}
