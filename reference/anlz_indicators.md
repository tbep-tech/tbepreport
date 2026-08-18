# Stack indicator outcomes into one long-format table

Stack indicator outcomes into one long-format table

## Usage

``` r
anlz_indicators(..., bay_segments = c("OTB", "HB", "MTB", "LTB"))
```

## Arguments

- ...:

  named data.frames, each with `bay_segment`, `yr`, and `outcome`
  columns. A data.frame may already have its own `indicator` column if
  it bundles more than one indicator (e.g.
  [`anlz_wq_load`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_load.md)'s
  output already has `indicator` = `"tn_load"`/`"tnhy_load"`). Otherwise
  every row is labeled with that argument's name.

- bay_segments:

  chr vector of bay segments to keep, defaults to
  `c('OTB', 'HB', 'MTB', 'LTB')`

## Value

A data.frame with columns `bay_segment`, `yr`, `indicator`, and
`outcome` (0-1, 1 = best)

## Details

Stacks
([`bind_rows`](https://dplyr.tidyverse.org/reference/bind_rows.html))
rather than joins the inputs, since bay segment/year coverage differs by
indicator. A segment/ year missing from one indicator's source data
simply has no row for it, rather than an `NA`-filled one. Rows outside
`bay_segments` or with an `NA` outcome are dropped.

This same stacking step is used at every level of the indicator
hierarchy, once per category to build a category's indicator table from
its raw `anlz_*` indicator outputs, and again inside
[`anlz_score`](https://tbep-tech.github.io/tbepreport/reference/anlz_score.md)
(via
[`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md))
to stack the four category scores into one table before the final
average. A category score is just another single-indicator input.

## Examples

``` r
anlz_indicators(
  wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8),
  load = data.frame(bay_segment = 'OTB', yr = 2020,
    indicator = c('tn_load', 'tnhy_load'), outcome = c(1, 0))
)
#>   bay_segment   yr indicator outcome
#> 1         OTB 2020 wq_attain     0.8
#> 2         OTB 2020   tn_load     1.0
#> 3         OTB 2020 tnhy_load     0.0
```
