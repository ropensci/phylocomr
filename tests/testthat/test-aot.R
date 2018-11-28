context("ph_aot")

traits_file <- system.file("examples/traits_aot", package = "phylocomr")
phylo_file <- system.file("examples/phylo_aot", package = "phylocomr")

traitsdf_file <- system.file("examples/traits_aot_df",
  package = "phylocomr")
traits <- read.table(text = readLines(traitsdf_file), header = TRUE,
  stringsAsFactors = FALSE)
phylo_str <- readLines(phylo_file)

test_that("ph_aot works with data.frame input", {
  skip_on_appveyor()
  skip_on_cran()

  aa <- ph_aot(traits, phylo = phylo_str)

  expect_is(aa, "list")
  expect_named(aa, c("trait_conservatism", "independent_contrasts",
                     "phylogenetic_signal", "ind_contrast_corr" ))


  expect_is(aa$trait_conservatism, "data.frame")
  expect_is(aa$independent_contrasts, "data.frame")
  expect_is(aa$phylogenetic_signal, "data.frame")
  expect_is(aa$ind_contrast_corr, "data.frame")

  expect_type(aa$trait_conservatism$ntaxa, "integer")
  expect_type(aa$trait_conservatism$age, "double")

  expect_type(aa$independent_contrasts$name, "character")
  expect_type(aa$independent_contrasts$contrastsd, "double")
})

test_that("ph_aot works with file input", {
  skip_on_appveyor()
  skip_on_cran()
  
  traits_str <- paste0(readLines(traits_file), collapse = "\n")
  traits_file2 <- tempfile()
  cat(traits_str, file = traits_file2, sep = '\n')
  phylo_file2 <- tempfile()
  cat(phylo_str, file = phylo_file2, sep = '\n')

  aa <- ph_aot(traits_file2, phylo_file2)

  expect_is(aa, "list")
  expect_named(aa, c("trait_conservatism", "independent_contrasts",
                     "phylogenetic_signal", "ind_contrast_corr" ))


  expect_is(aa$trait_conservatism, "data.frame")
  expect_is(aa$independent_contrasts, "data.frame")
  expect_is(aa$phylogenetic_signal, "data.frame")
  expect_is(aa$ind_contrast_corr, "data.frame")

  expect_type(aa$trait_conservatism$ntaxa, "integer")
  expect_type(aa$trait_conservatism$age, "double")

  expect_type(aa$independent_contrasts$name, "character")
  expect_type(aa$independent_contrasts$contrastsd, "double")
})

test_that("ph_aot fails well", {
  # required inputs
  expect_error(ph_aot(), "argument \"traits\" is missing, with no default")
  expect_error(ph_aot("Adsf"), "argument \"phylo\" is missing, with no default")

  # types are correct
  expect_error(ph_aot(5, "asdfad"),
               "traits must be of class data.frame, character")
  expect_error(ph_aot("adf", mtcars),
               "phylo must be of class phylo, character")
  expect_error(ph_aot("adf", "adsf", randomizations = "asdff"),
               "randomizations must be of class integer, numeric")
  expect_error(ph_aot("adf", "adsf", trait_contrasts = "asdff"),
               "trait_contrasts must be of class integer, numeric")
  expect_error(ph_aot("adf", "adsf", ebl_unstconst = "asdff"),
               "ebl_unstconst must be of class logical")
})
