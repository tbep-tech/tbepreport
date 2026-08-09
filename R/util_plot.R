# continuous red -> yellow -> green scale for a 0-1 outcome (1 = best);
# NA is rendered as gray to flag missing data rather than being dropped
util_pal_outcome <- function(outcome) {

  colfun <- scales::col_numeric(
    palette = c('#CC3231', '#E9C318', '#2DC938'),
    domain  = c(0, 1)
  )

  out <- colfun(outcome)
  out[is.na(outcome)] <- '#c3c2b7'

  out

}

# display-label overrides for raw column/category names that need something
# other than their auto-formatted title case (e.g. abbreviations, renamed
# metrics) - anything not listed here falls back to auto-formatting
util_lab_lookup <- c(
  wq  = 'Water Quality',
  sed = 'Sediment',
  fw  = 'Fish and Wildlife',
  hab = 'Habitat',

  wq_attain  = 'Targets',
  la_thresh  = 'Light Thresh',
  tn_load    = 'Abs Load',
  tnhy_load  = 'Norm Load',
  fib        = 'Fecal',
  sed_tbbi   = 'Benthic Index',
  sed_peltel = 'Contaminants',
  tbni       = 'Nekton Index'
)

# title-case, underscore-free display label for a raw column/indicator name,
# unless overridden in util_lab_lookup
util_lab_format <- function(x) {

  out <- tools::toTitleCase(gsub('_', ' ', x))
  matched <- x %in% names(util_lab_lookup)
  out[matched] <- unname(util_lab_lookup[x[matched]])

  out

}

# indicator/category columns of an anlz_category()/anlz_score() output -
# every column besides the fixed bay_segment/yr/outcome/n_indicator ones
util_indicator_cols <- function(x) {

  setdiff(names(x), c('bay_segment', 'yr', 'outcome', 'n_indicator'))

}
