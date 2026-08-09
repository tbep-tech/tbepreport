test_that("plot_score returns a sunburst with root, 4 categories, and every indicator", {

  wqoverall <- anlz_category(wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8))
  sedoverall <- anlz_category(sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6))
  fwoverall <- anlz_category(tbni = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7))
  haboverall <- anlz_category(
    seagrass_transect = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5),
    seagrass_coverage = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.3)
  )

  result <- plot_score(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB', yr = 2020)

  expect_s3_class(result, 'plotly')

  built <- plotly::plotly_build(result)
  trace <- built$x$data[[1]]

  # 1 root + 4 categories + 5 indicators (1 + 1 + 1 + 2)
  expect_equal(length(trace$ids), 10)
  expect_setequal(trace$parents[trace$ids == 'overall'], '')
  expect_setequal(trace$parents[trace$ids %in% c('wq', 'sed', 'fw', 'hab')], 'overall')
  # hab's two indicators split its wedge evenly
  expect_equal(trace$values[trace$ids == 'hab_seagrass_transect'], 0.5)
  expect_equal(trace$values[trace$ids == 'hab_seagrass_coverage'], 0.5)
  # every category gets an equal-size wedge regardless of indicator count
  expect_equal(trace$values[trace$ids %in% c('wq', 'sed', 'fw', 'hab')], rep(1, 4))

})

test_that("plot_score grays out indicators missing for the chosen bay_segment/yr", {

  wqoverall <- anlz_category(wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8))
  sedoverall <- anlz_category(sed_tbbi = data.frame(bay_segment = 'HB', yr = 2020, outcome = 0.6))
  fwoverall <- anlz_category(tbni = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7))
  haboverall <- anlz_category(seagrass = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5))

  result <- plot_score(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB', yr = 2020)
  built <- plotly::plotly_build(result)
  trace <- built$x$data[[1]]

  # sed has no OTB row at all - its own wedge and its indicator's both gray
  expect_equal(trace$marker$colors[trace$ids == 'sed'], '#c3c2b7')
  expect_equal(trace$marker$colors[trace$ids == 'sed_sed_tbbi'], '#c3c2b7')

})

test_that("plot_score errors when bay_segment/yr don't match exactly one row", {

  wqoverall <- anlz_category(wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8))
  sedoverall <- anlz_category(sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6))
  fwoverall <- anlz_category(tbni = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7))
  haboverall <- anlz_category(seagrass = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5))

  expect_error(
    plot_score(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'BCB', yr = 2020)
  )

})
