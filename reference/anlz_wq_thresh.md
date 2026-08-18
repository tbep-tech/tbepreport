# Water quality threshold attainment outcome by bay segment, year, and variable

Water quality threshold attainment outcome by bay segment, year, and
variable

## Usage

``` r
anlz_wq_thresh(epcdata, smooth = "logistic", pct = 0.1)
```

## Arguments

- epcdata:

  data.frame of raw water quality data, e.g.
  [`tbeptools::epcdata`](https://rdrr.io/pkg/tbeptools/man/epcdata.html)

- smooth:

  passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md).
  One of `"logistic"` (the default), `"ramp"`, or `"none"`. By default,
  use a smooth logistic transition centered at each bay-segment's
  threshold instead of a hard 0/1 cutoff.

- pct:

  numeric, passed to
  [`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
  as the fraction of each threshold used for the transition's steepness
  when `smooth` is `"logistic"` or `"ramp"`. Defaults to `0.1` (10% of
  the threshold).

## Value

A data.frame with columns `bay_segment`, `yr`, `indicator`
(`"chla_thresh"` or `"la_thresh"`), and `outcome` (0-1, 1 = best)

## Details

Compares annual mean chlorophyll and light attenuation values against
the bay-segment-specific thresholds in
[`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.html),
using
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
with `type = "threshold"`. By default (`smooth = "logistic"`), a value
below its threshold approaches an outcome of 1 and at or above
approaches 0, with a smooth logistic transition between them. Only
`mean_chla` and `mean_la` are scored
([`tbeptools::targets`](https://rdrr.io/pkg/tbeptools/man/targets.html)
has no threshold for the third variable
[`anlz_avedat`](https://tbep-tech.github.io/tbeptools/reference/anlz_avedat.html)
returns, `mean_sdm`).

## Examples

``` r
anlz_wq_thresh(tbeptools::epcdata)
#> # A tibble: 420 × 4
#>       yr bay_segment indicator     outcome
#>    <dbl> <chr>       <chr>           <dbl>
#>  1  1974 HB          chla_thresh 0.00713  
#>  2  1974 LTB         chla_thresh 0.844    
#>  3  1974 MTB         chla_thresh 0.204    
#>  4  1974 OTB         chla_thresh 0.267    
#>  5  1975 HB          chla_thresh 0.000180 
#>  6  1975 LTB         chla_thresh 0.580    
#>  7  1975 MTB         chla_thresh 0.0314   
#>  8  1975 OTB         chla_thresh 0.0147   
#>  9  1976 HB          chla_thresh 0.0000655
#> 10  1976 LTB         chla_thresh 0.509    
#> # ℹ 410 more rows
```
