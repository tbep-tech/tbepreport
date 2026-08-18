#' Sunburst plot of indicator outcomes for one category, bay segment, and year
#'
#' @param ... named data.frames, passed to \code{\link{anlz_category}}. See
#'   its documentation (and \code{\link{anlz_indicators}}) for the expected
#'   shape
#' @param bay_segment chr string, single bay segment to plot, must be one of
#'   \code{bay_segments}
#' @param yr integer, single year to plot
#' @param bay_segments chr vector of bay segments to include, passed to
#'   \code{\link{anlz_category}}, defaults to \code{c('OTB', 'HB', 'MTB', 'LTB')}
#' @param yr_min integer, minimum year to include, passed to
#'   \code{\link{anlz_category}}, defaults to \code{2000}
#' @param wt named numeric vector of indicator weights, passed to
#'   \code{\link{anlz_category}}
#'
#' @details Calls \code{\link{anlz_category}} on \code{...} to get both the
#' per-indicator outcomes (one wide column per indicator) and the overall
#' category score for \code{bay_segment}/\code{yr}, then plots a two-ring
#' sunburst using a colored center for the category's overall
#' \code{outcome} and an outer ring with one equal-size wedge per
#' indicator colored by that indicator's own outcome. Both rings use the
#' same continuous red/yellow/green outcome scale, and an indicator missing
#' for \code{bay_segment}/\code{yr} still gets an equal-size wedge, rendered
#' gray rather than dropped. Thematically identical to
#' \code{\link{plot_score}}, which extends this same two-ring layout with a
#' third ring combining several categories.
#'
#' @returns A \code{plotly} htmlwidget
#'
#' @export
#'
#' @examples
#' plot_category(
#'   wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8),
#'   fib = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.4),
#'   bay_segment = 'OTB', yr = 2020
#' )
plot_category <- function(..., bay_segment, yr, bay_segments = c('OTB', 'HB', 'MTB', 'LTB'),
                           yr_min = 2000, wt = NULL) {

  category <- anlz_category(..., bay_segments = bay_segments, yr_min = yr_min, wt = wt)

  row <- category |>
    dplyr::filter(.data$bay_segment == !!bay_segment, .data$yr == !!yr)

  if (nrow(row) != 1)
    stop('category must have exactly one row for the chosen bay_segment and yr')

  indicator_cols <- util_indicator_cols(category)
  n_ind <- length(indicator_cols)
  ind_outcomes <- unlist(row[indicator_cols], use.names = FALSE)

  ids <- c('score', indicator_cols)
  labels <- c('Score', util_lab_format(indicator_cols))
  parents <- c('', rep('score', n_ind))
  values <- c(n_ind, rep(1, n_ind))
  colors <- c(util_pal_outcome(row$outcome), util_pal_outcome(ind_outcomes))
  hover <- c(
    paste0('Score: ', scales::percent(row$outcome, accuracy = 1)),
    paste0(
      util_lab_format(indicator_cols), ': ',
      ifelse(is.na(ind_outcomes), 'No data', scales::percent(ind_outcomes, accuracy = 1))
    )
  )

  fig <- plotly::plot_ly(
    ids          = ids,
    labels       = labels,
    parents      = parents,
    values       = values,
    type         = 'sunburst',
    branchvalues = 'total',
    marker       = list(colors = colors, line = list(color = 'white', width = 1)),
    text         = hover,
    hoverinfo    = 'text',
    textinfo     = 'text'
  ) |>
    plotly::layout(
      title         = list(text = paste0(bay_segment, ': ', yr), x = 0.5, xanchor = 'center', xref = 'paper'),
      paper_bgcolor = '#fcfcfb'
    )

  return(fig)

}
