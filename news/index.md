# Changelog

## tbepreport (development version)

- [`plot_trend()`](https://tbep-tech.github.io/tbepreport/reference/plot_trend.md)
  gains a `facets` argument (one or more of `"Overall"`, `"wq"`,
  `"sed"`, `"fw"`, `"hab"`, default all five) to show a subset of
  facets, and a `text` argument (one of `"labels"` (the default),
  `"legend"`, or `"none"`) controlling how series are identified: direct
  labels at each line’s right-most value, a conventional ggplot legend,
  or neither. The right-margin/x-axis padding reserved for labels
  shrinks automatically when `text != "labels"`. `text = "legend"` is
  useful for combining multiple panels with `patchwork` and collecting
  one shared legend
- Add a “Trends and Sensitivity” vignette (`vignettes/trends.qmd`)
  comparing report card results across the four default bay segments and
  showing how a few scoring decisions (TBNI’s rescale window, threshold
  smoothing, category weights) change the results
- [`anlz_fw_tbni()`](https://tbep-tech.github.io/tbepreport/reference/anlz_fw_tbni.md)
  now converts the TBNI 0-100 score to an outcome using its own grade
  breakpoints (32, 46) instead of a plain linear rescale over the full
  0-100 range, and gains a `from` argument (default `c(32, 46)`) so this
  can be reverted (e.g. `from = c(0, 100)`) or otherwise adjusted
  without editing the function
- [`util_outcome()`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
  continuous type now clamps output to `c(0, 1)`, so a `from` range
  narrower than the data (e.g. TBNI’s 32-46 window) pins values outside
  it to 0/1 instead of extrapolating
- [`anlz_wq_thresh()`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_thresh.md),
  [`anlz_wq_load()`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_load.md),
  and
  [`anlz_hab_seagrass_coverage()`](https://tbep-tech.github.io/tbepreport/reference/anlz_hab_seagrass_coverage.md)
  gain `smooth`/`pct` arguments for a logistic (rather than hard cutoff)
  threshold outcome;
  [`util_outcome()`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)’s
  threshold steepness is now a tunable `pct` of the threshold (default
  `0.1`) rather than a hardcoded 10%
- **Breaking**: `smooth` now defaults to `"logistic"` for
  `util_outcome(type = "threshold")` and for
  [`anlz_wq_thresh()`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_thresh.md),
  [`anlz_wq_load()`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_load.md),
  and
  [`anlz_hab_seagrass_coverage()`](https://tbep-tech.github.io/tbepreport/reference/anlz_hab_seagrass_coverage.md),
  so these threshold-based outcomes are smooth logistic transitions by
  default instead of a hard 0/1 cutoff. Pass `smooth = "none"` to
  restore the previous hard-cutoff behavior
- Add
  [`plot_trend()`](https://tbep-tech.github.io/tbepreport/reference/plot_trend.md),
  a new faceted ggplot2 trend plot: an “Overall” facet (bay segment
  score with one line per category) followed by one facet per category
  (that category’s score with one line per indicator), each score drawn
  as a bold dark line with its components as thinner colored lines,
  labeled directly rather than via a shared legend. Adds `ggplot2` and
  `ggrepel` as new package dependencies
- [`plot_trend()`](https://tbep-tech.github.io/tbepreport/reference/plot_trend.md)
  gains a `yr_range` argument (`c(min, max)`) to restrict the plotted
  years, defaulting to `NULL` (all available years)
- **Breaking**:
  [`anlz_wq_fib()`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_fib.md)
  now scores FIB using `exceed_rate`
  ([`tbeptools::anlz_fibmatrix()`](https://rdrr.io/pkg/tbeptools/man/anlz_fibmatrix.html)’s
  continuous, one-sided 90% upper confidence estimate of the true
  exceedance rate) instead of the A-E letter grade (`cat`), giving a
  continuous outcome (`1 - exceed_rate`) rather than one of 5 fixed
  values. Requires a `tbeptools` version with the `exceed_rate` column
  (not yet on CRAN/the published GitHub branch as of this change)
- **Breaking**:
  [`anlz_sed_peltel()`](https://tbep-tech.github.io/tbepreport/reference/anlz_sed_peltel.md)
  now scores sediment contaminants directly from the continuous PEL/TEL
  average (`ave`), log-transformed and rescaled between the A/B and D/F
  grade breakpoints, instead of from the A-F letter grade (`grd`, still
  returned for reference but no longer used to compute `outcome`)
- **Breaking**:
  [`anlz_sed_tbbi()`](https://tbep-tech.github.io/tbepreport/reference/anlz_sed_tbbi.md)
  now scores the Benthic Index from the median of station-level TBBI
  scores, rescaled continuously over TBBI’s 73/87 grade breakpoints,
  instead of from the official Poor/Fair/Good bay segment grade (which
  is based on the proportion of stations in each condition category, not
  a single continuous statistic - see
  [`?anlz_sed_tbbi`](https://tbep-tech.github.io/tbepreport/reference/anlz_sed_tbbi.md)
  for how the two can disagree in edge cases). Output column `TBBICat`
  is replaced with `TBBI` (the median score)
- **Breaking**:
  [`anlz_wq_tidalcreeks()`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_tidalcreeks.md)
  now scores each creek from a count-weighted average across the same
  ordinal scale (`monitor`/`caution`/`investigate`/`prioritize` counts
  from
  [`tbeptools::anlz_tdlcrk()`](https://rdrr.io/pkg/tbeptools/man/anlz_tdlcrk.html)’s
  10-year window) its official Prioritize/Investigate/Caution/Monitor
  condition category also comes from, instead of that category itself
  (which uses a compound rule with count-based exceptions - see
  [`?anlz_wq_tidalcreeks`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_tidalcreeks.md)
  for how the two can disagree in edge cases)
- All indicators previously scored from a discrete grade/category now
  use a continuous score derived from the same underlying data (FIB,
  sediment PEL/TEL, Benthic Index, tidal creeks); no indicator currently
  uses `util_outcome(type = "category")`, though it remains available
- [`util_outcome()`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)’s
  `smooth` argument for `type = "threshold"` now takes one of
  `"logistic"`, `"ramp"`, or `"none"`. `"ramp"` gives an outcome of 1
  once a value reaches the “good” side of the threshold - not just 0.5
  there like `"logistic"` - decaying exponentially toward 0 the further
  it falls on the “bad” side, using the same `pct`-of-threshold
  steepness rule
- **Breaking**:
  [`anlz_hab_seagrass_coverage()`](https://tbep-tech.github.io/tbepreport/reference/anlz_hab_seagrass_coverage.md)’s
  `smooth` default changes from `TRUE` (logistic) to `"ramp"`, so
  meeting or exceeding a segment’s acreage target is now full credit
  (outcome of 1) rather than only 0.5 exactly at the target
