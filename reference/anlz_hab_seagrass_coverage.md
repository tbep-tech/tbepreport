# Seagrass coverage outcome by bay segment and year

Seagrass coverage outcome by bay segment and year

## Usage

``` r
anlz_hab_seagrass_coverage(
  sgsegest,
  yr_max = max(sgsegest$year),
  smooth = TRUE,
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

  logical, passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md) -
  if `TRUE` (the default), use a smooth logistic transition centered at
  each segment's acreage target instead of a hard 0/1 cutoff.

- pct:

  numeric, passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
  as the fraction of each acreage target used for the logistic
  transition's steepness when `smooth = TRUE`. Defaults to `0.1` (10% of
  the target).

## Value

A data.frame with columns `bay_segment` (abbreviated, e.g. `"OTB"`),
`yr`, `acres` (carried forward in non-survey years), and `outcome` (0-1,
1 = best, also carried forward in non-survey years; exactly 0 or 1 only
if `smooth = FALSE`)

## Details

Seagrass coverage maps are not produced every year - they're flown
approximately biennially
([`sgsegest`](https://tbep-tech.github.io/tbepreport/reference/sgsegest.md)
has estimates for most even years from 1988 to 2024, plus 1999, not
every calendar year in between). To get a value for every calendar year,
this fills the gaps by carrying the most recent actual estimate (and the
outcome derived from it) **forward** via
[`complete`](https://tidyr.tidyverse.org/reference/complete.html) +
[`fill`](https://tidyr.tidyverse.org/reference/fill.html) - e.g. a year
with no survey repeats the prior survey year's acreage and outcome
unchanged, until the next actual survey year updates it. This means
`acres`/`outcome` in a non-survey year are not a new estimate, just a
repeat of the last known one.

Coverage is compared against a fixed per-segment acreage target with
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
(`type = "threshold"`, `op = ">="`)

- by default (`smooth = TRUE`) this is a smooth logistic transition
  centered at the target; `smooth = FALSE` instead gives a hard 0/1
  cutoff (meeting or exceeding the target gives an outcome of 1).
  Targets (acres):

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

  These are not independently set per segment - they're the baywide
  40,000-acre seagrass coverage target apportioned across segments in
  proportion to each segment's share of total bay area.

## Examples

``` r
anlz_hab_seagrass_coverage(sgsegest)
#> # A tibble: 259 × 4
#>    bay_segment    yr acres outcome
#>    <chr>       <dbl> <dbl>   <dbl>
#>  1 BCB          1988 6259.  0.0528
#>  2 BCB          1989 6259.  0.0528
#>  3 BCB          1990 6805.  0.0939
#>  4 BCB          1991 6805.  0.0939
#>  5 BCB          1992 6952.  0.109 
#>  6 BCB          1993 6952.  0.109 
#>  7 BCB          1994 7129.  0.130 
#>  8 BCB          1995 7129.  0.130 
#>  9 BCB          1996 7716.  0.226 
#> 10 BCB          1997 7716.  0.226 
#> # ℹ 249 more rows
```
