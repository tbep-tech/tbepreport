#' Seagrass coverage outcome by bay segment and year
#'
#' @param sgsegest data.frame of seagrass coverage estimates by bay segment
#'   and year, e.g. \code{\link{sgsegest}}
#' @param yr_max integer, the last year to carry estimates forward to,
#'   defaults to the last year \code{sgsegest} actually has an estimate for
#'   (\code{max(sgsegest$year)})
#' @param smooth passed to \code{\link{util_outcome}}. One of
#'   \code{"ramp"} (the default), \code{"logistic"}, or \code{"none"}.
#'   \code{"ramp"} gives an outcome of 1
#'   for any acreage at or above a segment's target, decaying toward 0 the
#'   further short of it a segment falls.
#' @param pct numeric, passed to \code{\link{util_outcome}} as the fraction
#'   of each acreage target used for the transition's steepness when
#'   \code{smooth} is \code{"ramp"} or \code{"logistic"}. Defaults to
#'   \code{0.1} (10% of the target).
#'
#' @details Seagrass coverage maps are not produced every year. They're
#' flown approximately biennially (\code{\link{sgsegest}} has estimates for
#' most even years). To get a value for every calendar year, this fills the gaps by
#' carrying the most recent actual estimate (and the outcome derived from
#' it) \strong{forward} via \code{\link[tidyr]{complete}} +
#' \code{\link[tidyr]{fill}}. For example, a year with no survey repeats the
#' prior survey year's acreage and outcome unchanged, until the next actual
#' survey year updates it. This means \code{acres}/\code{outcome} in a
#' non-survey year are not a new estimate, just a repeat of the last known
#' one.
#'
#' Coverage is compared against a fixed per-segment acreage target with
#' \code{\link{util_outcome}} (\code{type = "threshold"}, \code{op = ">="}).
#' By default (\code{smooth = "ramp"}), meeting or exceeding the target
#' gives an outcome of 1, decaying toward 0 the further short of it a
#' segment falls. Targets (acres):
#' \describe{
#'   \item{Old Tampa Bay}{11,100}
#'   \item{Hillsborough Bay}{1,751}
#'   \item{Middle Tampa Bay}{9,400}
#'   \item{Lower Tampa Bay}{7,400}
#'   \item{Boca Ciega Bay}{8,800}
#'   \item{Terra Ceia Bay}{1,100}
#'   \item{Manatee River}{449}
#' }
#' These targets are derived from the baywide
#' 40,000-acre seagrass coverage target apportioned to each segment's 
#' share of total bay area.
#'
#' @returns A data.frame with columns \code{bay_segment} (abbreviated, e.g.
#' \code{"OTB"}), \code{yr}, \code{acres} (carried forward in non-survey
#' years), and \code{outcome} (0-1, 1 = best, also carried forward in
#' non-survey years)
#'
#' @export
#'
#' @examples
#' anlz_hab_seagrass_coverage(sgsegest)
anlz_hab_seagrass_coverage <- function(sgsegest, yr_max = max(sgsegest$year), smooth = 'ramp', pct = 0.1) {

  segtrgs <- c(
    'Old Tampa Bay'    = 11100,
    'Hillsborough Bay' = 1751,
    'Middle Tampa Bay' = 9400,
    'Lower Tampa Bay'  = 7400,
    'Boca Ciega Bay'   = 8800,
    'Terra Ceia Bay'   = 1100,
    'Manatee River'    = 449
  )
  segabbr <- c(
    'Old Tampa Bay'    = 'OTB',
    'Hillsborough Bay' = 'HB',
    'Middle Tampa Bay' = 'MTB',
    'Lower Tampa Bay'  = 'LTB',
    'Boca Ciega Bay'   = 'BCB',
    'Terra Ceia Bay'   = 'TCB',
    'Manatee River'    = 'MR'
  )

  out <- sgsegest |>
    dplyr::mutate(
      bay_segment = as.character(.data$segment),
      trgs = segtrgs[.data$bay_segment],
      outcome = util_outcome(.data$acres, type = 'threshold', thresh = .data$trgs, op = '>=',
                              smooth = smooth, pct = pct),
      bay_segment = segabbr[.data$bay_segment]
    ) |>
    dplyr::rename(yr = dplyr::all_of('year')) |>
    dplyr::select(dplyr::all_of(c('bay_segment', 'yr', 'acres', 'outcome'))) |>
    tidyr::complete(.data$bay_segment, yr = min(sgsegest$year):yr_max) |>
    tidyr::fill(dplyr::all_of(c('acres', 'outcome')), .direction = 'down', .by = dplyr::all_of('bay_segment'))

  return(out)

}
