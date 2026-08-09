test_that("anlz_category averages across indicators present, filters segment/year", {

  wq_attain <- data.frame(
    bay_segment = c('OTB', 'HB', 'LTB', 'BCB', 'OTB'),
    yr          = c(2020, 2020, 1999, 2020, 2020),
    outcome     = c(1, 0.2, 0.9, 0.9, 1)
  )
  fib <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)

  result <- anlz_category(wq_attain = wq_attain, fib = fib)

  # LTB dropped (yr < 2000), BCB dropped (not in default bay_segments),
  # OTB has a duplicate wq_attain row deliberately - both average in
  expect_setequal(result$bay_segment, c('OTB', 'HB'))
  otb <- result[result$bay_segment == 'OTB', ]
  expect_equal(otb$outcome, mean(c(1, 0.5, 1)))
  expect_equal(otb$n_indicator, 3)

})

test_that("anlz_category respects custom bay_segments and yr_min", {

  wq_attain <- data.frame(bay_segment = c('BCB', 'OTB'), yr = c(1995, 1995), outcome = c(0.4, 0.6))

  result <- anlz_category(wq_attain = wq_attain, bay_segments = 'BCB', yr_min = 1990)

  expect_equal(nrow(result), 1)
  expect_equal(result$bay_segment, 'BCB')
  expect_equal(result$outcome, 0.4)

})

test_that("anlz_category is unweighted by default and weights indicators when wt is supplied", {

  a <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 1)
  b <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0)

  unweighted <- anlz_category(a = a, b = b)
  expect_equal(unweighted$outcome, 0.5)

  weighted <- anlz_category(a = a, b = b, wt = c(a = 3, b = 1))
  expect_equal(weighted$outcome, stats::weighted.mean(c(1, 0), w = c(3, 1)))

})

test_that("anlz_category adds a wide column per indicator, NA where missing", {

  wq_attain <- data.frame(
    bay_segment = c('OTB', 'HB', 'OTB'),
    yr          = c(2020, 2020, 2020),
    outcome     = c(1, 0.2, 1)
  )
  fib <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)

  result <- anlz_category(wq_attain = wq_attain, fib = fib)

  expect_setequal(names(result), c('bay_segment', 'yr', 'outcome', 'n_indicator', 'wq_attain', 'fib'))

  otb <- result[result$bay_segment == 'OTB', ]
  hb  <- result[result$bay_segment == 'HB', ]

  # duplicate OTB wq_attain rows average into the wide column too
  expect_equal(otb$wq_attain, mean(c(1, 1)))
  expect_equal(otb$fib, 0.5)
  # HB has no fib data - NA, not dropped
  expect_true(is.na(hb$fib))
  expect_equal(hb$wq_attain, 0.2)

})
