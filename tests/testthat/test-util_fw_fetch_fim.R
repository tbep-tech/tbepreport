test_that("util_fw_fetch_fim returns expected structure and groups", {

  mock_download <- function(url, destfile, mode, quiet) {
    inv <- data.frame(
      Scientificname = c('Species alpha', 'Species beta'),
      Commonname     = c('Alpha', 'Beta'),
      Taxa_Type      = c('Fish', 'Turtle'),
      Reference      = c('FIM2015SOMETHING', 'FIM2018OTHER'),
      Longitude      = c(-82.5, -82.6),
      Latitude       = c(27.7, 27.8),
      stringsAsFactors = FALSE
    )
    save(inv, file = destfile)
  }
  mockery::stub(util_fw_fetch_fim, 'utils::download.file', mock_download)

  result <- util_fw_fetch_fim()

  expect_named(result, c('scientificName', 'commonName', 'group', 'year', 'lon', 'lat', 'source'))
  expect_true(all(result$source == 'FIM'))
  expect_setequal(unique(result$group), c('Fishes', 'Reptiles'))
  expect_equal(result$year, c(2015, 2018))

})
