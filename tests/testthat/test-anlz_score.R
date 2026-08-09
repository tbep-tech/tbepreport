test_that("anlz_score combines the four category scores like anlz_category", {

  wqoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8)
  sedoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6)
  fwoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7)
  haboverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)

  result <- anlz_score(wqoverall, sedoverall, fwoverall, haboverall)
  expected <- anlz_category(wq = wqoverall, sed = sedoverall, fw = fwoverall, hab = haboverall)

  expect_equal(result, expected)
  expect_equal(result$outcome, mean(c(0.8, 0.6, 0.7, 0.5)))
  expect_equal(result$n_indicator, 4)

})

test_that("anlz_score weights categories when wt is supplied", {

  wqoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 1)
  sedoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0)
  fwoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0)
  haboverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0)

  result <- anlz_score(wqoverall, sedoverall, fwoverall, haboverall, wt = c(wq = 3))

  expect_equal(result$outcome, stats::weighted.mean(c(1, 0, 0, 0), w = c(3, 1, 1, 1)))

})

test_that("anlz_score adds a wide column per category", {

  wqoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8)
  sedoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6)
  fwoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7)
  haboverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)

  result <- anlz_score(wqoverall, sedoverall, fwoverall, haboverall)

  expect_setequal(names(result), c('bay_segment', 'yr', 'outcome', 'n_indicator', 'wq', 'sed', 'fw', 'hab'))
  expect_equal(result$wq, 0.8)
  expect_equal(result$sed, 0.6)
  expect_equal(result$fw, 0.7)
  expect_equal(result$hab, 0.5)

})
