context("phylomatic")
test_that("phylomatic executable works", {
  expect_output(phylomatic(), "Cam Webb")
  expect_is(phylomatic(stdout = FALSE), "character")
  expect_match(phylomatic(stdout = FALSE), "Cam Webb")
})


context("ph_phylomatic")

library(phytools)

taxa_file <- system.file("examples/taxa", package = "phylocomr")
phylo_file <- system.file("examples/phylo", package = "phylocomr")

taxa_str <- readLines(taxa_file)
phylo_str <- readLines(phylo_file)

test_that("ph_phylomatic works with chr string input", {
  aa <- ph_phylomatic(taxa = taxa_str, phylo = phylo_str)

  expect_is(aa, "character")
  expect_is(attr(aa, "taxa_file"), "character")
  expect_match(attr(aa, "taxa_file"), "taxa")
  expect_is(attr(aa, "phylo_file"), "character")
  expect_match(attr(aa, "phylo_file"), "phylo")

  expect_match(aa, "lobelia_conferta")
  expect_match(aa, "narcissus_cuatrecasasii")
  expect_match(aa, "poales_to_asterales")

  tree <- phytools::read.newick(text = aa)
  expect_is(tree, "phylo")
})

test_that("ph_phylomatic works with file input", {
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

  tree <- phytools::read.newick(text = aa)
  expect_is(tree, "phylo")
})
