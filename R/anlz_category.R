#' Combine indicators into a single score by bay segment and year
#'
#' @param ... named data.frames, passed to \code{\link{anlz_indicators}} -
#'   see its documentation for the expected shape
#' @param bay_segments chr vector of bay segments to include, defaults to
#'   \code{c('OTB', 'HB', 'MTB', 'LTB')}, the four segments with the most
#'   complete indicator coverage
#' @param yr_min integer, minimum year to include, defaults to \code{2000}
#' @param wt named numeric vector of weights, keyed by the \code{indicator}
#'   values produced by \code{\link{anlz_indicators}} (e.g.
#'   \code{c(chla_thresh = 2, fib = 1)} to weight an indicator, or
#'   \code{c(wq = 2, sed = 1)} when combining category scores via
#'   \code{\link{anlz_score}}). Indicators not named in \code{wt} - including
#'   all of them when \code{wt = NULL} - get a weight of \code{1}, so the
#'   default is a plain unweighted mean.
#'
#' @details Stacks \code{...} with \code{\link{anlz_indicators}}, then
#' averages \code{outcome} across whatever indicators have data for a given
#' bay segment/year - see \code{n_indicator} in the output for how many
#' contributed. This same averaging step produces a category score when
#' \code{...} are raw indicator outputs, and the final bay segment score
#' when \code{...} are the four category scores (see
#' \code{\link{anlz_score}}) - the two are mechanically identical.
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{outcome} (0-1, 1 = best), \code{n_indicator} (number of indicators
#' averaged for that segment/year), and one additional column per indicator
#' (named from \code{...} or \code{\link{anlz_indicators}}'s \code{indicator}
#' column) holding that indicator's own outcome, \code{NA} where a
#' segment/year has no data for it
#'
#' @export
#'
#' @examples
#' anlz_category(
#'   wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8),
#'   fib = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.4)
#' )
anlz_category <- function(..., bay_segments = c('OTB', 'HB', 'MTB', 'LTB'),
                           yr_min = 2000, wt = NULL) {

  indicators <- anlz_indicators(..., bay_segments = bay_segments)

  indicators$wt <- 1
  if (!is.null(wt)) {
    matched <- indicators$indicator %in% names(wt)
    indicators$wt[matched] <- unname(wt[indicators$indicator[matched]])
  }

  indicators <- indicators |>
    dplyr::filter(.data$yr >= yr_min)

  smmry <- indicators |>
    dplyr::group_by(.data$bay_segment, .data$yr) |>
    dplyr::summarise(
      outcome = stats::weighted.mean(.data$outcome, w = .data$wt, na.rm = TRUE),
      n_indicator = dplyr::n(),
      .groups = 'drop'
    )

  wide <- indicators |>
    dplyr::select(dplyr::all_of(c('bay_segment', 'yr', 'indicator', 'outcome'))) |>
    tidyr::pivot_wider(names_from = 'indicator', values_from = 'outcome', values_fn = mean)

  out <- dplyr::left_join(smmry, wide, by = c('bay_segment', 'yr'))

  return(out)

}
