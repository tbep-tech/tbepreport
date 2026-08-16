test_that("anlz_sed_tbbi returns expected structure, range, and only the 7 real bay segments", {

  result <- anlz_sed_tbbi(tbeptools::benthicdata)

  expect_named(result, c('yr', 'bay_segment', 'TBBI', 'outcome'))
  expect_true(all(result$outcome >= 0 & result$outcome <= 1, na.rm = TRUE))
  expect_true(is.character(result$bay_segment))
  expect_true(all(result$TBBI >= 0 & result$TBBI <= 100, na.rm = TRUE))

  expect_setequal(unique(result$bay_segment), c('OTB', 'HB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'))

})

test_that("anlz_sed_tbbi outcome is a continuous rescale of the median station TBBI over 73-87", {

  result <- anlz_sed_tbbi(tbeptools::benthicdata)

  expected <- util_outcome(result$TBBI, type = 'continuous', from = c(73, 87))
  expect_equal(result$outcome, expected)

  # scores at or below 73 give outcome 0, at or above 87 give outcome 1
  expect_true(all(result$outcome[result$TBBI <= 73] == 0))
  expect_true(all(result$outcome[result$TBBI >= 87] == 1))

})
