test_that("anlz_fw_tbni returns expected structure and range", {

  result <- anlz_fw_tbni(tbeptools::fimdata)

  expect_named(result, c('bay_segment', 'yr', 'Segment_TBNI', 'Action', 'outcome'))
  expect_true(all(result$outcome >= 0 & result$outcome <= 1, na.rm = TRUE))
  expect_true(is.character(result$bay_segment))
  expect_equal(result$outcome, pmin(pmax((result$Segment_TBNI - 32) / 14, 0), 1))

})

test_that("anlz_fw_tbni from argument reverts to a plain linear rescale", {

  result <- anlz_fw_tbni(tbeptools::fimdata, from = c(0, 100))

  expect_equal(result$outcome, result$Segment_TBNI / 100)

})
