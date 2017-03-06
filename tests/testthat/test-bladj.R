context("ph_bladj")

library(phytools)

ages_df <- data.frame(
  a = c('malpighiales','salicaceae','fabaceae','rosales','oleaceae',
        'gentianales','apocynaceae','rubiaceae'),
  b = c(81,20,56,76,47,71,18,56)
)

ages_file <- system.file("examples/ages", package = "phylocomr")
phylo_file <- system.file("examples/phylo_bladj", package = "phylocomr")

phylo_str <- readLines(phylo_file)

test_that("ph_bladj works with data.frame input", {
  aa <- ph_bladj(ages = ages_df, phylo = phylo_str)

  expect_is(aa, "character")
  expect_is(attr(aa, "ages_file"), "character")
  expect_match(attr(aa, "ages_file"), "ages")
  expect_is(attr(aa, "phylo_file"), "character")
  expect_match(attr(aa, "phylo_file"), "phylo")

  expect_match(aa, "malpighiales")
  expect_match(aa, "poales")
  expect_match(aa, "ericales_to_asterales")

  tree <- phytools::read.newick(text = aa)
  expect_is(tree, "phylo")
})

test_that("ph_bladj works with file input", {
  ages_file2 <- file.path(tempdir(), "ages")
  write.table(ages_df, file = ages_file2, row.names = FALSE,
    col.names = FALSE, quote = FALSE)
  phylo_file2 <- tempfile()
  cat(phylo_str, file = phylo_file2, sep = '\n')

  aa <- ph_bladj(ages_file2, phylo_file2)

  expect_is(aa, "character")
  expect_is(attr(aa, "ages_file"), "character")
  expect_match(attr(aa, "ages_file"), "ages")
  expect_is(attr(aa, "phylo_file"), "character")
  expect_match(attr(aa, "phylo_file"), "file")

  expect_match(aa, "malpighiales")
  expect_match(aa, "poales")
  expect_match(aa, "ericales_to_asterales")

  tree <- phytools::read.newick(text = aa)
  expect_is(tree, "phylo")
})
