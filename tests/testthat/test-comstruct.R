context("ph_comstruct")

sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")

sampledf <- read.table(sfile, header = FALSE,
  stringsAsFactors = FALSE)
phylo_str <- readLines(pfile)

test_that("ph_comstruct works with data.frame input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_comstruct(sample = sampledf, phylo = phylo_str)

  expect_is(aa, "data.frame")
  expect_true("plot" %in% names(aa))
  expect_true("ntaxa" %in% names(aa))
  expect_true("mpd" %in% names(aa))
  expect_true("mntd" %in% names(aa))
  expect_true("runs" %in% names(aa))

  expect_is(aa$plot, "character")
  expect_type(aa$ntaxa, "integer")
  expect_type(aa$nri, "double")

  # we had 8 taxa per community
  expect_equal(unique(aa$ntaxa[1]), 8)

  # 999 runs per community
  expect_equal(unique(aa$runs), 999)
})

test_that("ph_comstruct works with file input", {
  skip_on_appveyor()
  skip_on_cran()

  sample_str <- paste0(readLines(sfile), collapse = "\n")
  sfile2 <- tempfile()
  cat(sample_str, file = sfile2, sep = '\n')
  pfile2 <- tempfile()
  cat(phylo_str, file = pfile2, sep = '\n')

  aa <- ph_comstruct(sample = sfile2, phylo = pfile2)

  expect_is(aa, "data.frame")
  expect_true("plot" %in% names(aa))
  expect_true("ntaxa" %in% names(aa))
  expect_true("mpd" %in% names(aa))
  expect_true("mntd" %in% names(aa))
  expect_true("runs" %in% names(aa))

  expect_is(aa$plot, "character")
  expect_type(aa$ntaxa, "integer")
  expect_type(aa$nri, "double")

  # we had 8 taxa per community
  expect_equal(unique(aa$ntaxa[1]), 8)

  # 999 runs per community
  expect_equal(unique(aa$runs), 999)
})


test_that("ph_comstruct - different models give expected output", {
  skip_on_appveyor()
  skip_on_cran()
  
  n0 <- ph_comstruct(sample = sfile, phylo = pfile, null_model = 0)
  n1 <- ph_comstruct(sample = sfile, phylo = pfile, null_model = 1)

  # identical
  expect_identical(n0$mpd, n1$mpd)
  expect_identical(n0$mntd, n1$mntd)

  # not identical
  expect_false(identical(n0$nri, n1$nri))
  expect_false(identical(n0$nti, n1$nti))
})

test_that("ph_comstruct fails well", {
  # required inputs
  expect_error(ph_comstruct(),
               "argument \"sample\" is missing, with no default")
  expect_error(ph_comstruct("Adsf"),
               "argument \"phylo\" is missing, with no default")

  # types are correct
  expect_error(ph_comstruct(5, "asdfad"),
               "sample must be of class character, data.frame")
  expect_error(ph_comstruct("adf", mtcars),
               "phylo must be of class character, phylo")
  expect_error(ph_comstruct(sfile, pfile, null_model = mtcars),
               "null_model must be of class numeric, integer")
  expect_error(ph_comstruct(sfile, pfile, randomizations = mtcars),
               "randomizations must be of class numeric, integer")
  expect_error(ph_comstruct(sfile, pfile, swaps = mtcars),
               "swaps must be of class numeric, integer")
  expect_error(ph_comstruct(sfile, pfile, abundance = 5),
               "abundance must be of class logical")

  # correct set of values
  expect_error(ph_comstruct(sfile, pfile, null_model = 15),
               "null_model %in% 0:3 is not TRUE")
})
