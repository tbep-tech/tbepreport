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
  smooth = FALSE,
  scl = NULL,
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
  raw value in `x` indicates a worse outcome. Applies to
  `type = "continuous"` and `type = "threshold"`.

- thresh:

  numeric, the cutoff value to compare `x` against when
  `type = "threshold"`

- op:

  chr string, one of `"<"`, `"<="`, `">"`, `">="` - the comparison
  defining the condition under which `x` attains an outcome of 1 when
  `type = "threshold"`

- smooth:

  logical, if `TRUE` and `type = "threshold"`, use a smooth logistic
  transition centered at `thresh` (in the direction given by `op`)
  instead of a hard cutoff (see Details)

- scl:

  numeric, controls the steepness of the logistic transition when
  `smooth = TRUE` - smaller values are a sharper transition. Defaults to
  10% of `abs(thresh)` (or `1` if `thresh = 0`).

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
clamped to `c(0, 1)` - values of `x` outside `from` are pinned to `0` or
`1` rather than extrapolated. This lets `from` act as a transition
window narrower than the full range of `x` (e.g. TBNI's 32-46
breakpoints within its 0-100 score).

**threshold**: by default, `x` is compared to `thresh` using `op` and
converted to a hard `0`/`1`. Setting `smooth = TRUE` instead applies a
logistic function centered at `thresh`, so outcomes near the threshold
transition gradually rather than jumping discretely, in the same
direction `op` would have used (e.g. `op = "<"` still means lower `x` is
better).

**category**: `x` is mapped to an outcome via `levels`.

In all cases, `reverse = TRUE` flips the result so a higher raw value in
`x` corresponds to a lower (worse) outcome.

## Examples

``` r
# continuous, e.g. TBNI scores from 0-100
util_outcome(c(20, 46, 90), type = 'continuous', from = c(0, 100))
#> [1] 0.20 0.46 0.90

# continuous with a narrower transition window, e.g. TBNI's 32-46
# breakpoints - values outside the window are clamped to 0/1
util_outcome(c(20, 32, 39, 46, 60), type = 'continuous', from = c(32, 46))
#> [1] 0.0 0.0 0.5 1.0 1.0

# threshold, e.g. chlorophyll attainment (lower is better)
util_outcome(c(5, 15), type = 'threshold', thresh = 10, op = '<')
#> [1] 1 0

# threshold with a smooth transition instead of a hard cutoff
util_outcome(c(5, 10, 15), type = 'threshold', thresh = 10, smooth = TRUE)
#> [1] 0.993307149 0.500000000 0.006692851

# category, e.g. FIB grades
util_outcome(c('A', 'C', 'E'), type = 'category',
  levels = c(A = 1, B = 0.75, C = 0.5, D = 0.25, E = 0))
#> [1] 1.0 0.5 0.0
```
