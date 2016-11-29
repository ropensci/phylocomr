#' @export
ecovolve <- function(args = "--help"){
  run("ecovolve", args)
}

#' @export
phylocom <- function(args = "--help"){
  run("phylocom", args)
}

#' @export
phylomatic <- function(args = "--help"){
  run("phylomatic", args)
}

run <- function(name, args = args){
  path <- file.path(system.file("bin", package = "phylocom"), name)
  system2(path, args)
}
