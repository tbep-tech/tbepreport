# Nutrient loading outcome by bay segment, year, and indicator

Nutrient loading outcome by bay segment, year, and indicator

## Usage

``` r
anlz_wq_load(totanndat, smooth = TRUE, pct = 0.1)
```

## Arguments

- totanndat:

  data.frame of total annual loading estimates, with columns `year`,
  `bay_segment` (full segment names, e.g. `"Old Tampa Bay"`), `tn_load`,
  and `tnhy`, e.g. as returned by
  [`util_rdataload()`](https://tbep-tech.github.io/tbepreport/reference/util_rdataload.md)
  on the [load-estimates](https://github.com/tbep-tech/load-estimates)
  data

- smooth:

  logical, passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md).
  If `TRUE` (the default), use a smooth logistic transition centered at
  each threshold instead of a hard 0/1 cutoff.

- pct:

  numeric, passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
  as the fraction of each threshold used for the logistic transition's
  steepness when `smooth = TRUE`. Defaults to `0.1` (10% of the
  threshold).

## Value

A data.frame with columns `bay_segment` (abbreviated, e.g. `"OTB"`),
`yr`, `indicator` (`"tn_load"` or `"tnhy_load"`, see Details for what
`"tnhy_load"` measures), and `outcome` (0-1, 1 = best)

## Details

Compares two loading measures against fixed bay-segment thresholds,
using
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
with `type = "threshold"`. By default (`smooth = TRUE`), a value below
its threshold approaches an outcome of 1 and at or above approaches 0,
with a smooth logistic transition between them.

- `tn_load`: total nitrogen load

- `tnhy_load`: `tnhy`, the total nitrogen load normalized by hydrologic
  load (i.e. TN load per unit of hydrologic load, a
  hydrologically-normalized loading rate). This is not the raw
  hydrologic (freshwater inflow) load itself. The raw `hy_load` column
  in `totanndat` is not used here.

Returned in long format with one row per indicator, ready to stack into
[`anlz_indicators`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md).

## Examples

``` r
if (FALSE) { # \dontrun{
totanndat <- util_rdataload(
  "https://github.com/tbep-tech/load-estimates/raw/main/data/totanndat.RData"
)
anlz_wq_load(totanndat)
} # }
```
