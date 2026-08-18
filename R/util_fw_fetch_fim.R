#' Fetch the Tampa Bay FIM species dataset
#'
#' @param fim_url chr string, the URL of the FIM species RData
#'   file, defaults to the
#'   \href{https://github.com/kflahertywalia/tb_fim_nonnatives}{tb_fim_nonnatives}
#'   repo's output
#'
#' @details Downloads and parses the FIM RData file directly (not via
#' \code{\link{util_rdataload}}). Only \code{Fish}/\code{Turtle}
#' taxa are present in this dataset. They're recoded to \code{Fishes}/
#' \code{Reptiles} to match \code{\link{util_fw_fetch_nas}}'s group names.
#' Year is recovered from the \code{Reference} field.
#'
#' @returns A data.frame with columns \code{scientificName}, \code{commonName},
#' \code{group}, \code{year}, \code{lon}, \code{lat}, and \code{source}
#' (always \code{"FIM"})
#'
#' @export
#'
#' @examples
#' \dontrun{
#' util_fw_fetch_fim()
#' }
util_fw_fetch_fim <- function(fim_url = 'https://github.com/kflahertywalia/tb_fim_nonnatives/raw/refs/heads/main/Output/tb_fim_inv.RData') {

  fim_tf <- tempfile(fileext = '.RData')
  on.exit(unlink(fim_tf), add = TRUE)
  utils::download.file(fim_url, fim_tf, mode = 'wb', quiet = TRUE)
  load(fim_tf)

  out <- get('inv') |>
    dplyr::transmute(
      scientificName = .data$Scientificname,
      commonName     = .data$Commonname,
      group          = dplyr::recode(.data$Taxa_Type, Fish = 'Fishes', Turtle = 'Reptiles'),
      year           = as.integer(substr(.data$Reference, 4, 7)),
      lon            = as.numeric(.data$Longitude),
      lat            = as.numeric(.data$Latitude),
      source         = 'FIM'
    )

  return(out)

}
