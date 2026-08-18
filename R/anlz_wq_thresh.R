#' Water quality threshold attainment outcome by bay segment, year, and variable
#'
#' @param epcdata data.frame of raw water quality data, e.g.
#'   \code{tbeptools::epcdata}
#' @param smooth passed to \code{\link{util_outcome}}. One of
#'   \code{"logistic"} (the default), \code{"ramp"}, or \code{"none"}. By
#'   default, use a smooth logistic transition centered at each
#'   bay-segment's threshold instead of a hard 0/1 cutoff.
#' @param pct numeric, passed to \code{\link{util_outcome}} as the fraction
#'   of each threshold used for the transition's steepness when
#'   \code{smooth} is \code{"logistic"} or \code{"ramp"}. Defaults to
#'   \code{0.1} (10% of the threshold).
#'
#' @details Compares annual mean chlorophyll and light attenuation values
#' against the bay-segment-specific thresholds in [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.html),
#' using \code{\link{util_outcome}} with \code{type = "threshold"}. By
#' default (\code{smooth = "logistic"}), a value below its threshold approaches an
#' outcome of 1 and at or above approaches 0, with a smooth logistic
#' transition between them. Only \code{mean_chla} and \code{mean_la} are scored
#' (\code{tbeptools::targets} has no threshold for the third variable
#' [`anlz_avedat`](https://tbep-tech.github.io/tbeptools/reference/anlz_avedat.html) returns, \code{mean_sdm}).
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{indicator} (\code{"chla_thresh"} or \code{"la_thresh"}), and
#' \code{outcome} (0-1, 1 = best)
#'
#' @export
#'
#' @examples
#' anlz_wq_thresh(tbeptools::epcdata)
anlz_wq_thresh <- function(epcdata, smooth = 'logistic', pct = 0.1) {

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
