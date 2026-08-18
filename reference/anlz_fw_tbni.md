# Tampa Bay Nekton Index (TBNI) outcome by bay segment and year

Tampa Bay Nekton Index (TBNI) outcome by bay segment and year

## Usage

``` r
anlz_fw_tbni(fimdata, from = c(32, 46))
```

## Arguments

- fimdata:

  data.frame of raw fisheries independent monitoring data, e.g.
  [`tbeptools::fimdata`](https://rdrr.io/pkg/tbeptools/man/fimdata.html)

- from:

  numeric vector of length 2, the `c(min, max)` range of `Segment_TBNI`
  passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
  as its `from` argument. Defaults to `c(32, 46)`, TBNI's own grade
  breakpoints. Pass `c(0, 100)` to revert to a plain linear rescale over
  the full score range with no clamping.

## Value

A data.frame with columns `bay_segment`, `yr`, `Segment_TBNI` (the raw
0-100 score), `Action` (management action category from
[`anlz_tbniave`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniave.html)),
and `outcome` (0-1, 1 = best)

## Details

Uses
[`anlz_tbniscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniscr.html)
and
[`anlz_tbniave`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniave.html)
to score each bay segment/year 0-100, then converts to a 0-1 outcome
with
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
(`type = "continuous"`). With the default `from = c(32, 46)`, matching
TBNI's own grade breakpoints (On Alert below 32, Caution from 32 to 46,
Stay the Course above 46), scores below 32 give an outcome of 0, scores
above 46 give an outcome of 1, and scores in between are linearly
rescaled.

## Examples

``` r
anlz_fw_tbni(tbeptools::fimdata)
#> # A tibble: 112 × 5
#>    bay_segment    yr Segment_TBNI Action          outcome
#>    <chr>       <dbl>        <dbl> <fct>             <dbl>
#>  1 HB           1998           47 Stay the Course   1    
#>  2 HB           1999           47 Stay the Course   1    
#>  3 HB           2000           44 Caution           0.857
#>  4 HB           2001           44 Caution           0.857
#>  5 HB           2002           39 Caution           0.5  
#>  6 HB           2003           41 Caution           0.643
#>  7 HB           2004           41 Caution           0.643
#>  8 HB           2005           32 Caution           0    
#>  9 HB           2006           41 Caution           0.643
#> 10 HB           2007           42 Caution           0.714
#> # ℹ 102 more rows
```
