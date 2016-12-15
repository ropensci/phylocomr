#' Executables
#'
#' @name executables
#' @param args a character vector of arguments to command.
#' @param stdout where output to stdout should be sent, see
#' \code{\link{system2}}
#' @examples
#' ecovolve()
#' phylocom()
#' phylomatic()

#' @export
#' @rdname executables
ecovolve <- function(args = "--help", stdout = "") {
  run("ecovolve", args, stdout = stdout)
}

#' @export
#' @rdname executables
phylocom <- function(args = "help", stdout = "") {
  run("phylocom", args, stdout = stdout)
}

#' @export
#' @rdname executables
phylomatic <- function(args = "--help", stdout = "") {
  run("phylomatic", args, stdout)
}

run <- function(name, args = args, stdout = ""){
  path <- file.path(system.file("bin", .Platform$r_arch, package = "phylocomr"), name)
  res <- system2(path, args, stdout = stdout)
  status <- attr(res, "status")
  if(isTRUE(stdout) && is.numeric(status)){
    if(status != 0)
      stop(sprintf("call to %s failed with status %d", name, status))
  }
  res
}
