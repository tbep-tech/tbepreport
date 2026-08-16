test_that("anlz_sed_peltel returns expected structure and range", {

  result <- anlz_sed_peltel(tbeptools::sedimentdata, yrs = 2020)

  expect_named(result, c('yr', 'bay_segment', 'ave', 'grd', 'outcome'))
  expect_true(all(result$outcome >= 0 & result$outcome <= 1, na.rm = TRUE))
  expect_true(all(result$yr == 2020))
  expect_true(is.character(result$bay_segment))

})

test_that("anlz_sed_peltel loops over multiple years", {

  result <- anlz_sed_peltel(tbeptools::sedimentdata, yrs = 2018:2020)

  expect_setequal(unique(result$yr), c(2018, 2019, 2020))

})

test_that("anlz_sed_peltel outcome is a log-scale continuous rescale of ave, not grd", {

  result <- anlz_sed_peltel(tbeptools::sedimentdata, yrs = 2020)

  brks <- c(0.00756, 0.02052, 0.08567, 0.28026)
  expected <- util_outcome(log(result$ave), type = 'continuous',
                            from = log(c(brks[1], brks[4])), reverse = TRUE)

  expect_equal(result$outcome, expected)
  # not every distinct grd shares the same outcome, unlike the old
  # category-based scoring
  expect_true(length(unique(result$outcome)) > length(unique(na.omit(result$grd))))

})
