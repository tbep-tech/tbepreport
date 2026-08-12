#' Tampa Bay Nekton Index (TBNI) outcome by bay segment and year
#'
#' @param fimdata data.frame of raw fisheries independent monitoring data,
#'   e.g. \code{tbeptools::fimdata}
#' @param from numeric vector of length 2, the \code{c(min, max)} range of
#'   \code{Segment_TBNI} passed to \code{\link{util_outcome}} as its
#'   \code{from} argument. Defaults to \code{c(32, 46)}, TBNI's own grade
#'   breakpoints. Pass \code{c(0, 100)} to revert to a plain linear rescale
#'   over the full score range with no clamping.
#'
#' @details Uses \code{\link[tbeptools]{anlz_tbniscr}} and
#' \code{\link[tbeptools]{anlz_tbniave}} to score each bay segment/year 0-100,
#' then converts to a 0-1 outcome with \code{\link{util_outcome}}
#' (\code{type = "continuous"}). With the default \code{from = c(32, 46)},
#' matching TBNI's own grade breakpoints (On Alert below 32, Caution from 32
#' to 46, Stay the Course above 46), scores below 32 give an outcome of 0,
#' scores above 46 give an outcome of 1, and scores in between are linearly
#' rescaled.
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{Segment_TBNI} (the raw 0-100 score), \code{Action} (management
#' action category from \code{\link[tbeptools]{anlz_tbniave}}), and
#' \code{outcome} (0-1, 1 = best)
#'
#' @export
#'
#' @examples
#' anlz_fw_tbni(tbeptools::fimdata)
anlz_fw_tbni <- function(fimdata, from = c(32, 46)) {

  out <- fimdata |>
    tbeptools::anlz_tbniscr() |>
    tbeptools::anlz_tbniave() |>
    dplyr::rename(yr = dplyr::all_of('Year')) |>
    dplyr::mutate(
      bay_segment = as.character(.data$bay_segment),
      outcome = util_outcome(.data$Segment_TBNI, type = 'continuous', from = from)
    )

  return(out)

}
