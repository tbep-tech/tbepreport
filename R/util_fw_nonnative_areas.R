#' Bay segment and AOI areas for non-native species density calculations
#'
#' @details Recomputes area from geometry (reprojected to EPSG:3086) rather
#' than using \code{\link{bayseg_shp}}'s static \code{area_ac} attribute,
#' matching the \code{tbep-invasives} Python pipeline's own area calculation
#' method. \code{\link{bayseg_shp}}'s 7 raw segments are dissolved into 5 
#' groups by \code{BAY_SEG_GP} before computing area (i.e., BCB, TCB, MR to RALTB).
#'
#' @returns A named list with \code{bayseg_area_sqmi} (a named numeric
#' vector of area in square miles, one per \code{BAY_SEG_GP} group) and
#' \code{aoi_area_sqmi} (a single number, the total \code{\link{aoi_shp}}
#' area in square miles)
#'
#' @export
#'
#' @examples
#' util_fw_nonnative_areas()
util_fw_nonnative_areas <- function() {

  bayseg_area_sqmi <- bayseg_shp |>
    sf::st_transform(3086) |>
    dplyr::group_by(.data$BAY_SEG_GP) |>
    dplyr::summarise(geometry = sf::st_union(.data$geometry), .groups = 'drop') |>
    dplyr::mutate(area_sqmi = as.numeric(sf::st_area(.data$geometry)) / 4046.8564224 / 640) |>
    sf::st_drop_geometry() |>
    tibble::deframe()

  aoi_area_sqmi <- sum(as.numeric(sf::st_area(sf::st_transform(aoi_shp, 3086)))) / 4046.8564224 / 640

  return(list(bayseg_area_sqmi = bayseg_area_sqmi, aoi_area_sqmi = aoi_area_sqmi))

}
