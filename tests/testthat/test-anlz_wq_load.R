test_that("anlz_wq_load scores tn_load/tnhy_load against fixed segment targets", {

  totanndat <- data.frame(
    year = c(2020, 2020, 2020, 2020),
    bay_segment = c('Old Tampa Bay', 'Hillsborough Bay', 'Middle Tampa Bay', 'Lower Tampa Bay'),
    # OTB/MTB/LTB below their tn/tnhy thresholds (outcome 1), HB above (outcome 0)
    tn_load = c(400, 1500, 700, 300),
    tnhy = c(1.0, 1.7, 1.2, 0.9)
  )

  result <- anlz_wq_load(totanndat, smooth = 'none')

  expect_named(result, c('bay_segment', 'yr', 'indicator', 'outcome'))
  expect_setequal(unique(result$indicator), c('tn_load', 'tnhy_load'))
  expect_equal(nrow(result), 8)

  tn <- result[result$indicator == 'tn_load', ]
  expect_equal(tn$outcome[tn$bay_segment == 'OTB'], 1)
  expect_equal(tn$outcome[tn$bay_segment == 'HB'], 0)
  expect_equal(tn$outcome[tn$bay_segment == 'MTB'], 1)
  expect_equal(tn$outcome[tn$bay_segment == 'LTB'], 1)

  # "tnhy_load" indicator is scored from tnhy (TN load normalized by
  # hydrologic load), not a raw hydrologic load column
  hy <- result[result$indicator == 'tnhy_load', ]
  expect_equal(hy$outcome[hy$bay_segment == 'OTB'], 1)
  expect_equal(hy$outcome[hy$bay_segment == 'HB'], 0)
  expect_equal(hy$outcome[hy$bay_segment == 'MTB'], 1)
  expect_equal(hy$outcome[hy$bay_segment == 'LTB'], 1)

})

test_that("anlz_wq_load smooth defaults to TRUE, giving a logistic transition", {

  totanndat <- data.frame(
    year = c(2020, 2020, 2020, 2020),
    bay_segment = c('Old Tampa Bay', 'Hillsborough Bay', 'Middle Tampa Bay', 'Lower Tampa Bay'),
    tn_load = c(480, 1460, 700, 300),
    tnhy = c(1.07, 1.63, 1.2, 0.9)
  )

  result <- anlz_wq_load(totanndat)

  expect_true(any(result$outcome > 0 & result$outcome < 1))

})

test_that("anlz_wq_load drops bay segments outside the fixed 4", {

  totanndat <- data.frame(
    year = 2020,
    bay_segment = c('Old Tampa Bay', 'Boca Ciega Bay'),
    tn_load = c(400, 100),
    tnhy = c(1.0, 0.5)
  )

  result <- anlz_wq_load(totanndat)

  expect_setequal(unique(result$bay_segment), 'OTB')

})
