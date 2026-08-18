# Seagrass coverage outcome by bay segment and year

Seagrass coverage outcome by bay segment and year

## Usage

``` r
anlz_hab_seagrass_coverage(
  sgsegest,
  yr_max = max(sgsegest$year),
  smooth = "ramp",
  pct = 0.1
)
```

## Arguments

- sgsegest:

  data.frame of seagrass coverage estimates by bay segment and year,
  e.g.
  [`sgsegest`](https://tbep-tech.github.io/tbepreport/reference/sgsegest.md)

- yr_max:

  integer, the last year to carry estimates forward to, defaults to the
  last year `sgsegest` actually has an estimate for
  (`max(sgsegest$year)`)

- smooth:

  passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md).
  One of `"ramp"` (the default), `"logistic"`, or `"none"` (logical
  `TRUE`/`FALSE` also accepted, mapped to `"logistic"`/`"none"`).
  `"ramp"` gives an outcome of 1 for any acreage at or above a segment's
  target, decaying toward 0 the further short of it a segment falls.

- pct:

  numeric, passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
  as the fraction of each acreage target used for the transition's
  steepness when `smooth` is `"ramp"` or `"logistic"`. Defaults to `0.1`
  (10% of the target).

## Value

A data.frame with columns `bay_segment` (abbreviated, e.g. `"OTB"`),
`yr`, `acres` (carried forward in non-survey years), and `outcome` (0-1,
1 = best, also carried forward in non-survey years)

## Details

Seagrass coverage maps are not produced every year. They're flown
approximately biennially
([`sgsegest`](https://tbep-tech.github.io/tbepreport/reference/sgsegest.md)
has estimates for most even years). To get a value for every calendar
year, this fills the gaps by carrying the most recent actual estimate
(and the outcome derived from it) **forward** via
[`complete`](https://tidyr.tidyverse.org/reference/complete.html) +
[`fill`](https://tidyr.tidyverse.org/reference/fill.html). For example,
a year with no survey repeats the prior survey year's acreage and
outcome unchanged, until the next actual survey year updates it. This
means `acres`/`outcome` in a non-survey year are not a new estimate,
just a repeat of the last known one.

Coverage is compared against a fixed per-segment acreage target with
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
(`type = "threshold"`, `op = ">="`). By default (`smooth = "ramp"`),
meeting or exceeding the target gives an outcome of 1, decaying toward 0
the further short of it a segment falls. Targets (acres):

- Old Tampa Bay:

  11,100

- Hillsborough Bay:

  1,751

- Middle Tampa Bay:

  9,400

- Lower Tampa Bay:

  7,400

- Boca Ciega Bay:

  8,800

- Terra Ceia Bay:

  1,100

- Manatee River:

  449

These targets are derived from the baywide 40,000-acre seagrass coverage
target apportioned to each segment's share of total bay area.

## Examples

``` r
anlz_hab_seagrass_coverage(sgsegest)
#> # A tibble: 259 × 4
#>    bay_segment    yr acres outcome
#>    <chr>       <dbl> <dbl>   <dbl>
#>  1 BCB          1988 6259.  0.0557
#>  2 BCB          1989 6259.  0.0557
#>  3 BCB          1990 6805.  0.104 
#>  4 BCB          1991 6805.  0.104 
#>  5 BCB          1992 6952.  0.123 
#>  6 BCB          1993 6952.  0.123 
#>  7 BCB          1994 7129.  0.150 
#>  8 BCB          1995 7129.  0.150 
#>  9 BCB          1996 7716.  0.292 
#> 10 BCB          1997 7716.  0.292 
#> # ℹ 249 more rows
```
