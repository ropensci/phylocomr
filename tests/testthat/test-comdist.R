context("ph_comdist")

sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")

sampledf <- read.table(sfile, header = FALSE,
  stringsAsFactors = FALSE)
phylo_str <- readLines(pfile)

test_that("ph_comdist works with data.frame input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_comdist(sample = sampledf, phylo = phylo_str)
  aa_null <- ph_comdist(sample = sampledf, phylo = phylo_str, rand_test = TRUE)

  expect_is(aa, "data.frame")
  expect_named(aa, c('name', 'clump1', 'clump2a', 'clump2b', 'clump4', 'even',
                     'random'))

  expect_is(aa$name, "character")
  expect_type(aa$clump1, "double")
  expect_type(aa$even, "double")

  expect_is(aa_null, "list")
  expect_named(aa_null, c('obs', 'null_mean', 'null_sd', 'NRI_or_NTI'))
  expect_named(aa_null$obs, c('name', 'clump1', 'clump2a', 'clump2b', 'clump4', 'even',
                              'random'))

  expect_is(aa_null$obs$name, "character")
  expect_type(aa_null$obs$clump1, "double")
  expect_type(aa_null$obs$even, "double")
  expect_is(aa_null$null_mean$name, "character")
  expect_type(aa_null$null_sd$clump1, "double")
  expect_type(aa_null$NRI_or_NTI$even, "double")
})

test_that("ph_comdist works with file input", {
  skip_on_appveyor()
  skip_on_cran()

  sample_str <- paste0(readLines(sfile), collapse = "\n")
  sfile2 <- tempfile()
  cat(sample_str, file = sfile2, sep = '\n')
  pfile2 <- tempfile()
  cat(phylo_str, file = pfile2, sep = '\n')

  aa <- ph_comdist(sample = sfile2, phylo = pfile2)
  aa_null <- ph_comdist(sample = sfile2, phylo = pfile2, rand_test = TRUE)

  expect_is(aa, "data.frame")
  expect_named(aa, c('name', 'clump1', 'clump2a', 'clump2b', 'clump4', 'even',
                     'random'))

  expect_is(aa$name, "character")
  expect_type(aa$clump1, "double")
  expect_type(aa$even, "double")

  expect_is(aa_null, "list")
  expect_named(aa_null, c('obs', 'null_mean', 'null_sd', 'NRI_or_NTI'))
  expect_named(aa_null$obs, c('name', 'clump1', 'clump2a', 'clump2b', 'clump4', 'even',
                     'random'))

  expect_is(aa_null$obs$name, "character")
  expect_type(aa_null$obs$clump1, "double")
  expect_type(aa_null$obs$even, "double")
  expect_is(aa_null$null_mean$name, "character")
  expect_type(aa_null$null_sd$clump1, "double")
  expect_type(aa_null$NRI_or_NTI$even, "double")

})


test_that("ph_comdist - different models give expected output", {
  skip_on_appveyor()
  skip_on_cran()
  
  n0 <- ph_comdist(sample = sfile, phylo = pfile, null_model = 0)
  n1 <- ph_comdist(sample = sfile, phylo = pfile, null_model = 1)

  n0_null <- ph_comdist(sample = sfile, phylo = pfile, rand_test = TRUE, null_model = 0)
  n1_null <- ph_comdist(sample = sfile, phylo = pfile, rand_test = TRUE, null_model = 1)

  # identical
  expect_identical(n0$clump1, n1$clump1)
  expect_identical(n0$clump4, n1$clump4)

  expect_identical(n0$clump1, n0_null$obs$clump1)
  expect_identical(n1$clump1, n1_null$obs$clump1)
})

test_that("ph_comdist fails well", {
  # required inputs
  expect_error(ph_comdist(), "argument \"sample\" is missing, with no default")
  expect_error(ph_comdist("Adsf"), "argument \"phylo\" is missing, with no default")

  # types are correct
  expect_error(ph_comdist(5, "asdfad"),
               "sample must be of class character, data.frame")
  expect_error(ph_comdist("adf", mtcars),
               "phylo must be of class character, phylo")
  expect_error(ph_comdist(sfile, pfile, rand_test = 5),
               "rand_test must be of class logical")
  expect_error(ph_comdist(sfile, pfile, null_model = mtcars),
               "null_model must be of class numeric, integer")
  expect_error(ph_comdist(sfile, pfile, randomizations = mtcars),
               "randomizations must be of class numeric, integer")
  expect_error(ph_comdist(sfile, pfile, abundance = 5),
               "abundance must be of class logical")

  # correct set of values
  expect_error(ph_comdist(sfile, pfile, null_model = 15),
               "null_model %in% 0:3 is not TRUE")
})

