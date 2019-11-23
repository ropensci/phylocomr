context("ph_rao")

sfile <- system.file("examples/sample_comstruct", package = "phylocomr")
pfile <- system.file("examples/phylo_comstruct", package = "phylocomr")

sampledf <- read.table(sfile, header = FALSE,
  stringsAsFactors = FALSE)
phylo_str <- readLines(pfile)

test_that("ph_rao works with data.frame input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_rao(sample = sampledf, phylo = phylo_str)

  expect_is(aa, "list")
  expect_true("diversity_components" %in% names(aa))
  expect_true("within_community_diveristy" %in% names(aa))
  for (i in seq_along(aa)) expect_is(aa[[i]], "data.frame")
  expect_type(aa$within_community_diveristy$plot, "character")
  expect_type(aa$within_community_diveristy$nspp, "integer")
})

test_that("ph_rao works with file input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_rao(sample = sfile, phylo = pfile)

  expect_is(aa, "list")
  expect_true("diversity_components" %in% names(aa))
  expect_true("within_community_diveristy" %in% names(aa))
  for (i in seq_along(aa)) expect_is(aa[[i]], "data.frame")
  expect_type(aa$within_community_diveristy$plot, "character")
  expect_type(aa$within_community_diveristy$nspp, "integer")
})

test_that("ph_rao fails well", {
  # required inputs
  expect_error(ph_rao(),
               "argument \"sample\" is missing, with no default")
  expect_error(ph_rao("Adsf"),
               "argument \"phylo\" is missing, with no default")

  # types are correct
  expect_error(ph_rao(5, "asdfad"),
               "sample must be of class data.frame, character")
  expect_error(ph_rao("adf", mtcars),
               "phylo must be of class phylo, character")
})

test_that("ph_rao corrects mismatched cases in data.frame's/phylo objects", {
  skip_on_appveyor()
  skip_on_cran()
  
  # mismatch in `sample` case is fixed internally
  sampledf_err <- sampledf
  sampledf_err$V3 <- toupper(sampledf_err$V3)
  expect_is(ph_rao(sampledf_err, phylo_str), "list")

  # mismatch in `phylo` case is fixed internally
  phylo_str_err <- phylo_str
  phylo_str_err <- toupper(phylo_str_err)
  expect_is(ph_rao(sampledf, phylo_str_err), "list")
  
  # mismatch in `sample` file is fixed internally
  sampledf_err <- sampledf
  sampledf_err$V3 <- toupper(sampledf_err$V3)
  smp <- sample_check_nolower(sampledf_err)
  expect_is(ph_rao(smp, phylo_str), "list")

  # mismatch in `sample` file is fixed internally
  phylo_str_err <- phylo_str
  phylo_str_err <- toupper(phylo_str_err)
  phylo_str_err_file <- tempfile("phylo_")
  cat(phylo_str_err, file = phylo_str_err_file, sep = "\n")
  expect_is(ph_rao(sampledf, phylo_str_err_file), "list")
})
