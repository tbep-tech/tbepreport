test_that("anlz_wq_thresh returns expected structure and only scored vars", {

  result <- anlz_wq_thresh(tbeptools::epcdata)

  expect_named(result, c('yr', 'bay_segment', 'indicator', 'outcome'))
  expect_setequal(unique(result$indicator), c('chla_thresh', 'la_thresh'))
  expect_setequal(unique(result$outcome), c(0, 1))

})
