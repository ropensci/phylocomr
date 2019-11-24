context("ph_comtrait")

sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
tfile <- system.file("examples/traits_aot", package = "phylocomr")

sample_str <- paste0(readLines(sfile), collapse = "\n")
sfile2 <- tempfile()
cat(sample_str, file = sfile2, sep = '\n')

traits_str <- paste0(readLines(tfile), collapse = "\n")
tfile2 <- tempfile()
cat(traits_str, file = tfile2, sep = '\n')

sampledf <- read.table(sfile, header = FALSE,
   stringsAsFactors = FALSE)
traitsdf_file <- system.file("examples/traits_aot_df",
   package = "phylocomr")
traitsdf <- read.table(text = readLines(traitsdf_file), header = TRUE,
   stringsAsFactors = FALSE)

test_that("ph_comtrait works with data.frame input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_comtrait(sample = sampledf, traits = traitsdf,
    binary = c(FALSE, FALSE, FALSE, TRUE))

  expect_is(aa, "data.frame")
  expect_named(aa, c('trait', 'sample', 'ntaxa', 'mean', 'metric',
                     'meanrndmetric', 'sdrndmetric', 'sesmetric',
                     'ranklow', 'rankhigh', 'runs'))

  expect_is(aa$trait, "character")
  expect_type(aa$ntaxa, "integer")
  expect_type(aa$sdrndmetric, "double")

  expect_equal(unique(aa$runs), 999)
})

test_that("ph_comtrait works with file input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_comtrait(sample = sfile2, traits = tfile2)

  expect_is(aa, "data.frame")
  expect_named(aa, c('trait', 'sample', 'ntaxa', 'mean', 'metric',
                     'meanrndmetric', 'sdrndmetric', 'sesmetric',
                     'ranklow', 'rankhigh', 'runs'))

  expect_is(aa$trait, "character")
  expect_type(aa$ntaxa, "integer")
  expect_type(aa$sdrndmetric, "double")

  expect_equal(unique(aa$runs), 999)
})


test_that("ph_comtrait - different models give expected output", {
  skip_on_appveyor()
  skip_on_cran()

  n0 <- ph_comtrait(sample = sfile2, traits = tfile2, null_model = 0)
  n1 <- ph_comtrait(sample = sfile2, traits = tfile2, null_model = 1)

  # identical
  expect_identical(n0$metric, n1$metric)

  # not identical
  expect_false(identical(n0$sesmetric, n1$sesmetric))
})

test_that("ph_comtrait fails well", {
  # required inputs
  expect_error(ph_comtrait(),
               "argument \"sample\" is missing, with no default")
  expect_error(ph_comtrait("Adsf"),
               "argument \"traits\" is missing, with no default")

  # types are correct
  expect_error(ph_comtrait(5, "asdfad"),
               "sample must be of class character, data.frame")
  expect_error(ph_comtrait("adf", 5),
               "traits must be of class character, data.frame")
  expect_error(ph_comtrait(sfile, tfile, null_model = mtcars),
               "null_model must be of class numeric, integer")
  expect_error(ph_comtrait(sfile, tfile, randomizations = mtcars),
               "randomizations must be of class numeric, integer")

  expect_error(ph_comtrait(sfile, tfile, metric = 5),
               "metric must be of class character")

  expect_error(ph_comtrait(sfile, tfile, binary = 5),
               "binary must be of class logical")
  expect_error(ph_comtrait(sfile, tfile, abundance = 5),
               "abundance must be of class logical")

  # correct set of values
  expect_error(ph_comtrait(sfile, tfile, null_model = 15),
               "null_model %in% 0:3 is not TRUE")

  # first column name must be `name`
  tt <- traitsdf
  colnames(tt)[1] <- "penguin"
  expect_error(ph_comtrait(sample = sampledf, traits = tt,
    binary = c(FALSE, FALSE, FALSE, TRUE)),
    "first column name in `traits` must be `name`")
})

test_that("ph_comtrait corrects mismatched cases in sample/traits df's", {
  skip_on_appveyor()
  skip_on_cran()
  
  # mismatch in `sample` case is fixed internally
  sampledf_err <- sampledf
  sampledf_err$V3 <- toupper(sampledf$V3)
  expect_is(ph_comtrait(sample = sampledf_err, traits = traitsdf,
    binary = c(FALSE, FALSE, FALSE, TRUE)), "data.frame")
 
  # mismatch in `traits` file is fixed internally
  traitsdf_err <- traitsdf
  traitsdf_err$name <- toupper(traitsdf_err$name)
  smp <- trait_check(traitsdf_err, binary = c(FALSE, FALSE, FALSE, TRUE))
  expect_is(ph_comtrait(sampledf, smp, binary = c(FALSE, FALSE, FALSE, TRUE)),
    "data.frame")
})
