#' Sediment quality (PEL/TEL) outcome by bay segment and year
#'
#' @param sedimentdata data.frame of raw sediment monitoring data, e.g.
#'   \code{tbeptools::sedimentdata}
#' @param yrs integer vector of years to assess, passed to
#'   [`anlz_sedimentpelave`](https://tbep-tech.github.io/tbeptools/reference/anlz_sedimentpelave.html) one year at a time
#'
#' @details Grades each bay segment/year by its average sediment
#' contamination score (\code{ave}, from
#' [`anlz_sedimentpelave`](https://tbep-tech.github.io/tbeptools/reference/anlz_sedimentpelave.html)) into A-F, kept here as
#' \code{grd} for reference, but the \code{outcome} itself comes directly
#' from the continuous \code{ave} score via \code{\link{util_outcome}}
#' (\code{type = "continuous"}, \code{reverse = TRUE}) rather than from
#' \code{grd}. Because the grade breakpoints are geometrically spaced
#' (each roughly 2.7-4x the last: 0.00756, 0.02052, 0.08567, 0.28026),
#' \code{ave} is log-transformed first so the outcome varies smoothly
#' across grades B-D instead of being compressed. \code{from} spans 
#' the A/B breakpoint to the D/F breakpoint (on the log scale), so that \code{ave}
#' at or below the A/B breakpoint gives an outcome of 1 and at or above the
#' D/F breakpoint gives an outcome of 0.
#'
#' @returns A data.frame with columns \code{yr}, \code{bay_segment},
#' \code{ave} (average sediment contamination score), \code{grd} (letter
#' grade A-F, for reference only, not used to compute \code{outcome}), and
#' \code{outcome} (0-1, 1 = best)
#'
#' @export
#'
#' @examples
#' anlz_sed_peltel(tbeptools::sedimentdata, yrs = 2020)
anlz_sed_peltel <- function(sedimentdata, yrs) {

  gradelevs <- c(A = 1, B = 0.75, C = 0.5, D = 0.25, F = 0)
  brks <- c(0.00756, 0.02052, 0.08567, 0.28026) # same cuts from tbeptools

  out <- tibble::tibble(yr = yrs) |>
    dplyr::group_nest(.data$yr) |>
    dplyr::mutate(
      data = purrr::map(.data$yr, function(x) tbeptools::anlz_sedimentpelave(sedimentdata, yrrng = x))
    ) |>
    tidyr::unnest('data') |>
    dplyr::mutate(
      bay_segment = as.character(.data$AreaAbbr),
      grd = cut(.data$ave, breaks = c(-Inf, brks, Inf), labels = names(gradelevs)),
      outcome = util_outcome(log(.data$ave), type = 'continuous',
                              from = log(c(brks[1], brks[4])), reverse = TRUE)
    ) |>
    dplyr::select(dplyr::all_of(c('yr', 'bay_segment', 'ave', 'grd', 'outcome')))

  return(out)

}
