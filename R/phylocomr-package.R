#' Phylocom interface
#'
#' `phylocomr` gives you access to Phylocom, specifically the
#' Phylocom C library (https://github.com/phylocom/phylocom/),
#' licensed under BSD 2-clause 
#' (http://www.opensource.org/licenses/bsd-license.php)
#'
#' This package isn't doing system calls to a separately installed Phylocom
#' instance - but actually includes Phylocom itself in the package.
#'
#' Phylocom is usually used either on the command line or through the
#' R package \pkg{picante}, which has duplicated some of the Phylocom 
#' functionality.
#'
#' In terms of performance, some functionality will be faster here than
#' in `picante`, but the maintainers of `picante` have re-written some
#' Phylocom functionality in C/C++, so performance should be similar in
#' those cases.
#'
#' @section Package API:
#'
#' - [ecovolve()]/[ph_ecovolve()] - interface to `ecovolve` executable,
#'  and a higher level interface
#' - [phylomatic()]/[ph_phylomatic()] - interface to `phylomatic`
#'  executable, and a higher level interface
#' - [phylocom()] - interface to `phylocom` executable
#' - [ph_aot()] - higher level interface to `aot`
#' - [ph_bladj()] - higher level interface to `bladj`
#' - [ph_comdist()]/[ph_comdistnt()] - higher level interface to comdist
#' - [ph_comstruct()] - higher level interface to comstruct
#' - [ph_comtrait()] - higher level interface to comtrait
#' - [ph_pd()] - higher level interface to Faith's phylogenetic diversity
#'
#' @name phylocomr-package
#' @aliases phylocomr
#' @docType package
#' @author Scott Chamberlain
#' @author Jeroen Ooms
NULL
