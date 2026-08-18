# Convert raw indicator values to a 0-1 outcome score

Convert raw indicator values to a 0-1 outcome score

## Usage

``` r
util_outcome(
  x,
  type = c("continuous", "threshold", "category"),
  from = NULL,
  reverse = FALSE,
  thresh = NULL,
  op = "<",
  smooth = "logistic",
  scl = NULL,
  pct = 0.1,
  levels = NULL
)
```

## Arguments

- x:

  vector of raw values to convert

- type:

  chr string indicating how to interpret `x`: `"continuous"` rescales a
  continuous value, `"threshold"` compares against a cutoff,
  `"category"` maps discrete categories to fixed outcome values

- from:

  numeric vector of length 2, the `c(min, max)` range of `x` to rescale
  from when `type = "continuous"`. Defaults to `range(x, na.rm = TRUE)`.

- reverse:

  logical, if `TRUE` the outcome is flipped (`1 - outcome`) so a higher
  raw value in `x` indicates a worse outcome.

- thresh:

  numeric, the cutoff value to compare `x` against when
  `type = "threshold"`

- op:

  chr string, one of `"<"`, `"<="`, `">"`, `">="`. Defines the condition
  under which `x` attains an outcome of 1 when `type = "threshold"`

- smooth:

  for `type = "threshold"`, one of `"logistic"` (the default), `"ramp"`,
  or `"none"`. See Details. For backward compatibility, logical
  `TRUE`/`FALSE` are also accepted and mapped to `"logistic"`/`"none"`.

- scl:

  numeric, controls the steepness of the `"logistic"`/ `"ramp"`
  transition. Smaller values give a sharper transition. Defaults to
  `pct * abs(thresh)` (or `1` if `thresh = 0`). Set this directly to use
  an absolute steepness instead of one relative to `thresh`.

- pct:

  numeric, the fraction of `abs(thresh)` used to compute the default
  `scl` when `smooth` is `"logistic"` or `"ramp"` and `scl` is not
  supplied directly. Defaults to `0.1` (10% of `thresh`). Ignored if
  `scl` is provided.

- levels:

  named numeric vector mapping each category value in `x` to a fixed
  outcome when `type = "category"`, e.g.
  `c(Poor = 0, Fair = 0.5, Good = 1)`. Values of `x` not found in
  `levels` return `NA`.

## Value

A numeric vector the same length as `x`, with values from 0 to 1 (`1` =
best).

## Details

This is meant as the single point of modification for how a raw
indicator value becomes a 0-1 outcome, since that conversion is expected
to change as individual indicators are refined (e.g. moving a
category-based indicator to use its underlying continuous value instead,
or a hard threshold to a smooth one) without needing to change every
`anlz_*` function that calls it.

**continuous**: `x` is linearly rescaled from `from` to `c(0, 1)` with
[`rescale`](https://scales.r-lib.org/reference/rescale.html), then
clamped to `c(0, 1)`. Values of `x` outside `from` are pinned to `0` or
`1` rather than extrapolated. This lets `from` act as a transition
window narrower than the full range of `x` (e.g. TBNI's 32-46
breakpoints within its 0-100 score).

**threshold**: `x` is compared to `thresh` using `op`, in one of three
ways selected by `smooth`:

- `"logistic"` (the default): a smooth logistic transition centered at
  `thresh`, exactly `0.5` at `thresh` and approaching `0`/`1` on either
  side, in the direction `op` would have used (e.g. `op = "<"` still
  means lower `x` is better).

- `"ramp"`: `1` once `x` reaches the "good" side of `thresh` (as defined
  by `op`). This is not just `0.5` there like `"logistic"`. It decays
  exponentially toward `0` the further `x` is on the "bad" side. Use
  this when meeting or beating a target should already be full credit
  rather than half credit (e.g. an acreage target that's fine to exceed
  by any amount).

- `"none"`: a hard `0`/`1` cutoff, no transition.

Logical `TRUE`/`FALSE` are also accepted for `smooth`, for backward
compatibility, and map to `"logistic"`/`"none"`.

For `"logistic"` and `"ramp"`, the steepness of the transition (`scl`)
defaults to a percentage (`pct`) of `thresh` rather than a fixed
absolute value, so it stays meaningful across indicators/thresholds with
very different units and magnitudes (e.g. a threshold of 1 vs. a
threshold in the hundreds).

**category**: `x` is mapped to an outcome via `levels`.

In all cases, `reverse = TRUE` flips the result so a higher raw value in
`x` corresponds to a lower (worse) outcome.

## Examples

``` r
# continuous, e.g. TBNI scores from 0-100
util_outcome(c(20, 46, 90), type = 'continuous', from = c(0, 100))
#> [1] 0.20 0.46 0.90

# continuous with a narrower transition window, e.g. TBNI's 32-46
# breakpoints. Values outside the window are clamped to 0/1
util_outcome(c(20, 32, 39, 46, 60), type = 'continuous', from = c(32, 46))
#> [1] 0.0 0.0 0.5 1.0 1.0

# threshold, e.g. chlorophyll attainment (lower is better). Smooth by
# default, a logistic transition rather than a hard cutoff
util_outcome(c(5, 10, 15), type = 'threshold', thresh = 10)
#> [1] 0.993307149 0.500000000 0.006692851

# a larger pct widens the transition (steepness relative to thresh)
util_outcome(12, type = 'threshold', thresh = 10, pct = 0.1)
#> [1] 0.1192029
util_outcome(12, type = 'threshold', thresh = 10, pct = 0.2)
#> [1] 0.2689414

# smooth = "none" (or FALSE) instead gives a hard 0/1 cutoff
util_outcome(c(5, 15), type = 'threshold', thresh = 10, op = '<', smooth = 'none')
#> [1] 1 0

# smooth = "ramp": meeting/beating a target (op = ">=") is full credit,
# decaying toward 0 the further short of it a value falls
util_outcome(c(90, 95, 100, 105), type = 'threshold', thresh = 100, op = '>=', smooth = 'ramp')
#> [1] 0.3678794 0.6065307 1.0000000 1.0000000

# category, e.g. FIB grades
util_outcome(c('A', 'C', 'E'), type = 'category',
  levels = c(A = 1, B = 0.75, C = 0.5, D = 0.25, E = 0))
#> [1] 1.0 0.5 0.0
```
