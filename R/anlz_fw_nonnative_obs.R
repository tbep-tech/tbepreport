#' Non-native species occurrence points, clipped and assigned to a bay segment
#'
#' @param huc8_list chr vector of HUC8 codes, passed to
#'   \code{\link{util_fw_fetch_nas}}
#' @param fim_url chr string, FIM data URL, passed to
#'   \code{\link{util_fw_fetch_fim}}
#' @param min_yr integer, earliest year to include, defaults to \code{2000}
#'
#' @details Combines \code{\link{util_fw_fetch_nas}} and
#' \code{\link{util_fw_fetch_fim}}, filters to \code{yr >= min_yr} and
#' non-missing coordinates, then clips to the \code{\link{aoi_shp}} boundary
#' and spatially joins each point to a \code{bay_segment} using
#' \code{\link{bayseg_shp}}'s \code{BAY_SEG_GP} grouping. This is the shared,
#' network-heavy step behind \code{\link{anlz_fw_nonnative_abundance}} and
#' \code{\link{anlz_fw_nonnative_richness}}, computed once and passed to 
#' both rather than letting each re-fetch.
#'
#' @returns A data.frame with columns \code{scientificName}, \code{commonName},
#' \code{group}, \code{year}, \code{lon}, \code{lat}, \code{source}, and
#' \code{bay_segment} (full segment name, e.g. \code{"Old Tampa Bay"}). Each
#' row is one occurrence point that fell within the AOI and a bay segment
#'
#' @export
#'
#' @examples
#' \dontrun{
#' anlz_fw_nonnative_obs()
#' }
anlz_fw_nonnative_obs <- function(
    huc8_list = c(
      '03100101', '03100201', '03100202', '03100203',
      '03100204', '03100205', '03100206', '03100207', '03100208'
    ),
    fim_url = 'https://github.com/kflahertywalia/tb_fim_nonnatives/raw/refs/heads/main/Output/tb_fim_inv.RData',
    min_yr = 2000
  ) {

  obs <- dplyr::bind_rows(
    util_fw_fetch_nas(huc8_list),
    util_fw_fetch_fim(fim_url)
  ) |>
    dplyr::filter(.data$year >= min_yr, !is.na(.data$lon), !is.na(.data$lat))

  bayseg <- bayseg_shp |>
    dplyr::select(dplyr::all_of('BAY_SEG_GP')) |>
    dplyr::rename(bay_segment = dplyr::all_of('BAY_SEG_GP'))

  out <- obs |>
    sf::st_as_sf(coords = c('lon', 'lat'), crs = 4326, remove = FALSE) |>
    sf::st_filter(aoi_shp, .predicate = sf::st_intersects) |>
    sf::st_join(bayseg, join = sf::st_within) |>
    sf::st_drop_geometry() |>
    dplyr::filter(!is.na(.data$bay_segment))

  return(out)

}
