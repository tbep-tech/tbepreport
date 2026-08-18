# Water quality attainment outcome by bay segment and year

Water quality attainment outcome by bay segment and year

## Usage

``` r
anlz_wq_attain(epcdata)
```

## Arguments

- epcdata:

  data.frame of raw water quality data, e.g.
  [`tbeptools::epcdata`](https://rdrr.io/pkg/tbeptools/man/epcdata.html)

## Value

A data.frame with columns `bay_segment`, `yr`, `totsum` (the summed
chlorophyll/light attenuation sub-score), and `outcome` (0-1, 1 = best)

## Details

Combines chlorophyll and light attenuation attainment of management
targets (from
[`anlz_attain`](https://tbep-tech.github.io/tbeptools/reference/anlz_attain.html))
into a single continuous outcome. The two sub-scores are summed (each
0-3 assessing magnitude and duration of exceedance), then converted with
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
(`type = "continuous"`, `reverse = TRUE`) so a lower combined sub-score
(better attainment) gives a higher outcome.

## Examples

``` r
anlz_wq_attain(tbeptools::epcdata)
#> # A tibble: 208 × 4
#>    bay_segment    yr totsum outcome
#>    <chr>       <dbl>  <dbl>   <dbl>
#>  1 HB           1974      3   0.5  
#>  2 HB           1975      5   0.167
#>  3 HB           1976      5   0.167
#>  4 HB           1977      5   0.167
#>  5 HB           1978      6   0    
#>  6 HB           1979      6   0    
#>  7 HB           1980      6   0    
#>  8 HB           1981      6   0    
#>  9 HB           1982      6   0    
#> 10 HB           1983      3   0.5  
#> # ℹ 198 more rows
```
