# Seagrass transect frequency of occurrence outcome by bay segment and year

Seagrass transect frequency of occurrence outcome by bay segment and
year

## Usage

``` r
anlz_hab_seagrass_transect(transect)
```

## Arguments

- transect:

  data.frame of raw seagrass transect data, e.g.
  [`tbeptools::transect`](https://rdrr.io/pkg/tbeptools/man/transect.html)

## Value

A data.frame with columns `bay_segment`, `yr`, `foest` (frequency of
occurrence estimate, 0-100), and `outcome` (0-1, 1 = best)

## Details

Uses
[`anlz_transectocc`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectocc.html)
and
[`anlz_transectave`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectave.html)
to estimate frequency of seagrass occurrence (`foest`, 0-100) at each
bay segment/year, drops the bay-wide `"All"` aggregate row, then
converts to a 0-1 outcome with
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
(`type = "continuous"`, `from = c(0, 100)`).

## Examples

``` r
anlz_hab_seagrass_transect(tbeptools::transect)
#> # A tibble: 140 × 4
#> # Groups:   bay_segment [5]
#>    bay_segment    yr foest outcome
#>    <chr>       <dbl> <dbl>   <dbl>
#>  1 OTB          1998  65.5   0.655
#>  2 HB           1998  15.0   0.150
#>  3 MTB          1998  53.7   0.537
#>  4 LTB          1998  80.8   0.808
#>  5 BCB          1998  81.0   0.810
#>  6 OTB          1999  64.7   0.647
#>  7 HB           1999  10.1   0.101
#>  8 MTB          1999  51.8   0.518
#>  9 LTB          1999  67.5   0.675
#> 10 BCB          1999  71.0   0.710
#> # ℹ 130 more rows
```
