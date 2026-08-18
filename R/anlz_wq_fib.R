#' Fecal indicator bacteria (FIB) outcome by bay segment and year
#'
#' @param enterodata data.frame of raw enterococcus monitoring data, e.g.
#'   \code{tbeptools::enterodata}
#'
#' @details Uses [`anlz_fibmatrix`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibmatrix.html) to get, 
#' for each bay segment/year, \code{exceed_rate}, a continuous, one-sided 90\% upper
#' confidence estimate of the true exceedance rate (0-1, lower is better),
#' and converts it to a 0-1 outcome with \code{\link{util_outcome}}
#' (\code{type = "continuous"}, \code{from = c(0, 1)}, \code{reverse = TRUE}),
#' i.e. \code{outcome = 1 - exceed_rate}. This is a continuous analog of the
#' A-E letter grade \code{anlz_fibmatrix()} also returns (\code{cat}), which
#' is itself a discretized version of \code{exceed_rate}.  See
#' [`anlz_fibmatrix`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibmatrix.html) for details.
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr}, and
#' \code{outcome} (0-1, 1 = best)
#'
#' @export
#'
#' @examples
#' anlz_wq_fib(tbeptools::enterodata)
anlz_wq_fib <- function(enterodata) {

  out <- tbeptools::anlz_fibmatrix(enterodata, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB', 'MR')) |>
    dplyr::mutate(
      bay_segment = as.character(.data$grp),
      outcome = util_outcome(.data$exceed_rate, type = 'continuous', from = c(0, 1), reverse = TRUE)
    ) |>
    dplyr::select(dplyr::all_of(c('bay_segment', 'yr', 'outcome')))

  return(out)

}
