test_that("anlz_hab_seagrass_coverage carries the last survey forward through gap years", {

  # synthetic sgsegest-like fixture: OTB surveyed 2018 (below target) and
  # 2020 (above target), with 2019 missing (biennial gap)
  sgsegest <- data.frame(
    segment = factor(c('Old Tampa Bay', 'Old Tampa Bay'), levels = 'Old Tampa Bay'),
    acres = c(10000, 12000),
    year = c(2018, 2020)
  )

  result <- anlz_hab_seagrass_coverage(sgsegest, smooth = 'none')

  expect_named(result, c('bay_segment', 'yr', 'acres', 'outcome'))
  expect_equal(result$yr, 2018:2020)

  # 2019 (no survey) repeats 2018's acres/outcome exactly
  expect_equal(result$acres[result$yr == 2019], result$acres[result$yr == 2018])
  expect_equal(result$outcome[result$yr == 2019], result$outcome[result$yr == 2018])

  # 2018: 10000 acres < 11100 target -> outcome 0; 2020: 12000 >= 11100 -> outcome 1
  expect_equal(result$outcome[result$yr == 2018], 0)
  expect_equal(result$outcome[result$yr == 2020], 1)

})

test_that("anlz_hab_seagrass_coverage smooth defaults to 'ramp'", {

  # OTB target is 11100; 11000 sits within a 10% (1110-acre) transition band,
  # short of the target, so ramp gives a value strictly between 0 and 1
  sgsegest <- data.frame(
    segment = factor('Old Tampa Bay', levels = 'Old Tampa Bay'),
    acres = 11000,
    year = 2020
  )

  result <- anlz_hab_seagrass_coverage(sgsegest)

  expect_true(all(result$outcome > 0 & result$outcome < 1))
  expect_equal(unname(result$outcome), exp(-100 / 1110))

})

test_that("anlz_hab_seagrass_coverage ramp gives exactly 1 at or above the target", {

  sgsegest <- data.frame(
    segment = factor(c('Old Tampa Bay', 'Old Tampa Bay'), levels = 'Old Tampa Bay'),
    acres = c(11100, 15000),
    year = c(2020, 2022)
  )

  result <- anlz_hab_seagrass_coverage(sgsegest)

  expect_true(all(result$outcome == 1))

})

test_that("anlz_hab_seagrass_coverage smooth = 'logistic' gives 0.5 exactly at the target", {

  sgsegest <- data.frame(
    segment = factor('Old Tampa Bay', levels = 'Old Tampa Bay'),
    acres = 11100,
    year = 2020
  )

  result <- anlz_hab_seagrass_coverage(sgsegest, smooth = 'logistic')

  expect_equal(unname(result$outcome), 0.5)

})

test_that("anlz_hab_seagrass_coverage respects a custom yr_max", {

  sgsegest <- data.frame(
    segment = factor('Old Tampa Bay', levels = 'Old Tampa Bay'),
    acres = 12000,
    year = 2020
  )

  result <- anlz_hab_seagrass_coverage(sgsegest, yr_max = 2022, smooth = 'none')

  expect_equal(result$yr, 2020:2022)
  expect_true(all(result$acres == 12000))
  expect_true(all(result$outcome == 1))

})

test_that("anlz_hab_seagrass_coverage matches targets by segment name, not position", {

  # deliberately out-of-alphabetical-order factor levels - would silently
  # mismatch under a positional (not named) target lookup
  sgsegest <- data.frame(
    segment = factor(c('Manatee River', 'Old Tampa Bay'), levels = c('Manatee River', 'Old Tampa Bay')),
    acres = c(500, 500),
    year = c(2020, 2020)
  )

  result <- anlz_hab_seagrass_coverage(sgsegest, smooth = 'none')

  # Manatee River (MR) target is 449 (500 >= 449 -> 1), Old Tampa Bay (OTB)
  # target is 11100 (500 < 11100 -> 0)
  expect_equal(result$outcome[result$bay_segment == 'MR'], 1)
  expect_equal(result$outcome[result$bay_segment == 'OTB'], 0)

})
