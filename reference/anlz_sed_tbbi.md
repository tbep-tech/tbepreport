# Benthic index (TBBI) outcome by bay segment and year

Benthic index (TBBI) outcome by bay segment and year

## Usage

``` r
anlz_sed_tbbi(benthicdata)
```

## Arguments

- benthicdata:

  raw benthic monitoring data, e.g.
  [`tbeptools::benthicdata`](https://rdrr.io/pkg/tbeptools/man/benthicdata.html)

## Value

A data.frame with columns `yr`, `bay_segment`, `TBBI` (median
station-level score for that bay segment/year), and `outcome` (0-1, 1 =
best)

## Details

Uses
[`anlz_tbbiscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbiscr.html)
to get station-level TBBI scores (0-100), filtered to the same stations
[`anlz_tbbimed`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.html)
uses for its bay segment grades (`FundingProject == "TBEP"`,
`ProgramID == 4`, and `TBBI` between 0 and 100, for the 7 bay segments
[`anlz_tbbimed`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.html)
scores), then takes the median station score for each bay segment/year.
`outcome` comes directly from that continuous median via
[`util_outcome`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
(`type = "continuous"`, `from = c(73, 87)`), TBBI's own grade
breakpoints (Degraded below 73, Intermediate 73-87, Healthy above 87).
This is the same clamped-breakpoint-window treatment used for the Nekton
Index's `from = c(32, 46)`.

This bypasses
[`anlz_tbbimed`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.html)
entirely, which instead grades a bay segment/year Poor/Fair/Good from
the *proportion* of its stations falling in each of the
Degraded/Intermediate/Healthy categories. This is a compound rule on
those proportions, not a discretized version of a single continuous
statistic, so there's no direct continuous equivalent of it the way
there is for TBNI's or PEL/TEL's breakpoints. Scoring the median of the
raw station values instead is a related but distinct measure. It can
disagree with
[`anlz_tbbimed`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.html)'s
category in some edge cases (e.g. a bay segment split between many
Healthy and a few very Degraded stations can have a middling median
while still tripping the proportion rule's `Degraded >= 0.2` condition
for `"Poor"`).

## Examples

``` r
anlz_sed_tbbi(tbeptools::benthicdata)
#> # A tibble: 222 × 4
#>       yr bay_segment  TBBI outcome
#>    <dbl> <chr>       <dbl>   <dbl>
#>  1  1995 BCB          87.1   1    
#>  2  1996 BCB          84.1   0.793
#>  3  1997 BCB          78.2   0.368
#>  4  1998 BCB          83.6   0.755
#>  5  1999 BCB          80.3   0.523
#>  6  2000 BCB          85.4   0.885
#>  7  2001 BCB          80.3   0.522
#>  8  2002 BCB          78.7   0.406
#>  9  2003 BCB          84.4   0.811
#> 10  2004 BCB          85.3   0.879
#> # ℹ 212 more rows
```
