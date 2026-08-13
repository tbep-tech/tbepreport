#' Water quality threshold attainment outcome by bay segment, year, and variable
#'
#' @param epcdata data.frame of raw water quality data, e.g.
#'   \code{tbeptools::epcdata}
#' @param smooth logical, passed to \code{\link{util_outcome}} - if
#'   \code{TRUE} (the default), use a smooth logistic transition centered at
#'   each bay-segment's threshold instead of a hard 0/1 cutoff.
#' @param pct numeric, passed to \code{\link{util_outcome}} as the fraction
#'   of each threshold used for the logistic transition's steepness when
#'   \code{smooth = TRUE}. Defaults to \code{0.1} (10% of the threshold).
#'
#' @details Compares annual mean chlorophyll and light attenuation values
#' against the bay-segment-specific thresholds in \code{\link[tbeptools]{targets}},
#' using \code{\link{util_outcome}} with \code{type = "threshold"} - by
#' default (\code{smooth = TRUE}) a value below its threshold approaches an
#' outcome of 1 and at or above approaches 0, with a smooth logistic
#' transition between them; \code{smooth = FALSE} instead gives a hard 0/1
#' cutoff. Only \code{mean_chla} and \code{mean_la} are scored
#' (\code{tbeptools::targets} has no threshold for the third variable
#' \code{\link[tbeptools]{anlz_avedat}} returns, \code{mean_sdm}).
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{indicator} (\code{"chla_thresh"} or \code{"la_thresh"}), and
#' \code{outcome} (0-1, 1 = best; exactly 0 or 1 only if \code{smooth =
#' FALSE}) - ready to stack into \code{\link{anlz_indicators}}
#'
#' @export
#'
#' @examples
#' anlz_wq_thresh(tbeptools::epcdata)
anlz_wq_thresh <- function(epcdata, smooth = TRUE, pct = 0.1) {

  avedat <- tbeptools::anlz_avedat(epcdata)

  out <- avedat$ann |>
    dplyr::filter(.data$var %in% c('mean_chla', 'mean_la')) |>
    dplyr::left_join(tbeptools::targets, by = 'bay_segment') |>
    dplyr::mutate(
      thresh = ifelse(.data$var == 'mean_chla', .data$chla_thresh, .data$la_thresh),
      outcome = util_outcome(.data$val, type = 'threshold', thresh = .data$thresh, op = '<',
                              smooth = smooth, pct = pct),
      indicator = dplyr::recode(.data$var, mean_chla = 'chla_thresh', mean_la = 'la_thresh')
    ) |>
    dplyr::select(dplyr::all_of(c('yr', 'bay_segment', 'indicator', 'outcome')))

  return(out)

}
