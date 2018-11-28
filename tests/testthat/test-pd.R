context("ph_pd")

sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")

sampledf <- read.table(sfile, header = FALSE,
   stringsAsFactors = FALSE)
phylo_str <- readLines(pfile)

test_that("ph_pd works with data.frame input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_pd(sample = sampledf, phylo = phylo_str)

  expect_is(aa, "tbl_df")
  expect_is(aa, "data.frame")

  expect_named(aa, c("sample", "ntaxa", "pd", "treebl", "proptreebl"))

  expect_is(aa$sample, "character")
  expect_type(aa$ntaxa, "integer")
  expect_type(aa$pd, "double")
  expect_type(aa$treebl, "double")
  expect_type(aa$proptreebl, "double")
})

test_that("ph_pd works with file input", {
  skip_on_appveyor()
  skip_on_cran()
  
  sample_str <- paste0(readLines(sfile), collapse = "\n")
  sfile2 <- tempfile()
  cat(sample_str, file = sfile2, sep = '\n')
  pfile2 <- tempfile()
  phylo_str <- readLines(pfile)
  cat(phylo_str, file = pfile2, sep = '\n')

  aa <- ph_pd(sample = sfile2, phylo = pfile2)

  expect_is(aa, "tbl_df")
  expect_is(aa, "data.frame")

  expect_named(aa, c("sample", "ntaxa", "pd", "treebl", "proptreebl"))

  expect_is(aa$sample, "character")
  expect_type(aa$ntaxa, "integer")
  expect_type(aa$pd, "double")
  expect_type(aa$treebl, "double")
  expect_type(aa$proptreebl, "double")
})


test_that("ph_pd fails well", {
  # required inputs
  expect_error(ph_pd(), "argument \"sample\" is missing, with no default")
  expect_error(ph_pd("Adsf"), "argument \"phylo\" is missing, with no default")

  # types are correct
  expect_error(ph_pd(5, "asdfad"),
               "sample must be of class data.frame, character")
  expect_error(ph_pd("adf", mtcars),
               "phylo must be of class phylo, character")
})
