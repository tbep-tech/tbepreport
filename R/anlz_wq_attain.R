#' Water quality attainment outcome by bay segment and year
#'
#' @param epcdata data.frame of raw water quality data, e.g.
#'   \code{tbeptools::epcdata}
#'
#' @details Combines chlorophyll and light attenuation attainment of management targets (from
#' [`anlz_attain`](https://tbep-tech.github.io/tbeptools/reference/anlz_attain.html)) into 
#' a single continuous outcome.  The two sub-scores are summed (each 0-3 assessing magnitude and duration 
#' of exceedance), then converted with \code{\link{util_outcome}}
#' (\code{type = "continuous"}, \code{reverse = TRUE}) so a lower combined
#' sub-score (better attainment) gives a higher outcome.
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{totsum} (the summed chlorophyll/light attenuation sub-score), and
#' \code{outcome} (0-1, 1 = best)
#'
#' @export
#'
#' @examples
#' anlz_wq_attain(tbeptools::epcdata)
anlz_wq_attain <- function(epcdata) {

  avedat <- tbeptools::anlz_avedat(epcdata)

  out <- avedat |>
    tbeptools::anlz_attain() |>
    tidyr::separate(.data$chl_la, into = c('chl', 'la'), sep = '_') |>
    dplyr::mutate(dplyr::across(dplyr::all_of(c('chl', 'la')), as.numeric)) |>
    dplyr::mutate(
      totsum = .data$chl + .data$la,
      outcome = util_outcome(.data$totsum, type = 'continuous', reverse = TRUE, from = c(0, 6))
    ) |>
    dplyr::select(dplyr::all_of(c('bay_segment', 'yr', 'totsum', 'outcome')))

  return(out)

}
