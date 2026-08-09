test_that("anlz_indicators stacks named inputs without NA-filling", {

  wq_attain <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)
  thresh <- data.frame(bay_segment = 'OTB', yr = 2020, indicator = c('chla_thresh', 'la_thresh'), outcome = c(1, 0))
  load <- data.frame(bay_segment = 'OTB', yr = 2020, indicator = c('tn_load', 'tnhy_load'), outcome = c(1, 0))
  # OTB has no tidal creek data this year - should just be absent, not NA-filled
  tidal_creeks <- data.frame(bay_segment = 'HB', yr = 2020, outcome = 0.7, n_assessed = 5)
  fib <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.25)

  result <- anlz_indicators(
    wq_attain = wq_attain, thresh = thresh, load = load, tidal_creeks = tidal_creeks, fib = fib
  )

  expect_named(result, c('bay_segment', 'yr', 'indicator', 'outcome'))
  expect_setequal(
    result$indicator,
    c('wq_attain', 'chla_thresh', 'la_thresh', 'tn_load', 'tnhy_load', 'tidal_creeks', 'fib')
  )
  # OTB has no tidal_creeks row, HB has no other indicator rows - confirms
  # bind_rows (not a join) behavior
  expect_equal(nrow(result[result$bay_segment == 'HB', ]), 1)
  expect_equal(nrow(result[result$bay_segment == 'OTB', ]), 6)

})

test_that("anlz_indicators drops NA outcomes", {

  wq_attain <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = NA_real_)
  fib <- data.frame(bay_segment = character(0), yr = integer(0), outcome = numeric(0))

  result <- anlz_indicators(wq_attain = wq_attain, fib = fib)

  expect_equal(nrow(result), 0)

})

test_that("anlz_indicators filters to bay_segments", {

  dat <- data.frame(bay_segment = c('OTB', 'BCB'), yr = c(2020, 2020), outcome = c(0.5, 0.9))

  result <- anlz_indicators(dat = dat)
  expect_setequal(result$bay_segment, 'OTB')

  result2 <- anlz_indicators(dat = dat, bay_segments = c('OTB', 'BCB'))
  expect_setequal(result2$bay_segment, c('OTB', 'BCB'))

})
