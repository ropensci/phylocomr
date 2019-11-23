context("ph_bladj")

ages_df <- data.frame(
  a = c('malpighiales','salicaceae','fabaceae','rosales','oleaceae',
        'gentianales','apocynaceae','rubiaceae'),
  b = c(81,20,56,76,47,71,18,56)
)

ages_file <- system.file("examples/ages", package = "phylocomr")
phylo_file <- system.file("examples/phylo_bladj", package = "phylocomr")

phylo_str <- readLines(phylo_file)

test_that("ph_bladj works with data.frame input", {
  skip_on_appveyor()
  skip_on_cran()
  
  aa <- ph_bladj(ages = ages_df, phylo = phylo_str)

  expect_is(aa, "character")
  expect_is(attr(aa, "ages_file"), "character")
  expect_match(attr(aa, "ages_file"), "ages")
  expect_is(attr(aa, "phylo_file"), "character")
  expect_match(attr(aa, "phylo_file"), "phylo")

  expect_match(aa, "malpighiales")
  expect_match(aa, "poales")
  expect_match(aa, "ericales_to_asterales")

  if (requireNamespace('ape')) {
    library(ape)
    tree <- read.tree(text = aa)
    expect_is(tree, "phylo")
  }
})

test_that("ph_bladj works with file input", {
  skip_on_appveyor()
  skip_on_cran()

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
  expect_match(attr(aa, "phylo_file"), "phylo")

  expect_match(aa, "malpighiales")
  expect_match(aa, "poales")
  expect_match(aa, "ericales_to_asterales")

  if (requireNamespace('ape')) {
    library(ape)
    tree <- read.tree(text = aa)
    expect_is(tree, "phylo")
  }
})

test_that("ph_bladj fails well", {
  # required inputs
  expect_error(ph_bladj(), "argument \"ages\" is missing, with no default")
  expect_error(ph_bladj("Adsf"), "argument \"phylo\" is missing, with no default")

  # types are correct
  expect_error(ph_bladj(5, "asdfad"),
               "ages must be of class data.frame, character")
  expect_error(ph_bladj("adf", mtcars),
               "phylo must be of class phylo, character")
})

test_that("ph_bladj corrects mismatched cases in data.frame's/phylo objects", {
  skip_on_appveyor()
  skip_on_cran()
  
  # mismatch in `sample` case is fixed internally
  ages_df_err <- ages_df
  ages_df_err$a <- toupper(ages_df_err$a)
  expect_is(ph_bladj(ages_df_err, phylo_str), "character")

  # mismatch in `phylo` case is fixed internally
  phylo_str_err <- phylo_str
  phylo_str_err <- toupper(phylo_str_err)
  expect_is(ph_bladj(ages_df, phylo_str_err), "character")
  
  # mismatch in `sample` file is fixed internally
  ages_df_err <- ages_df
  ages_df_err$a <- toupper(ages_df_err$a)
  afile <- file.path(tempdir(), "ages")
  write_table(ages_df_err, afile)
  expect_is(ph_bladj(afile, phylo_str), "character")

  # mismatch in `sample` file is fixed internally
  phylo_str_err <- phylo_str
  phylo_str_err <- toupper(phylo_str_err)
  phylo_str_err_file <- tempfile("phylo_")
  cat(phylo_str_err, file = phylo_str_err_file, sep = "\n")
  expect_is(ph_bladj(ages_df, phylo_str_err_file), "character")
})
