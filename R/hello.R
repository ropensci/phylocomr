#' @export
ecovolve <- function(args = "--help"){
  run("ecovolve", args)
}

#' @export
phylocom <- function(args = "--help"){
  run("phylocom", args)
}

#' @export
phylomatic <- function(args = "--help", stdout = ""){
  run("phylomatic", args, stdout)
}

run <- function(name, args = args, stdout = ""){
  path <- file.path(system.file("bin", package = "phylocom"), name)
  system2(path, args, stdout = stdout)
}
