# tbepreport (development version)

* `anlz_fw_tbni()` now converts the TBNI 0-100 score to an outcome using its
  own grade breakpoints (32, 46) instead of a plain linear rescale over the
  full 0-100 range, and gains a `from` argument (default `c(32, 46)`) so
  this can be reverted (e.g. `from = c(0, 100)`) or otherwise adjusted
  without editing the function
* `util_outcome()` continuous type now clamps output to `c(0, 1)`, so a
  `from` range narrower than the data (e.g. TBNI's 32-46 window) pins
  values outside it to 0/1 instead of extrapolating
* `anlz_wq_thresh()`, `anlz_wq_load()`, and `anlz_hab_seagrass_coverage()`
  gain `smooth`/`pct` arguments for a logistic (rather than hard cutoff)
  threshold outcome; `util_outcome()`'s threshold steepness is now a
  tunable `pct` of the threshold (default `0.1`) rather than a hardcoded
  10%
* **Breaking**: `smooth` now defaults to `TRUE` for `util_outcome(type =
  "threshold")` and for `anlz_wq_thresh()`, `anlz_wq_load()`, and
  `anlz_hab_seagrass_coverage()`, so these threshold-based outcomes are
  smooth logistic transitions by default instead of a hard 0/1 cutoff.
  Pass `smooth = FALSE` to restore the previous hard-cutoff behavior
* Add `plot_trend()`, a new faceted ggplot2 trend plot: an "Overall" facet
  (bay segment score with one line per category) followed by one facet per
  category (that category's score with one line per indicator), each
  score drawn as a bold dark line with its components as thinner colored
  lines, labeled directly rather than via a shared legend. Adds `ggplot2`
  and `ggrepel` as new package dependencies
* `plot_trend()` gains a `yr_range` argument (`c(min, max)`) to restrict
  the plotted years, defaulting to `NULL` (all available years)
* **Breaking**: `anlz_wq_fib()` now scores FIB using `exceed_rate`
  (`tbeptools::anlz_fibmatrix()`'s continuous, one-sided 90% upper
  confidence estimate of the true exceedance rate) instead of the A-E
  letter grade (`cat`), giving a continuous outcome (`1 - exceed_rate`)
  rather than one of 5 fixed values. Requires a `tbeptools` version with
  the `exceed_rate` column (not yet on CRAN/the published GitHub branch
  as of this change)
* **Breaking**: `anlz_sed_peltel()` now scores sediment contaminants
  directly from the continuous PEL/TEL average (`ave`), log-transformed
  and rescaled between the A/B and D/F grade breakpoints, instead of from
  the A-F letter grade (`grd`, still returned for reference but no longer
  used to compute `outcome`)
* **Breaking**: `anlz_sed_tbbi()` now scores the Benthic Index from the
  median of station-level TBBI scores, rescaled continuously over TBBI's
  73/87 grade breakpoints, instead of from the official Poor/Fair/Good bay
  segment grade (which is based on the proportion of stations in each
  condition category, not a single continuous statistic - see
  `?anlz_sed_tbbi` for how the two can disagree in edge cases). Output
  column `TBBICat` is replaced with `TBBI` (the median score)
