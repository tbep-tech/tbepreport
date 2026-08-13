test_that("plot_trend returns a ggplot with 5 facets in the expected order", {

  wqoverall <- anlz_category(
    wq_attain = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.6, 0.7, 0.8))
  )
  sedoverall <- anlz_category(
    sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.5, 0.6, 0.6))
  )
  fwoverall <- anlz_category(
    tbni = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.7, 0.65, 0.7))
  )
  haboverall <- anlz_category(
    seagrass_transect = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.4, 0.5, 0.5)),
    seagrass_coverage = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.3, 0.4, 0.4))
  )

  result <- plot_trend(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB')

  expect_s3_class(result, 'ggplot')

  built <- ggplot2::ggplot_build(result)
  facet_levels <- levels(built$plot$data$facet)

  expect_equal(
    facet_levels,
    c('Overall', 'Water Quality', 'Sediment', 'Fish and Wildlife', 'Habitat')
  )

})

test_that("plot_trend draws one parent 'Score' line and one child line per component", {

  wqoverall <- anlz_category(
    wq_attain = data.frame(bay_segment = 'OTB', yr = 2018:2019, outcome = c(0.6, 0.7)),
    fib       = data.frame(bay_segment = 'OTB', yr = 2018:2019, outcome = c(0.5, 0.5))
  )
  sedoverall <- anlz_category(
    sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2018:2019, outcome = c(0.5, 0.6))
  )
  fwoverall <- anlz_category(
    tbni = data.frame(bay_segment = 'OTB', yr = 2018:2019, outcome = c(0.7, 0.65))
  )
  haboverall <- anlz_category(
    seagrass = data.frame(bay_segment = 'OTB', yr = 2018:2019, outcome = c(0.4, 0.5))
  )

  result <- plot_trend(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB')
  dat <- result$data

  # Water Quality facet has 2 indicators (wq_attain, fib) plus its own Score line
  wq_series <- unique(dat$series[dat$facet == 'Water Quality'])
  expect_setequal(wq_series, c('Score', 'Targets', 'Fecal'))

  # Overall facet has the 4 category lines plus its own Score line
  overall_series <- unique(dat$series[dat$facet == 'Overall'])
  expect_setequal(overall_series, c('Score', 'Water Quality', 'Sediment', 'Fish and Wildlife', 'Habitat'))

  expect_setequal(dat$role, c('parent', 'child'))

})

test_that("plot_trend errors when bay_segment has no rows", {

  wqoverall <- anlz_category(wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8))
  sedoverall <- anlz_category(sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6))
  fwoverall <- anlz_category(tbni = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7))
  haboverall <- anlz_category(seagrass = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5))

  expect_error(
    plot_trend(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'BCB')
  )

})

test_that("plot_trend yr_range restricts the plotted years", {

  wqoverall <- anlz_category(
    wq_attain = data.frame(bay_segment = 'OTB', yr = 2016:2020, outcome = c(0.5, 0.6, 0.7, 0.8, 0.9))
  )
  sedoverall <- anlz_category(
    sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2016:2020, outcome = c(0.5, 0.5, 0.6, 0.6, 0.6))
  )
  fwoverall <- anlz_category(
    tbni = data.frame(bay_segment = 'OTB', yr = 2016:2020, outcome = c(0.7, 0.7, 0.65, 0.65, 0.7))
  )
  haboverall <- anlz_category(
    seagrass = data.frame(bay_segment = 'OTB', yr = 2016:2020, outcome = c(0.4, 0.4, 0.5, 0.5, 0.5))
  )

  result <- plot_trend(
    wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB', yr_range = c(2018, 2020)
  )

  expect_equal(range(result$data$yr), c(2018, 2020))

})

test_that("plot_trend errors when yr_range excludes all rows", {

  wqoverall <- anlz_category(wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8))
  sedoverall <- anlz_category(sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6))
  fwoverall <- anlz_category(tbni = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7))
  haboverall <- anlz_category(seagrass = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5))

  expect_error(
    plot_trend(
      wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB', yr_range = c(2000, 2001)
    )
  )

})
