#' Executables
#'
#' @name executables
#' @param args a character vector of arguments to command.
#' @param intern capture output as character vector. Default: `FALSE`
#' @examples
#' ecovolve()
#' phylocom()
#' phylomatic()

#' @export
#' @rdname executables
ecovolve <- function(args = "--help", intern = FALSE) {
  run("ecovolve", args, intern)
}

#' @export
#' @rdname executables
phylocom <- function(args = "help", intern = FALSE) {
  run("phylocom", args, intern)
}

#' @export
#' @rdname executables
phylomatic <- function(args = "--help", intern = FALSE) {
  run("phylomatic", args, intern)
}

run <- function(name, args, intern){
  path <- file.path(
    system.file("bin", .Platform$r_arch, package = "phylocomr"), name)
  res <- sys::exec_internal(path, args, error = FALSE)
  txt <- rawToChar(res$stdout)

  # errors
  if (!res$status %in% 0:1) {
    if (res$status == 8 && name == "ecovolve") {
      stop(
        sprintf(
        "call to 'ecovolve' failed with status %d\n only 1 taxon; > 1 required",
                res$status), call. = FALSE)
    } else {
      stop(sprintf("call to '%s' failed with status %d\n%s", name,
                   res$status, txt), call. = FALSE)
    }
  }

  if (intern) {
    return(txt)
  } else {
    cat(txt)
  }
}
