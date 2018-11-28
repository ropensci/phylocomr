context("phylomatic")
test_that("phylomatic executable works", {
  expect_output(phylomatic(), "Cam Webb")
  expect_is(phylomatic(intern = TRUE), "character")
  expect_match(phylomatic(intern = TRUE), "Cam Webb")
})


context("ph_phylomatic")

taxa_file <- system.file("examples/taxa", package = "phylocomr")
phylo_file <- system.file("examples/phylo", package = "phylocomr")

taxa_str <- readLines(taxa_file)
phylo_str <- readLines(phylo_file)

test_that("ph_phylomatic works with chr string input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_phylomatic(taxa = taxa_str, phylo = phylo_str)

  expect_is(aa, "character")
  expect_is(attr(aa, "taxa_file"), "character")
  expect_match(attr(aa, "taxa_file"), "taxa")
  expect_is(attr(aa, "phylo_file"), "character")
  expect_match(attr(aa, "phylo_file"), "phylo")

  expect_match(aa, "lobelia_conferta")
  expect_match(aa, "narcissus_cuatrecasasii")
  expect_match(aa, "poales_to_asterales")

  if (requireNamespace('ape')) {
    library(ape)
    tree <- read.tree(text = aa)
    expect_is(tree, "phylo")
  }
})

test_that("ph_phylomatic works with file input", {
  skip_on_appveyor()
  skip_on_cran()
  
  taxa_file2 <- tempfile()
  cat(taxa_str, file = taxa_file2, sep = '\n')
  phylo_file2 <- tempfile()
  cat(phylo_str, file = phylo_file2, sep = '\n')

  aa <- ph_phylomatic(taxa = taxa_file2, phylo = phylo_file2)

  expect_is(aa, "character")
  expect_is(attr(aa, "taxa_file"), "character")
  expect_is(attr(aa, "phylo_file"), "character")

  expect_match(aa, "lobelia_conferta")
  expect_match(aa, "narcissus_cuatrecasasii")
  expect_match(aa, "poales_to_asterales")

  if (requireNamespace('ape')) {
    library(ape)
    tree <- read.tree(text = aa)
    expect_is(tree, "phylo")
  }
})

test_that("ph_phylomatic fails well", {
  # required inputs
  expect_error(ph_phylomatic(),
               "argument \"taxa\" is missing, with no default")
  expect_error(ph_phylomatic("Adsf"),
               "argument \"phylo\" is missing, with no default")

  # types are correct
  expect_error(ph_phylomatic(5, "asdfad"),
               "taxa must be of class character")
  expect_error(ph_phylomatic("adf", 5),
               "phylo must be of class phylo, character")

  expect_error(ph_phylomatic(taxa_str, phylo_str, tabular = 5),
               "tabular must be of class logical")
  expect_error(ph_phylomatic(taxa_str, phylo_str, lowercase = 5),
               "lowercase must be of class logical")
  expect_error(ph_phylomatic(taxa_str, phylo_str, nodes = 5),
               "nodes must be of class logical")
})
