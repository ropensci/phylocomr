context("ph_comdist")

sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")

sampledf <- read.table(sfile, header = FALSE,
  stringsAsFactors = FALSE)
phylo_str <- readLines(pfile)

test_that("ph_comdist works with data.frame input", {
  aa <- ph_comdist(sample = sampledf, phylo = phylo_str)

  expect_is(aa, "data.frame")
  expect_named(aa, c('name', 'clump1', 'clump2a', 'clump2b', 'clump4', 'even',
                     'random'))

  expect_is(aa$name, "character")
  expect_type(aa$clump1, "double")
  expect_type(aa$even, "double")
})

test_that("ph_comdist works with file input", {
  sample_str <- paste0(readLines(sfile), collapse = "\n")
  sfile2 <- tempfile()
  cat(sample_str, file = sfile2, sep = '\n')
  pfile2 <- tempfile()
  cat(phylo_str, file = pfile2, sep = '\n')

  aa <- ph_comdist(sample = sfile2, phylo = pfile2)

  expect_is(aa, "data.frame")
  expect_named(aa, c('name', 'clump1', 'clump2a', 'clump2b', 'clump4', 'even',
                     'random'))

  expect_is(aa$name, "character")
  expect_type(aa$clump1, "double")
  expect_type(aa$even, "double")
})


test_that("ph_comdist - different models give expected output", {
  n0 <- ph_comdist(sample = sfile, phylo = pfile, null_model = 0)
  n1 <- ph_comdist(sample = sfile, phylo = pfile, null_model = 1)

  # identical
  expect_identical(n0$mpd, n1$mpd)
  expect_identical(n0$mntd, n1$mntd)

  # not identical
  # expect_false(identical(n0$NRI, n1$NRI))
  # expect_false(identical(n0$NTI, n1$NTI))
})
