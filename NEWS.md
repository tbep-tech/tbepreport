# tbepreport (development version)

* `anlz_fw_tbni()` now converts the TBNI 0-100 score to an outcome using its
  own grade breakpoints (32, 46) instead of a plain linear rescale over the
  full 0-100 range
* `util_outcome()` continuous type now clamps output to `c(0, 1)`, so a
  `from` range narrower than the data (e.g. TBNI's 32-46 window) pins
  values outside it to 0/1 instead of extrapolating
