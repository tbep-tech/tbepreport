#' Seagrass transect frequency of occurrence outcome by bay segment and year
#'
#' @param transect data.frame of raw seagrass transect data, e.g.
#'   \code{tbeptools::transect}
#'
#' @details Uses [`anlz_transectocc`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectocc.html) and
#' [`anlz_transectave`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectave.html) to estimate frequency of
#' seagrass occurrence (\code{foest}, 0-100) at each bay segment/year,
#' drops the bay-wide \code{"All"} aggregate row, then converts to a 0-1
#' outcome with \code{\link{util_outcome}} (\code{type = "continuous"},
#' \code{from = c(0, 100)}).
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{foest} (frequency of occurrence estimate, 0-100), and
#' \code{outcome} (0-1, 1 = best)
#'
#' @export
#'
#' @examples
#' anlz_hab_seagrass_transect(tbeptools::transect)
anlz_hab_seagrass_transect <- function(transect) {

  out <- transect |>
    tbeptools::anlz_transectocc() |>
    tbeptools::anlz_transectave() |>
    dplyr::filter(.data$bay_segment != 'All') |>
    dplyr::mutate(
      bay_segment = as.character(.data$bay_segment),
      outcome = util_outcome(.data$foest, type = 'continuous', from = c(0, 100))
    ) |>
    dplyr::select(dplyr::all_of(c('bay_segment', 'yr', 'foest', 'outcome')))

  return(out)

}
