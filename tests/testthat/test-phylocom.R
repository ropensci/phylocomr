context("phylocom")

test_that("phylocom executable works", {
  skip_on_cran()

  expect_output(phylocom(), "Cam Webb")
  expect_output(phylocom(), "Copyright")
  expect_output(phylocom(), "community structure")
  expect_output(phylocom(), "Phylogeny Tools")
  expect_is(phylocom(intern = TRUE), "character")
  expect_match(phylocom(intern = TRUE), "Cam Webb")
})

test_that("phylocom fails well", {
  skip_on_cran()

  expect_output(phylocom(args = 4),
                "Oops! Command not recognized")
  expect_match(phylocom(args = 4, intern = TRUE),
                "Oops! Command not recognized")
})
