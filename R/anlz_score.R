#' Overall bay segment score across all four indicator categories
#'
#' @param wqoverall output of \code{\link{anlz_category}} for water quality
#' @param sedoverall output of \code{\link{anlz_category}} for sediment
#' @param fwoverall output of \code{\link{anlz_category}} for fish/wildlife
#' @param haboverall output of \code{\link{anlz_category}} for habitat
#' @param wt named numeric vector of category weights, e.g.
#'   \code{c(wq = 2, sed = 1, fw = 1, hab = 1)}. Categories not named in
#'   \code{wt} - including all of them when \code{wt = NULL} - get a weight
#'   of \code{1}, so the default is a plain unweighted mean across the four
#'   categories, passed straight through to \code{\link{anlz_category}}.
#'
#' @details A thin, semantically-named wrapper around
#' \code{\link{anlz_category}}: from that function's point of view, a
#' category score is just another single-indicator input, so combining the
#' four category scores into one bay segment score uses exactly the same
#' stacking (\code{\link{anlz_indicators}}) and weighted-averaging logic
#' that combines individual indicators into a category score.
#'
#' @returns A data.frame with columns \code{bay_segment}, \code{yr},
#' \code{outcome} (0-1, 1 = best - the overall Bay Segment Score), and
#' \code{n_indicator} (number of categories with a score for that
#' segment/year)
#'
#' @export
#'
#' @examples
#' wqoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8)
#' sedoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6)
#' fwoverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7)
#' haboverall <- data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)
#' anlz_score(wqoverall, sedoverall, fwoverall, haboverall)
anlz_score <- function(wqoverall, sedoverall, fwoverall, haboverall, wt = NULL) {

  anlz_category(wq = wqoverall, sed = sedoverall, fw = fwoverall, hab = haboverall, wt = wt)

}
