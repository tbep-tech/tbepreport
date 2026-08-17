test_that("anlz_wq_tidalcreeks returns expected structure and range", {

  # suppressWarnings: sf's benign "attribute variables assumed constant"
  # notice from st_intersection(), not related to correctness here
  result <- suppressWarnings(anlz_wq_tidalcreeks(tbeptools::tidalcreeks, tbeptools::iwrraw, yrs = 2020))

  expect_named(result, c('bay_segment', 'yr', 'outcome', 'n_assessed'))
  expect_true(all(result$outcome >= 0 & result$outcome <= 1, na.rm = TRUE))
  expect_true(all(result$yr == 2020))

})

test_that("anlz_wq_tidalcreeks outcome is continuous, not just the 4 category levels", {

  result <- suppressWarnings(anlz_wq_tidalcreeks(tbeptools::tidalcreeks, tbeptools::iwrraw, yrs = 2015:2024))

  crklevs <- c(0, 1 / 3, 2 / 3, 1)
  expect_true(sum(!round(result$outcome, 6) %in% round(crklevs, 6)) > 0)

})
