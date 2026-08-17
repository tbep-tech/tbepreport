test_that("util_outcome continuous rescales from explicit range", {

  result <- util_outcome(c(0, 50, 100), type = 'continuous', from = c(0, 100))

  expect_equal(result, c(0, 0.5, 1))

})

test_that("util_outcome continuous defaults from to range(x)", {

  result <- util_outcome(c(0, 25, 50), type = 'continuous')

  expect_equal(result, c(0, 0.5, 1))

})

test_that("util_outcome continuous respects reverse", {

  result <- util_outcome(c(0, 50, 100), type = 'continuous', from = c(0, 100), reverse = TRUE)

  expect_equal(result, c(1, 0.5, 0))

})

test_that("util_outcome continuous clamps values outside from to 0/1", {

  result <- util_outcome(c(20, 32, 39, 46, 60), type = 'continuous', from = c(32, 46))

  expect_equal(result, c(0, 0, 0.5, 1, 1))

})

test_that("util_outcome threshold hard cutoff respects op when smooth = FALSE", {

  expect_equal(util_outcome(c(5, 15), type = 'threshold', thresh = 10, op = '<', smooth = FALSE), c(1, 0))
  expect_equal(util_outcome(c(5, 15), type = 'threshold', thresh = 10, op = '>', smooth = FALSE), c(0, 1))
  expect_equal(util_outcome(c(10, 15), type = 'threshold', thresh = 10, op = '<=', smooth = FALSE), c(1, 0))

})

test_that("util_outcome threshold defaults to smooth = TRUE", {

  result <- util_outcome(c(5, 10, 15), type = 'threshold', thresh = 10)
  expected <- util_outcome(c(5, 10, 15), type = 'threshold', thresh = 10, smooth = TRUE)

  expect_equal(result, expected)
  expect_true(any(result > 0 & result < 1))

})

test_that("util_outcome threshold requires thresh", {

  expect_error(util_outcome(c(5, 15), type = 'threshold'), 'thresh must be provided')

})

test_that("util_outcome threshold smooth is near 0.5 at the threshold and respects op direction", {

  at_thresh <- util_outcome(10, type = 'threshold', thresh = 10, smooth = TRUE)
  expect_equal(at_thresh, 0.5)

  lower_op_lt <- util_outcome(0, type = 'threshold', thresh = 10, smooth = TRUE, op = '<')
  higher_op_lt <- util_outcome(20, type = 'threshold', thresh = 10, smooth = TRUE, op = '<')
  expect_gt(lower_op_lt, 0.9)
  expect_lt(higher_op_lt, 0.1)

  lower_op_gt <- util_outcome(0, type = 'threshold', thresh = 10, smooth = TRUE, op = '>')
  higher_op_gt <- util_outcome(20, type = 'threshold', thresh = 10, smooth = TRUE, op = '>')
  expect_lt(lower_op_gt, 0.1)
  expect_gt(higher_op_gt, 0.9)

})

test_that("util_outcome threshold pct controls steepness relative to thresh", {

  # pct = 0.2 on thresh = 10 gives scl = 2, so x = 12 is exactly 1 scl above
  # thresh -> outcome = 1 / (1 + exp(1))
  result <- util_outcome(12, type = 'threshold', thresh = 10, smooth = TRUE, pct = 0.2)
  expect_equal(result, 1 / (1 + exp(1)))

  # a smaller pct sharpens the transition, so the same x sits further out
  # along the curve and is closer to the hard-cutoff outcome of 0
  tight <- util_outcome(12, type = 'threshold', thresh = 10, smooth = TRUE, pct = 0.05)
  wide  <- util_outcome(12, type = 'threshold', thresh = 10, smooth = TRUE, pct = 0.2)
  expect_lt(tight, wide)

})

test_that("util_outcome threshold scl overrides pct", {

  result <- util_outcome(12, type = 'threshold', thresh = 10, smooth = TRUE, scl = 2, pct = 0.5)
  expect_equal(result, 1 / (1 + exp(1)))

})

test_that("util_outcome threshold ramp is 1 at/beyond thresh on the good side and decays on the bad side", {

  # op = '>=' (higher is better, e.g. a target to meet or exceed): at or
  # above thresh is exactly 1, no partial credit like logistic's 0.5
  at_thresh <- util_outcome(10, type = 'threshold', thresh = 10, op = '>=', smooth = 'ramp')
  above     <- util_outcome(15, type = 'threshold', thresh = 10, op = '>=', smooth = 'ramp')
  expect_equal(at_thresh, 1)
  expect_equal(above, 1)

  # below thresh, scl = pct * thresh = 1, so x = 9 is exactly 1 scl below
  # thresh -> outcome = exp(-1)
  below <- util_outcome(9, type = 'threshold', thresh = 10, op = '>=', smooth = 'ramp')
  expect_equal(below, exp(-1))

  # further below decays further toward (but never reaches) 0
  further <- util_outcome(5, type = 'threshold', thresh = 10, op = '>=', smooth = 'ramp')
  expect_lt(further, below)
  expect_gt(further, 0)

})

test_that("util_outcome threshold ramp respects op direction (lower is better)", {

  at_thresh <- util_outcome(10, type = 'threshold', thresh = 10, op = '<', smooth = 'ramp')
  below     <- util_outcome(5, type = 'threshold', thresh = 10, op = '<', smooth = 'ramp')
  above     <- util_outcome(15, type = 'threshold', thresh = 10, op = '<', smooth = 'ramp')

  expect_equal(at_thresh, 1)
  expect_equal(below, 1)
  expect_lt(above, 1)
  expect_gt(above, 0)

})

test_that("util_outcome threshold smooth accepts logical for backward compatibility", {

  expect_equal(
    util_outcome(12, type = 'threshold', thresh = 10, smooth = TRUE),
    util_outcome(12, type = 'threshold', thresh = 10, smooth = 'logistic')
  )
  expect_equal(
    util_outcome(c(5, 15), type = 'threshold', thresh = 10, smooth = FALSE),
    util_outcome(c(5, 15), type = 'threshold', thresh = 10, smooth = 'none')
  )

})

test_that("util_outcome threshold smooth errors on an invalid option", {

  expect_error(util_outcome(12, type = 'threshold', thresh = 10, smooth = 'bogus'))

})

test_that("util_outcome category maps values via levels", {

  result <- util_outcome(
    c('A', 'C', 'E'), type = 'category',
    levels = c(A = 1, B = 0.75, C = 0.5, D = 0.25, E = 0)
  )

  expect_equal(result, c(1, 0.5, 0))

})

test_that("util_outcome category returns NA for unmapped values", {

  result <- util_outcome(c('A', 'Z'), type = 'category', levels = c(A = 1))

  expect_equal(result, c(1, NA))

})

test_that("util_outcome category requires levels", {

  expect_error(util_outcome(c('A'), type = 'category'), 'levels must be provided')

})
