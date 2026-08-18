#' Benthic index (TBBI) outcome by bay segment and year
#'
#' @param benthicdata raw benthic monitoring data, e.g.
#'   \code{tbeptools::benthicdata}
#'
#' @details Uses [`anlz_tbbiscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbiscr.html) to get station-level
#' TBBI scores (0-100), filtered to the same stations
#' [`anlz_tbbimed`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.html) uses for its bay segment grades
#' (\code{FundingProject == "TBEP"}, \code{ProgramID == 4}, and
#' \code{TBBI} between 0 and 100, for the 7 bay segments
#' [`anlz_tbbimed`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.html) scores), then takes the median
#' station score for each bay segment/year. \code{outcome} comes directly
#' from that continuous median via \code{\link{util_outcome}} (\code{type =
#' "continuous"}, \code{from = c(73, 87)}), TBBI's own grade breakpoints
#' (Degraded below 73, Intermediate 73-87, Healthy above 87). This is the
#' same clamped-breakpoint-window treatment used for the Nekton Index's
#' \code{from = c(32, 46)}.
#'
#' This bypasses [`anlz_tbbimed`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.html) entirely, which
#' instead grades a bay segment/year Poor/Fair/Good from the
#' \emph{proportion} of its stations falling in each of the
#' Degraded/Intermediate/Healthy categories. This is a compound rule on
#' those proportions, not a discretized version of a single continuous
#' statistic, so there's no direct continuous equivalent of it the way
#' there is for TBNI's or PEL/TEL's breakpoints. Scoring the median of the
#' raw station values instead is a related but distinct measure. It can
#' disagree with [`anlz_tbbimed`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.html)'s category in some
#' edge cases (e.g.
#' a bay segment split between many Healthy and a few very Degraded
#' stations can have a middling median while still tripping the proportion
#' rule's \code{Degraded >= 0.2} condition for \code{"Poor"}).
#'
#' @returns A data.frame with columns \code{yr}, \code{bay_segment},
#' \code{TBBI} (median station-level score for that bay segment/year), and
#' \code{outcome} (0-1, 1 = best)
#'
#' @export
#'
#' @examples
#' anlz_sed_tbbi(tbeptools::benthicdata)
anlz_sed_tbbi <- function(benthicdata) {

  segs <- c('OTB', 'HB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')

  out <- benthicdata |>
    tbeptools::anlz_tbbiscr() |>
    dplyr::rename(bay_segment = dplyr::all_of('AreaAbbr')) |>
    dplyr::filter(
      .data$bay_segment %in% segs,
      .data$FundingProject == 'TBEP',
      .data$ProgramID == 4,
      .data$TBBI >= 0, .data$TBBI <= 100
    ) |>
    dplyr::group_by(.data$bay_segment, .data$yr) |>
    dplyr::summarise(TBBI = stats::median(.data$TBBI, na.rm = TRUE), .groups = 'drop') |>
    dplyr::mutate(
      bay_segment = as.character(.data$bay_segment),
      outcome = util_outcome(.data$TBBI, type = 'continuous', from = c(73, 87))
    ) |>
    dplyr::select(dplyr::all_of(c('yr', 'bay_segment', 'TBBI', 'outcome')))

  return(out)

}
