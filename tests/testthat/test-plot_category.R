test_that("plot_category returns a sunburst with a root and one wedge per indicator", {

  wq_attain <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8)
  fib <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.4)
  tidal_creeks <- data.frame(bay_segment = 'HB', yr = 2020, outcome = 0.9)

  result <- plot_category(
    wq_attain = wq_attain, fib = fib, tidal_creeks = tidal_creeks,
    bay_segment = 'OTB', yr = 2020
  )

  expect_s3_class(result, 'plotly')

  built <- plotly::plotly_build(result)
  trace <- built$x$data[[1]]

  # 1 root ("score") + 3 indicators
  expect_equal(length(trace$ids), 4)
  expect_setequal(trace$parents[trace$ids == 'score'], '')
  expect_setequal(trace$parents[trace$ids %in% c('wq_attain', 'fib', 'tidal_creeks')], 'score')
  expect_equal(trace$values[trace$ids %in% c('wq_attain', 'fib', 'tidal_creeks')], c(1, 1, 1))
  # tidal_creeks has no OTB row - gray, but still an equal-size wedge
  expect_equal(trace$marker$colors[trace$ids == 'tidal_creeks'], '#c3c2b7')

})

test_that("plot_category errors when bay_segment/yr don't match exactly one row", {

  wq_attain <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8)

  expect_error(plot_category(wq_attain = wq_attain, bay_segment = 'BCB', yr = 2020))

})
