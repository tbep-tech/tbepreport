# Combine indicators into a single score by bay segment and year

Combine indicators into a single score by bay segment and year

## Usage

``` r
anlz_category(
  ...,
  bay_segments = c("OTB", "HB", "MTB", "LTB"),
  yr_min = 2000,
  wt = NULL
)
```

## Arguments

- ...:

  named data.frames, passed to
  [`anlz_indicators`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md)

- bay_segments:

  chr vector of bay segments to include, defaults to
  `c('OTB', 'HB', 'MTB', 'LTB')`

- yr_min:

  integer, minimum year to include, defaults to `2000`

- wt:

  named numeric vector of weights, keyed by the `indicator` values
  produced by
  [`anlz_indicators`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md)
  (e.g. `c(chla_thresh = 2, fib = 1)` to weight an indicator, or
  `c(wq = 2, sed = 1)` when combining category scores via
  [`anlz_score`](https://tbep-tech.github.io/tbepreport/reference/anlz_score.md)).
  Indicators not named in `wt` (including all of them when `wt = NULL`)
  get a weight of `1`, so the default is a plain unweighted mean.

## Value

A data.frame with columns `bay_segment`, `yr`, `outcome` (0-1, 1 =
best), `n_indicator` (number of indicators averaged for that
segment/year), and one additional column per indicator (named from `...`
or
[`anlz_indicators`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md)'s
`indicator` column) holding that indicator's own outcome, `NA` where a
segment/year has no data for it

## Details

Stacks `...` with
[`anlz_indicators`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md),
then averages `outcome` across whatever indicators have data for a given
bay segment/year. See `n_indicator` in the output for how many
contributed. This same averaging step produces a category score when
`...` are raw indicator outputs, and the final bay segment score when
`...` are the four category scores (see
[`anlz_score`](https://tbep-tech.github.io/tbepreport/reference/anlz_score.md)).

## Examples

``` r
anlz_category(
  wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8),
  fib = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.4)
)
#> # A tibble: 1 × 6
#>   bay_segment    yr outcome n_indicator wq_attain   fib
#>   <chr>       <int>   <dbl>       <int>     <dbl> <dbl>
#> 1 OTB          2020     0.6           2       0.8   0.4
```
