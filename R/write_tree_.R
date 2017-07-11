## MODIFIED from ape:::.write.tree2
## via http://grokbase.com/t/r/r-sig-phylo/13c7v9emht/write-tree-doesnt-respect-scipen
## authors of original version: Emmanuel Paradis, Daniel Lawson, Klaus Schliep
## author of modified version: Francois Michonneau

checkLabel <- function(x, ...) {
  x <- gsub("^[[:space:]\\\\(]+", "", x)
  x <- gsub("[[:space:]\\\\)]+$", "", x)
  x <- gsub("[[:space:]]", "_", x)
  x <- gsub("[,:;]", "", x)
  x <- gsub("[\\\\(\\\\)]", "-", x)
  x <- gsub("_{2,}", "_", x)
  x <- gsub("-{2,}", "-", x)
  x
}

write_tree_ <- function(phy, digits = 10, tree.prefix = "") {
  brl <- !is.null(phy$edge.length)
  nodelab <- !is.null(phy$node.label)
  phy$tip.label <- checkLabel(phy$tip.label)
  if (nodelab)
    phy$node.label <- checkLabel(phy$node.label)
  f.d <- paste("%.", digits, "f", sep = "")
  cp <- function(x) {
    STRING[k] <<- x
    k <<- k + 1
  }
  add.internal <- function(i) {
    cp("(")
    desc <- kids[[i]]
    for (j in desc) {
      if (j > n)
        add.internal(j)
      else add.terminal(ind[j])
      if (j != desc[length(desc)])
        cp(",")
    }
    cp(")")
    if (nodelab && i > n)
      cp(phy$node.label[i - n])
    if (brl) {
      cp(":")
      cp(sprintf(f.d, phy$edge.length[ind[i]]))
    }
  }
  add.terminal <- function(i) {
    cp(phy$tip.label[phy$edge[i, 2]])
    if (brl) {
      cp(":")
      cp(sprintf(f.d, phy$edge.length[i]))
    }
  }
  n <- length(phy$tip.label)
  parent <- phy$edge[, 1]
  children <- phy$edge[, 2]
  kids <- vector("list", n + phy$Nnode)
  for (i in 1:length(parent)) kids[[parent[i]]] <- c(kids[[parent[i]]],
                                                     children[i])
  ind <- match(1:max(phy$edge), phy$edge[, 2])
  LS <- 4 * n + 5
  if (brl)
    LS <- LS + 4 * n
  if (nodelab)
    LS <- LS + n
  STRING <- character(LS)
  k <- 1
  cp(tree.prefix)
  cp("(")
  getRoot <- function(phy) phy$edge[, 1][!match(phy$edge[,1], phy$edge[, 2], 0)][1]
  root <- getRoot(phy)
  desc <- kids[[root]]
  for (j in desc) {
    if (j > n)
      add.internal(j)
    else add.terminal(ind[j])
    if (j != desc[length(desc)])
      cp(",")
  }
  if (is.null(phy$root.edge)) {
    cp(")")
    if (nodelab)
      cp(phy$node.label[1])
    cp(";")
  }
  else {
    cp(")")
    if (nodelab)
      cp(phy$node.label[1])
    cp(":")
    cp(sprintf(f.d, phy$root.edge))
    cp(";")
  }
  paste(STRING, collapse = "")
}
