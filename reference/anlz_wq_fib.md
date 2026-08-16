# Fecal indicator bacteria (FIB) outcome by bay segment and year

Fecal indicator bacteria (FIB) outcome by bay segment and year

## Usage

``` r
anlz_wq_fib(enterodata)
```

## Arguments

- enterodata:

  data.frame of raw enterococcus monitoring data, e.g.
  [`tbeptools::enterodata`](https://rdrr.io/pkg/tbeptools/man/enterodata.html)

## Value

A data.frame with columns `bay_segment`, `yr`, and `outcome` (0-1, 1 =
best)

## Details

Uses
[`anlz_fibmatrix`](https://rdrr.io/pkg/tbeptools/man/anlz_fibmatrix.html)
to get, for each bay segment/year, `exceed_rate` - a continuous,
one-sided 90\\ confidence estimate of the true exceedance rate (0-1,
lower is better) - and converts it to a 0-1 outcome with
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
(`type = "continuous"`, `from = c(0, 1)`, `reverse = TRUE`), i.e.
`outcome = 1 - exceed_rate`. This is a continuous analog of the A-E
letter grade
[`anlz_fibmatrix()`](https://rdrr.io/pkg/tbeptools/man/anlz_fibmatrix.html)
also returns (`cat`), which is itself a discretized version of
`exceed_rate` - see
[`anlz_fibmatrix`](https://rdrr.io/pkg/tbeptools/man/anlz_fibmatrix.html)
for details.

## Examples

``` r
anlz_wq_fib(tbeptools::enterodata)
#> # A tibble: 107 × 3
#>    bay_segment    yr outcome
#>    <chr>       <dbl>   <dbl>
#>  1 LTB          2002   0.999
#>  2 OTB          2003   0.408
#>  3 HB           2003   0.328
#>  4 MTB          2003   0.896
#>  5 LTB          2003   0.999
#>  6 OTB          2004   0.313
#>  7 HB           2004   0.349
#>  8 MTB          2004   0.802
#>  9 LTB          2004   0.998
#> 10 OTB          2005   0.285
#> # ℹ 97 more rows
```
