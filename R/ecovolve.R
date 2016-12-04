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
#' library(phytools)
#' plo_t <- function(x) plot(phytools::read.newick(text = x))
#'
#' plo_t(ph_ecovolve(speciation = 0.05))
#' plo_t(ph_ecovolve(speciation = 0.1))
#' plo_t(ph_ecovolve(extinction = 0.005))
#' plo_t(ph_ecovolve(time_units = 50))
#' ph_ecovolve(out_mode = 2)
#' plo_t(ph_ecovolve(extant_lineages = TRUE))
#' plo_t(ph_ecovolve(extant_lineages = FALSE))
#' plo_t(ph_ecovolve(only_extant = FALSE))
#' plo_t(ph_ecovolve(only_extant = TRUE))
#' plo_t(ph_ecovolve(taper_change = 2))
#' plo_t(ph_ecovolve(taper_change = 10))
#' plo_t(ph_ecovolve(taper_change = 500))
#' plo_t(ph_ecovolve(competition = TRUE))
#' plo_t(ph_ecovolve(competition = FALSE))

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
