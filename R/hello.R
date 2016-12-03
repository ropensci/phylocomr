#' @export
ecovolve <- function(args = "--help", stdout = "") {
  run("ecovolve", args, stdout = stdout)
}

#' @export
phylocom <- function(args = "help", stdout = "") {
  run("phylocom", args, stdout = stdout)
}

#' @export
phylomatic <- function(args = "--help", stdout = "") {
  run("phylomatic", args, stdout)
}

run <- function(name, args = args, stdout = ""){
  path <- file.path(system.file("bin", package = "phylocom"), name)
  system2(path, args, stdout = stdout)
}
