context("ecovolve")

test_that("ecovolve executable works", {
  expect_output(ecovolve(), "Cam Webb")
  expect_output(ecovolve(), "ecovolve")
  expect_output(ecovolve(), "simulation after this number of extant lineages")
  expect_is(ecovolve(stdout = FALSE), "character")
  expect_match(ecovolve(stdout = FALSE), "Cam Webb")
})

context("ph_ecovolve")

test_that("ph_phylomatic works with chr string input", {
  # ph_ecovolve(speciation = 0.05)
  # ph_ecovolve(speciation = 0.1)
  expect_is(ph_ecovolve(extinction = 0.005), "character")
  # expect_is(ph_ecovolve(time_units = 50), "character")
  expect_is(ph_ecovolve(out_mode = 2), "character")
  expect_is(ph_ecovolve(extant_lineages = TRUE), "character")
  expect_is(ph_ecovolve(extant_lineages = FALSE), "character")
  expect_is(ph_ecovolve(only_extant = FALSE), "character")
  expect_is(ph_ecovolve(only_extant = TRUE), "character")
  expect_is(ph_ecovolve(taper_change = 2), "character")
  expect_is(ph_ecovolve(taper_change = 10), "character")
  expect_is(ph_ecovolve(taper_change = 500), "character")
  expect_is(ph_ecovolve(competition = TRUE), "character")
  expect_is(ph_ecovolve(competition = FALSE), "character")
})
