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
  [`anlz_tdlcrk`](https://rdrr.io/pkg/tbeptools/man/anlz_tdlcrk.html)

## Value

A data.frame with columns `bay_segment`, `yr`, `outcome` (0-1, 1 =
best), and `n_assessed` (number of creek records feeding that
segment/year's outcome)

## Details

Each tidal creek is assigned to the bay segment subwatershed
([`tbsegshed`](https://rdrr.io/pkg/tbeptools/man/tbsegshed.html)) it
overlaps most (by length, for creeks spanning more than one
subwatershed).

[`anlz_tdlcrk`](https://rdrr.io/pkg/tbeptools/man/anlz_tdlcrk.html)
computes each creek's condition category
(Prioritize/Investigate/Caution/Monitor) from counts of how many years,
out of a rolling 10-year window, its TN concentration fell into each of
4 ordinal grades (`monitor`, `caution`, `investigate`, `prioritize`,
worst to best) - the category itself comes from a compound rule (the
worst grade present usually wins, with several count-based exceptions
that downgrade it, e.g. a single bad year surrounded by mostly good
years). Rather than use that category, this converts each creek's own 4
counts directly into a continuous 0-1 score - the same count-weighted
average across the same ordinal scale the category uses (`Monitor = 1`,
`Caution = 2/3`, `Investigate = 1/3`, `Prioritize = 0`), i.e. what
fraction of the 10-year window fell in each grade. This is a related but
distinct measure from the official category - it can disagree in some
cases, since the category's downgrade exceptions are non-monotonic and a
count-weighted average won't reproduce them (e.g. a creek with a single
Prioritize-level year among mostly Monitor-level years can score higher
continuously than a creek with several Caution-level years, even though
the latter is categorized as the less severe "Caution" rather than
"Prioritize"). Creeks with a "No Data" assessment (no counts at all) are
dropped.

Each creek's continuous score is then averaged to a bay-segment/year
outcome, weighted by each creek's physical length so longer creek
segments contribute proportionally more.

## Examples

``` r
if (FALSE) { # \dontrun{
anlz_wq_tidalcreeks(tbeptools::tidalcreeks, tbeptools::iwrraw, yrs = 2015:2020)
} # }
```
