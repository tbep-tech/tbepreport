test_that("anlz_hab_seagrass_coverage carries the last survey forward through gap years", {

  # synthetic sgsegest-like fixture: OTB surveyed 2018 (below target) and
  # 2020 (above target), with 2019 missing (biennial gap)
  sgsegest <- data.frame(
    segment = factor(c('Old Tampa Bay', 'Old Tampa Bay'), levels = 'Old Tampa Bay'),
    acres = c(10000, 12000),
    year = c(2018, 2020)
  )

  result <- anlz_hab_seagrass_coverage(sgsegest)

  expect_named(result, c('bay_segment', 'yr', 'acres', 'outcome'))
  expect_equal(result$yr, 2018:2020)

  # 2019 (no survey) repeats 2018's acres/outcome exactly
  expect_equal(result$acres[result$yr == 2019], result$acres[result$yr == 2018])
  expect_equal(result$outcome[result$yr == 2019], result$outcome[result$yr == 2018])

  # 2018: 10000 acres < 11100 target -> outcome 0; 2020: 12000 >= 11100 -> outcome 1
  expect_equal(result$outcome[result$yr == 2018], 0)
  expect_equal(result$outcome[result$yr == 2020], 1)

})

test_that("anlz_hab_seagrass_coverage respects a custom yr_max", {

  sgsegest <- data.frame(
    segment = factor('Old Tampa Bay', levels = 'Old Tampa Bay'),
    acres = 12000,
    year = 2020
  )

  result <- anlz_hab_seagrass_coverage(sgsegest, yr_max = 2022)

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

  result <- anlz_hab_seagrass_coverage(sgsegest)

  # Manatee River (MR) target is 449 (500 >= 449 -> 1), Old Tampa Bay (OTB)
  # target is 11100 (500 < 11100 -> 0)
  expect_equal(result$outcome[result$bay_segment == 'MR'], 1)
  expect_equal(result$outcome[result$bay_segment == 'OTB'], 0)

})
