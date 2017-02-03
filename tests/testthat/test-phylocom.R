context("phylocom")
test_that("phylocom executable works", {
  expect_output(phylocom(), "Cam Webb")
  expect_output(phylocom(), "Copyright")
  expect_output(phylocom(), "community structure")
  expect_output(phylocom(), "Phylogeny Tools")
  expect_is(phylocom(stdout = FALSE), "character")
  expect_match(phylocom(stdout = FALSE), "Cam Webb")

  #expect_output(phylocom(""), "Oops! Command not recognized")
  #expect_output(phylocom("stuff"), "Oops! Command not recognized")
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
