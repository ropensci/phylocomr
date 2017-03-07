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
  path <- file.path(
    system.file("bin", .Platform$r_arch, package = "phylocomr"), name)
  res <- sys::exec_internal(path, args, error = FALSE)
  txt <- rawToChar(res$stdout)

  # errors
  if (!res$status %in% 0:1) {
    if (res$status == 8 && name == "ecovolve") {
      stop(sprintf("call to 'ecovolve' failed with status %d\n only 1 taxon; > 1 required",
                   res$status), call. = FALSE)
    } else {
      stop(sprintf("call to '%s' failed with status %d\n%s", name,
                   res$status, txt), call. = FALSE)
    }
  }

  # return
  if (stdout == "") {
    cat(txt)
  } else {
    return(txt)
  }
}
