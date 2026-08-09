# Nutrient loading outcome by bay segment, year, and indicator

Nutrient loading outcome by bay segment, year, and indicator

## Usage

``` r
anlz_wq_load(totanndat)
```

## Arguments

- totanndat:

  data.frame of total annual loading estimates, with columns `year`,
  `bay_segment` (full segment names, e.g. `"Old Tampa Bay"`), `tn_load`,
  and `tnhy` - e.g. as returned by
  [`util_rdataload()`](https://tbep-tech.github.io/tbepreport/reference/util_rdataload.md)
  on the [load-estimates](https://github.com/tbep-tech/load-estimates)
  data

## Value

A data.frame with columns `bay_segment` (abbreviated, e.g. `"OTB"`),
`yr`, `indicator` (`"tn_load"` or `"tnhy_load"` - see Details for what
`"tnhy_load"` measures), and `outcome` (0 or 1, 1 = best)

## Details

Compares two loading measures against fixed bay-segment targets, using
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
with `type = "threshold"` - a value below its target gives an outcome of
1, at or above gives 0:

- `tn_load`: total nitrogen load

- `tnhy_load`: `tnhy`, the total nitrogen load normalized by hydrologic
  load (i.e. TN load per unit of hydrologic load, a
  hydrologically-normalized loading rate) - **not** the raw hydrologic
  (freshwater inflow) load itself. The raw `hy_load` column in
  `totanndat` is not used here.

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
