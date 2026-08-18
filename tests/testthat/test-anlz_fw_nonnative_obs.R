test_that("anlz_fw_nonnative_obs clips to AOI and assigns a bay segment", {

  # a point-on-surface of the Old Tampa Bay segment (guaranteed inside both
  # the AOI and a single bay segment), plus one point outside the AOI
  # entirely to confirm it gets dropped
  mock_nas <- data.frame(
    scientificName = c('Species alpha', 'Species outside'),
    commonName     = c('Alpha', 'Outside'),
    group          = c('Fishes', 'Fishes'),
    year           = c(2010, 2010),
    lon            = c(-82.60809, 0),
    lat            = c(28.01452, 0),
    source         = c('NAS', 'NAS'),
    stringsAsFactors = FALSE
  )
  mock_fim <- data.frame(
    scientificName = 'Species beta',
    commonName     = 'Beta',
    group          = 'Reptiles',
    year           = 2015,
    lon            = -82.60809,
    lat            = 28.01452,
    source         = 'FIM',
    stringsAsFactors = FALSE
  )
  mockery::stub(anlz_fw_nonnative_obs, 'util_fw_fetch_nas', mock_nas)
  mockery::stub(anlz_fw_nonnative_obs, 'util_fw_fetch_fim', mock_fim)

  result <- anlz_fw_nonnative_obs()

  expect_named(result, c('scientificName', 'commonName', 'group', 'year', 'lon', 'lat', 'source', 'bay_segment'))
  expect_false(anyNA(result$bay_segment))
  expect_true(all(result$bay_segment %in% c(
    'Old Tampa Bay', 'Hillsborough Bay', 'Middle Tampa Bay', 'Lower Tampa Bay', 'Remainder Lower Tampa Bay'
  )))
  expect_true(all(result$year >= 2000))

  # the out-of-AOI point is dropped, the two in-AOI points remain
  expect_equal(nrow(result), 2)
  expect_setequal(result$bay_segment, 'Old Tampa Bay')

})

test_that("anlz_fw_nonnative_obs filters out years before min_yr", {

  mock_nas <- data.frame(
    scientificName = c('Species alpha', 'Species old'),
    commonName     = c('Alpha', 'Old'),
    group          = c('Fishes', 'Fishes'),
    year           = c(2010, 1990),
    lon            = c(-82.60809, -82.60809),
    lat            = c(28.01452, 28.01452),
    source         = c('NAS', 'NAS'),
    stringsAsFactors = FALSE
  )
  mock_fim <- data.frame(
    scientificName = character(0), commonName = character(0), group = character(0),
    year = integer(0), lon = numeric(0), lat = numeric(0), source = character(0)
  )
  mockery::stub(anlz_fw_nonnative_obs, 'util_fw_fetch_nas', mock_nas)
  mockery::stub(anlz_fw_nonnative_obs, 'util_fw_fetch_fim', mock_fim)

  result <- anlz_fw_nonnative_obs(min_yr = 2000)

  expect_equal(nrow(result), 1)
  expect_equal(result$year, 2010)

})
