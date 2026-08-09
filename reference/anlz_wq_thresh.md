# Water quality threshold attainment outcome by bay segment, year, and variable

Water quality threshold attainment outcome by bay segment, year, and
variable

## Usage

``` r
anlz_wq_thresh(epcdata)
```

## Arguments

- epcdata:

  data.frame of raw water quality data, e.g.
  [`tbeptools::epcdata`](https://rdrr.io/pkg/tbeptools/man/epcdata.html)

## Value

A data.frame with columns `bay_segment`, `yr`, `indicator`
(`"chla_thresh"` or `"la_thresh"`), and `outcome` (0 or 1, 1 = best) -
ready to stack into
[`anlz_indicators`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md)

## Details

Compares annual mean chlorophyll and light attenuation values against
the bay-segment-specific thresholds in
[`targets`](https://rdrr.io/pkg/tbeptools/man/targets.html), using
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
with `type = "threshold"` - a value below its threshold gives an outcome
of 1, at or above gives 0. Only `mean_chla` and `mean_la` are scored
([`tbeptools::targets`](https://rdrr.io/pkg/tbeptools/man/targets.html)
has no threshold for the third variable
[`anlz_avedat`](https://rdrr.io/pkg/tbeptools/man/anlz_avedat.html)
returns, `mean_sdm`).

## Examples

``` r
anlz_wq_thresh(tbeptools::epcdata)
#> # A tibble: 420 × 4
#>       yr bay_segment indicator   outcome
#>    <dbl> <chr>       <chr>         <dbl>
#>  1  1974 HB          chla_thresh       0
#>  2  1974 LTB         chla_thresh       1
#>  3  1974 MTB         chla_thresh       0
#>  4  1974 OTB         chla_thresh       0
#>  5  1975 HB          chla_thresh       0
#>  6  1975 LTB         chla_thresh       1
#>  7  1975 MTB         chla_thresh       0
#>  8  1975 OTB         chla_thresh       0
#>  9  1976 HB          chla_thresh       0
#> 10  1976 LTB         chla_thresh       1
#> # ℹ 410 more rows
```
