#' Nutrient loading outcome by bay segment, year, and indicator
#'
#' @param totanndat data.frame of total annual loading estimates, with
#'   columns \code{year}, \code{bay_segment} (full segment names, e.g.
#'   \code{"Old Tampa Bay"}), \code{tn_load}, and \code{tnhy} - e.g. as
#'   returned by \code{util_rdataload()} on the
#'   \href{https://github.com/tbep-tech/load-estimates}{load-estimates} data
#' @param smooth logical, passed to \code{\link{util_outcome}} - if
#'   \code{TRUE} (the default), use a smooth logistic transition centered at
#'   each target instead of a hard 0/1 cutoff.
#' @param pct numeric, passed to \code{\link{util_outcome}} as the fraction
#'   of each target used for the logistic transition's steepness when
#'   \code{smooth = TRUE}. Defaults to \code{0.1} (10% of the target).
#'
#' @details Compares two loading measures against fixed bay-segment targets,
#' using \code{\link{util_outcome}} with \code{type = "threshold"} - by
#' default (\code{smooth = TRUE}) a value below its target approaches an
#' outcome of 1 and at or above approaches 0, with a smooth logistic
#' transition between them; \code{smooth = FALSE} instead gives a hard 0/1
#' cutoff:
#' \itemize{
#'   \item \code{tn_load}: total nitrogen load
#'   \item \code{tnhy_load}: \code{tnhy}, the total nitrogen load normalized
#'     by hydrologic load (i.e. TN load per unit of hydrologic load, a
#'     hydrologically-normalized loading rate) - \strong{not} the raw
#'     hydrologic (freshwater inflow) load itself. The raw \code{hy_load}
#'     column in \code{totanndat} is not used here.
#' }
#' Returned in long format with one row per indicator, ready to stack into
#' \code{\link{anlz_indicators}}.
#'
#' @returns A data.frame with columns \code{bay_segment} (abbreviated, e.g.
#' \code{"OTB"}), \code{yr}, \code{indicator} (\code{"tn_load"} or
#' \code{"tnhy_load"} - see Details for what \code{"tnhy_load"} measures),
#' and \code{outcome} (0-1, 1 = best; exactly 0 or 1 only if \code{smooth =
#' FALSE})
#'
#' @export
#'
#' @examples
#' \dontrun{
#' totanndat <- util_rdataload(
#'   "https://github.com/tbep-tech/load-estimates/raw/main/data/totanndat.RData"
#' )
#' anlz_wq_load(totanndat)
#' }
anlz_wq_load <- function(totanndat, smooth = TRUE, pct = 0.1) {

  segcrsswk <- c(
    'Old Tampa Bay'     = 'OTB',
    'Hillsborough Bay'  = 'HB',
    'Middle Tampa Bay'  = 'MTB',
    'Lower Tampa Bay'   = 'LTB'
  )
  tntarg <- tibble::tibble(
    bay_segment    = segcrsswk,
    tn_load_thresh = c(486, 1451, 799, 349),
    tnhy_thresh    = c(1.08, 1.62, 1.24, 0.97)
  )

  dat <- totanndat |>
    dplyr::filter(.data$bay_segment %in% names(segcrsswk)) |>
    dplyr::mutate(bay_segment = segcrsswk[.data$bay_segment]) |>
    dplyr::select(dplyr::all_of(c('year', 'bay_segment', 'tn_load', 'tnhy'))) |>
    dplyr::left_join(tntarg, by = 'bay_segment')

  out <- dplyr::bind_rows(
    dat |>
      dplyr::transmute(
        bay_segment = .data$bay_segment,
        yr = as.integer(.data$year),
        indicator = 'tn_load',
        outcome = util_outcome(.data$tn_load, type = 'threshold', thresh = .data$tn_load_thresh, op = '<',
                                smooth = smooth, pct = pct)
      ),
    dat |>
      dplyr::transmute(
        bay_segment = .data$bay_segment,
        yr = as.integer(.data$year),
        indicator = 'tnhy_load',
        outcome = util_outcome(.data$tnhy, type = 'threshold', thresh = .data$tnhy_thresh, op = '<',
                                smooth = smooth, pct = pct)
      )
  )

  return(out)

}
