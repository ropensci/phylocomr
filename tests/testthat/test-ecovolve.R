context("ecovolve")

test_that("ecovolve executable works", {
  expect_output(ecovolve(), "Cam Webb")
  expect_output(ecovolve(), "ecovolve")
  expect_output(ecovolve(), "simulation after this number of extant lineages")
  expect_is(ecovolve(stdout = FALSE), "character")
  expect_match(ecovolve(stdout = FALSE), "Cam Webb")
})

context("ph_ecovolve")

test_that("ph_ecovolve works when out_mode = 3", {
  # ph_ecovolve(speciation = 0.05)
  # ph_ecovolve(speciation = 0.1)
  aa <- ph_ecovolve(extinction = 0.005)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  # expect_is(ph_ecovolve(time_units = 50), "character")

  aa <- ph_ecovolve(extant_lineages = TRUE)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  aa <- ph_ecovolve(extant_lineages = FALSE)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  aa <- ph_ecovolve(only_extant = FALSE)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  aa <- ph_ecovolve(only_extant = TRUE)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  aa <- ph_ecovolve(taper_change = 2)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  aa <- ph_ecovolve(taper_change = 10)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  aa <- ph_ecovolve(taper_change = 500)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  aa <- ph_ecovolve(competition = TRUE)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  aa <- ph_ecovolve(competition = FALSE)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "character")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")
})


test_that("ph_ecovolve when out_mode = 2", {
  aa <- ph_ecovolve(out_mode = 2)
  expect_is(aa, "list")
  expect_is(aa$phylogeny, "data.frame")
  expect_is(aa$sample, "data.frame")
  expect_is(aa$traits, "data.frame")

  expect_equal(NROW(aa$sample), 0)
  expect_equal(NROW(aa$traits), 0)
})
