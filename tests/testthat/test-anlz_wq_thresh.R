test_that("anlz_wq_thresh returns expected structure and only scored vars", {

  result <- anlz_wq_thresh(tbeptools::epcdata)

  expect_named(result, c('yr', 'bay_segment', 'indicator', 'outcome'))
  expect_setequal(unique(result$indicator), c('chla_thresh', 'la_thresh'))
  expect_true(all(result$outcome >= 0 & result$outcome <= 1, na.rm = TRUE))

})

test_that("anlz_wq_thresh smooth defaults to TRUE, giving a logistic transition", {

  result <- anlz_wq_thresh(tbeptools::epcdata)

  expect_true(any(result$outcome > 0 & result$outcome < 1))

})

test_that("anlz_wq_thresh smooth = 'none' gives a hard 0/1 cutoff", {

  result <- anlz_wq_thresh(tbeptools::epcdata, smooth = 'none')

  expect_setequal(unique(result$outcome), c(0, 1))

})
