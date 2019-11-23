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
#' @section Original data:
#' We have to write files to disk (your computer) to be able to run
#' Phylocom. We take the inputs you give to the functions in this package
#' and re-write them to temporary files (that are cleaned up when the 
#' R session exits). We do this because we sometimes need to modify your
#' inputs; usually because Phylocom is case sensitive. In this way we
#' aren't modifying your original data files.
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
