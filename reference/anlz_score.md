# Overall bay segment score across all four indicator categories

Overall bay segment score across all four indicator categories

## Usage

``` r
anlz_score(wqoverall, sedoverall, fwoverall, haboverall, wt = NULL)
```

## Arguments

- wqoverall:

  output of
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  for water quality

- sedoverall:

  output of
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  for sediment

- fwoverall:

  output of
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  for fish/wildlife

- haboverall:

  output of
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  for habitat

- wt:

  named numeric vector of category weights, e.g.
  `c(wq = 2, sed = 1, fw = 1, hab = 1)`. Categories not named in `wt` -
  including all of them when `wt = NULL` - get a weight of `1`, so the
  default is a plain unweighted mean across the four categories, passed
  straight through to
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md).

## Value

A data.frame with columns `bay_segment`, `yr`, `outcome` (0-1, 1 =
best - the overall Bay Segment Score), `n_indicator` (number of
categories with a score for that segment/year), and one additional
column per category (`wq`, `sed`, `fw`, `hab`) holding that category's
own score, `NA` where a segment/year has no score for it

## Details

A thin, semantically-named wrapper around
[`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md):
from that function's point of view, a category score is just another
single-indicator input, so combining the four category scores into one
bay segment score uses exactly the same stacking
([`anlz_indicators`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md))
and weighted-averaging logic that combines individual indicators into a
category score.

## Examples

``` r
wqoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8)
sedoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6)
fwoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7)
haboverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)
anlz_score(wqoverall, sedoverall, fwoverall, haboverall)
#> # A tibble: 1 × 8
#>   bay_segment    yr outcome n_indicator    wq   sed    fw   hab
#>   <chr>       <int>   <dbl>       <int> <dbl> <dbl> <dbl> <dbl>
#> 1 OTB          2020    0.65           4   0.8   0.6   0.7   0.5
```
