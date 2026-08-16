# Sediment quality (PEL/TEL) outcome by bay segment and year

Sediment quality (PEL/TEL) outcome by bay segment and year

## Usage

``` r
anlz_sed_peltel(sedimentdata, yrs)
```

## Arguments

- sedimentdata:

  data.frame of raw sediment monitoring data, e.g.
  [`tbeptools::sedimentdata`](https://rdrr.io/pkg/tbeptools/man/sedimentdata.html)

- yrs:

  integer vector of years to assess, passed to
  [`anlz_sedimentpelave`](https://rdrr.io/pkg/tbeptools/man/anlz_sedimentpelave.html)
  one year at a time

## Value

A data.frame with columns `yr`, `bay_segment`, `ave` (average sediment
contamination score), `grd` (letter grade A-F, for reference only - not
used to compute `outcome`), and `outcome` (0-1, 1 = best)

## Details

Grades each bay segment/year by its average sediment contamination score
(`ave`, from
[`anlz_sedimentpelave`](https://rdrr.io/pkg/tbeptools/man/anlz_sedimentpelave.html))
into A-F, kept here as `grd` for reference, but the `outcome` itself
comes directly from the continuous `ave` score via
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
(`type = "continuous"`, `reverse = TRUE`) rather than from `grd`.
Because the grade breakpoints are geometrically spaced (each roughly
2.7-4x the last: 0.00756, 0.02052, 0.08567, 0.28026), `ave` is
log-transformed first so the outcome varies smoothly across grades B-D
instead of being compressed near one end of the 0-1 scale; `from` spans
the A/B breakpoint to the D/F breakpoint (on the log scale), so -
matching the same clamped-breakpoint-window treatment used for the
Nekton Index's `from = c(32, 46)` - `ave` at or below the A/B breakpoint
gives an outcome of 1 and at or above the D/F breakpoint gives an
outcome of 0.

## Examples

``` r
anlz_sed_peltel(tbeptools::sedimentdata, yrs = 2020)
#> # A tibble: 7 × 5
#>      yr bay_segment    ave grd   outcome
#>   <dbl> <chr>        <dbl> <fct>   <dbl>
#> 1  2020 BCB         0.0329 C       0.593
#> 2  2020 HB          0.0447 C       0.508
#> 3  2020 LTB         0.0209 C       0.719
#> 4  2020 MR          0.0989 D       0.288
#> 5  2020 MTB         0.0136 B       0.837
#> 6  2020 OTB         0.0350 C       0.576
#> 7  2020 TCB         0.0481 C       0.488
```
