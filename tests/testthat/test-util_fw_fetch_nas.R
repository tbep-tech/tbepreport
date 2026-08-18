test_that("util_fw_fetch_nas returns expected structure and only kept groups", {

  mock_json <- list(
    results = data.frame(
      scientificName   = c('Species alpha', 'Species beta', 'Species gamma'),
      commonName       = c('Alpha', 'Beta', 'Gamma'),
      group            = c('Fishes', 'Amphibians-Frogs', 'Birds'),
      year             = c(2010, 2015, 2020),
      decimalLongitude = c(-82.5, -82.6, -82.7),
      decimalLatitude  = c(27.7, 27.8, 27.9),
      stringsAsFactors = FALSE
    )
  )
  mockery::stub(util_fw_fetch_nas, 'jsonlite::fromJSON', mock_json)

  result <- util_fw_fetch_nas(huc8_list = '03100206')

  expect_named(result, c('scientificName', 'commonName', 'group', 'year', 'lon', 'lat', 'source'))
  expect_true(all(result$source == 'NAS'))
  expect_true(all(result$group %in% c('Amphibians', 'Crustaceans', 'Fishes', 'Mammals', 'Mollusks', 'Plants', 'Reptiles')))
  expect_false(any(grepl('-', result$group)))

  # 'Birds' is not a kept group and 'Amphibians-Frogs' collapses to 'Amphibians'
  expect_equal(nrow(result), 2)
  expect_setequal(result$group, c('Fishes', 'Amphibians'))

})

test_that("util_fw_fetch_nas queries once per huc8 code and combines results", {

  mock_json <- list(
    results = data.frame(
      scientificName   = 'Species alpha',
      commonName       = 'Alpha',
      group            = 'Fishes',
      year             = 2010,
      decimalLongitude = -82.5,
      decimalLatitude  = 27.7,
      stringsAsFactors = FALSE
    )
  )
  mockery::stub(util_fw_fetch_nas, 'jsonlite::fromJSON', mock_json)

  result <- util_fw_fetch_nas(huc8_list = c('03100206', '03100207'))

  expect_equal(nrow(result), 2)

})
