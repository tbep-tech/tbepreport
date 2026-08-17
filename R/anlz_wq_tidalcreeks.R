#' Tidal creek condition outcome by bay segment and year
#'
#' @param tidalcreeks sf object of tidal creek assessment segments, e.g.
#'   \code{tbeptools::tidalcreeks}
#' @param iwrraw data.frame of raw IWR water quality data for tidal creeks,
#'   e.g. \code{tbeptools::iwrraw}
#' @param yrs integer vector of years to assess, passed to
#'   \code{\link[tbeptools]{anlz_tdlcrk}}
#'
#' @details Each tidal creek is assigned to the bay segment subwatershed
#' (\code{\link[tbeptools]{tbsegshed}}) it overlaps most (by length, for
#' creeks spanning more than one subwatershed).
#'
#' \code{\link[tbeptools]{anlz_tdlcrk}} computes each creek's condition
#' category (Prioritize/Investigate/Caution/Monitor) from counts of how many
#' years, out of a rolling 10-year window, its TN concentration fell into
#' each of 4 ordinal grades (\code{monitor}, \code{caution},
#' \code{investigate}, \code{prioritize}, worst to best) - the category
#' itself comes from a compound rule (the worst grade present usually wins,
#' with several count-based exceptions that downgrade it, e.g. a single bad
#' year surrounded by mostly good years). Rather than use that category,
#' this converts each creek's own 4 counts directly into a continuous 0-1
#' score - the same count-weighted average across the same ordinal scale
#' the category uses (\code{Monitor = 1}, \code{Caution = 2/3},
#' \code{Investigate = 1/3}, \code{Prioritize = 0}), i.e. what fraction of
#' the 10-year window fell in each grade. This is a related but distinct
#' measure from the official category - it can disagree in some cases,
#' since the category's downgrade exceptions are non-monotonic and a
#' count-weighted average won't reproduce them (e.g. a creek with a single
#' Prioritize-level year among mostly Monitor-level years can score higher
#' continuously than a creek with several Caution-level years, even though
#' the latter is categorized as the less severe "Caution" rather than
#' "Prioritize"). Creeks with a "No Data" assessment (no counts at all) are
#' dropped.
#'
#' Each creek's continuous score is then averaged to a bay-segment/year
#' outcome, weighted by each creek's physical length so longer creek
#' segments contribute proportionally more.
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{outcome} (0-1, 1 = best), and \code{n_assessed} (number of creek
#' records feeding that segment/year's outcome)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' anlz_wq_tidalcreeks(tbeptools::tidalcreeks, tbeptools::iwrraw, yrs = 2015:2020)
#' }
anlz_wq_tidalcreeks <- function(tidalcreeks, iwrraw, yrs) {

  trnds <- tibble::tibble(yrs = yrs) |>
    dplyr::group_nest(.data$yrs) |>
    dplyr::mutate(
      data = purrr::map(.data$yrs, function(x) tbeptools::anlz_tdlcrk(tidalcreeks, iwrraw, yr = x))
    )

  tcseg <- tidalcreeks |>
    sf::st_transform(sf::st_crs(tbeptools::tbsegshed)) |>
    dplyr::select(dplyr::all_of('id')) |>
    sf::st_intersection(tbeptools::tbsegshed |> dplyr::select(dplyr::all_of('bay_segment'))) |>
    dplyr::mutate(complen = sf::st_length(.data$geometry)) |>
    sf::st_drop_geometry() |>
    dplyr::group_by(.data$id) |>
    dplyr::slice_max(.data$complen, n = 1, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::select(dplyr::all_of(c('id', 'bay_segment')))

  tctrnds <- trnds |>
    tidyr::unnest('data') |>
    dplyr::inner_join(tcseg, by = 'id')

  crklevs <- c('Prioritize' = 0, 'Investigate' = 1 / 3, 'Caution' = 2 / 3, 'Monitor' = 1)

  out <- tctrnds |>
    dplyr::left_join(
      tidalcreeks |> sf::st_drop_geometry() |> dplyr::select(dplyr::all_of(c('id', 'Creek_Length_m'))),
      by = 'id'
    ) |>
    dplyr::filter(.data$score %in% names(crklevs)) |>
    dplyr::mutate(
      dplyr::across(dplyr::all_of(c('monitor', 'caution', 'investigate', 'prioritize')), ~ dplyr::coalesce(.x, 0)),
      totyrs = .data$monitor + .data$caution + .data$investigate + .data$prioritize,
      scoreval = (.data$monitor * crklevs[['Monitor']] + .data$caution * crklevs[['Caution']] +
                    .data$investigate * crklevs[['Investigate']] + .data$prioritize * crklevs[['Prioritize']]) /
        .data$totyrs
    ) |>
    dplyr::group_by(.data$bay_segment, .data$yrs) |>
    dplyr::summarise(
      outcome = stats::weighted.mean(.data$scoreval, w = .data$Creek_Length_m, na.rm = TRUE),
      n_assessed = dplyr::n(),
      .groups = 'drop'
    ) |>
    dplyr::rename(yr = dplyr::all_of('yrs'))

  return(out)

}
