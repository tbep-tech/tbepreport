test_that("anlz_wq_fib returns expected structure and range", {

  result <- anlz_wq_fib(tbeptools::enterodata)

  expect_named(result, c('bay_segment', 'yr', 'outcome'))
  expect_true(all(result$outcome >= 0 & result$outcome <= 1, na.rm = TRUE))
  expect_true(is.character(result$bay_segment))

})

test_that("anlz_wq_fib outcome is 1 - exceed_rate", {

  result <- anlz_wq_fib(tbeptools::enterodata)

  fibmat <- tbeptools::anlz_fibmatrix(
    tbeptools::enterodata, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB', 'MR')
  )

  expect_equal(result$outcome, 1 - fibmat$exceed_rate)

})
