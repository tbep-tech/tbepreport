#' Water quality threshold attainment outcome by bay segment, year, and variable
#'
#' @param epcdata data.frame of raw water quality data, e.g.
#'   \code{tbeptools::epcdata}
#'
#' @details Compares annual mean chlorophyll and light attenuation values
#' against the bay-segment-specific thresholds in \code{\link[tbeptools]{targets}},
#' using \code{\link{util_outcome}} with \code{type = "threshold"} - a value
#' below its threshold gives an outcome of 1, at or above gives 0. Only
#' \code{mean_chla} and \code{mean_la} are scored (\code{tbeptools::targets}
#' has no threshold for the third variable \code{\link[tbeptools]{anlz_avedat}}
#' returns, \code{mean_sdm}).
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{indicator} (\code{"chla_thresh"} or \code{"la_thresh"}), and
#' \code{outcome} (0 or 1, 1 = best) - ready to stack into
#' \code{\link{anlz_indicators}}
#'
#' @export
#'
#' @examples
#' anlz_wq_thresh(tbeptools::epcdata)
anlz_wq_thresh <- function(epcdata) {

  avedat <- tbeptools::anlz_avedat(epcdata)

  out <- avedat$ann |>
    dplyr::filter(.data$var %in% c('mean_chla', 'mean_la')) |>
    dplyr::left_join(tbeptools::targets, by = 'bay_segment') |>
    dplyr::mutate(
      thresh = ifelse(.data$var == 'mean_chla', .data$chla_thresh, .data$la_thresh),
      outcome = util_outcome(.data$val, type = 'threshold', thresh = .data$thresh, op = '<'),
      indicator = dplyr::recode(.data$var, mean_chla = 'chla_thresh', mean_la = 'la_thresh')
    ) |>
    dplyr::select(dplyr::all_of(c('yr', 'bay_segment', 'indicator', 'outcome')))

  return(out)

}
