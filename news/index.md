# Changelog

## tbepreport (development version)

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
- **Breaking**: `smooth` now defaults to `TRUE` for
  `util_outcome(type = "threshold")` and for
  [`anlz_wq_thresh()`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_thresh.md),
  [`anlz_wq_load()`](https://tbep-tech.github.io/tbepreport/reference/anlz_wq_load.md),
  and
  [`anlz_hab_seagrass_coverage()`](https://tbep-tech.github.io/tbepreport/reference/anlz_hab_seagrass_coverage.md),
  so these threshold-based outcomes are smooth logistic transitions by
  default instead of a hard 0/1 cutoff. Pass `smooth = FALSE` to restore
  the previous hard-cutoff behavior
