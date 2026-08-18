# Tidal creek condition outcome by bay segment and year

Tidal creek condition outcome by bay segment and year

## Usage

``` r
anlz_wq_tidalcreeks(tidalcreeks, iwrraw, yrs)
```

## Arguments

- tidalcreeks:

  sf object of tidal creek assessment segments, e.g.
  [`tbeptools::tidalcreeks`](https://rdrr.io/pkg/tbeptools/man/tidalcreeks.html)

- iwrraw:

  data.frame of raw IWR water quality data for tidal creeks, e.g.
  [`tbeptools::iwrraw`](https://rdrr.io/pkg/tbeptools/man/iwrraw.html)

- yrs:

  integer vector of years to assess, passed to
  [`anlz_tdlcrk`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrk.html)

## Value

A data.frame with columns `bay_segment`, `yr`, `outcome` (0-1, 1 =
best), and `n_assessed` (number of creek records feeding that
segment/year's outcome)

## Details

Each tidal creek is assigned to the bay segment subwatershed
([`tbsegshed`](https://tbep-tech.github.io/tbeptools/reference/tbsegshed.html))
it overlaps most (by length, for creeks spanning more than one
subwatershed).

[`anlz_tdlcrk`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrk.html)
computes each creek's condition category
(Prioritize/Investigate/Caution/Monitor) from year counts out of a
rolling 10-year window. The category itself comes from a compound rule
(the worst grade present usually wins, with several count-based
exceptions that downgrade it, e.g. a single bad year surrounded by
mostly good years). Rather than use that category, this converts each
creek's own 4 counts directly into a continuous 0-1 score. This is a
count-weighted average across an ordinal scale for each category
(`Monitor = 1`, `Caution = 2/3`, `Investigate = 1/3`, `Prioritize = 0`),
i.e. what fraction of the 10-year window fell in each grade. Creeks with
a "No Data" assessment are dropped.

Each creek's continuous score is then averaged to a bay-segment/year
outcome, weighted by each creek's physical length so longer creek
segments contribute proportionally more.

## Examples

``` r
if (FALSE) { # \dontrun{
anlz_wq_tidalcreeks(tbeptools::tidalcreeks, tbeptools::iwrraw, yrs = 2015:2020)
} # }
```
