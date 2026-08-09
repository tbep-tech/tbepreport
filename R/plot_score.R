#' Sunburst plot of indicator, category, and overall outcomes for one bay
#' segment and year
#'
#' @param wqoverall output of \code{\link{anlz_category}} for water quality
#' @param sedoverall output of \code{\link{anlz_category}} for sediment
#' @param fwoverall output of \code{\link{anlz_category}} for fish/wildlife
#' @param haboverall output of \code{\link{anlz_category}} for habitat
#' @param bay_segment chr string, single bay segment to plot
#' @param yr integer, single year to plot
#' @param wt named numeric vector of category weights, passed to
#'   \code{\link{anlz_score}}
#'
#' @details Calls \code{\link{anlz_score}} on the four category data.frames
#' to get the overall bay segment score and each category's own score for
#' \code{bay_segment}/\code{yr}, then plots a three-ring sunburst: a colored
#' center hole for the overall score, a middle ring with one equal-size
#' wedge per category (\code{wq}, \code{sed}, \code{fw}, \code{hab}), and an
#' outer ring with the indicator columns of each of \code{wqoverall},
#' \code{sedoverall}, \code{fwoverall}, \code{haboverall} split evenly
#' within their own category's wedge - regardless of how many indicators
#' another category has. Every ring is colored on the same continuous
#' red/yellow/green outcome scale used by \code{\link{plot_category}}, with
#' missing indicators/categories rendered gray rather than dropped.
#'
#' @returns A \code{plotly} htmlwidget
#'
#' @export
#'
#' @examples
#' wqoverall <- anlz_category(
#'   wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8)
#' )
#' sedoverall <- anlz_category(
#'   sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6)
#' )
#' fwoverall <- anlz_category(
#'   tbni = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7)
#' )
#' haboverall <- anlz_category(
#'   seagrass = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)
#' )
#' plot_score(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB', yr = 2020)
plot_score <- function(wqoverall, sedoverall, fwoverall, haboverall, bay_segment, yr, wt = NULL) {

  cats <- list(wq = wqoverall, sed = sedoverall, fw = fwoverall, hab = haboverall)

  score <- anlz_score(wqoverall, sedoverall, fwoverall, haboverall, wt = wt) |>
    dplyr::filter(.data$bay_segment == !!bay_segment, .data$yr == !!yr)

  if (nrow(score) != 1)
    stop('score must have exactly one row for the chosen bay_segment and yr')

  ids <- 'overall'
  labels <- 'Overall'
  parents <- ''
  values <- length(cats)
  colors <- util_pal_outcome(score$outcome)
  hover <- paste0('Overall: ', scales::percent(score$outcome, accuracy = 1))

  for (cat_nm in names(cats)) {

    cat_outcome <- score[[cat_nm]]

    ids <- c(ids, cat_nm)
    labels <- c(labels, util_lab_format(cat_nm))
    parents <- c(parents, 'overall')
    values <- c(values, 1)
    colors <- c(colors, util_pal_outcome(cat_outcome))
    hover <- c(hover, paste0(
      util_lab_format(cat_nm), ': ',
      ifelse(is.na(cat_outcome), 'No data', scales::percent(cat_outcome, accuracy = 1))
    ))

    cat_df <- cats[[cat_nm]]
    indicator_cols <- util_indicator_cols(cat_df)
    n_ind <- length(indicator_cols)

    if (n_ind == 0)
      next

    cat_row <- cat_df |>
      dplyr::filter(.data$bay_segment == !!bay_segment, .data$yr == !!yr)

    ind_outcomes <- if (nrow(cat_row) == 1) unlist(cat_row[indicator_cols], use.names = FALSE)
      else rep(NA_real_, n_ind)

    ids <- c(ids, paste0(cat_nm, '_', indicator_cols))
    labels <- c(labels, util_lab_format(indicator_cols))
    parents <- c(parents, rep(cat_nm, n_ind))
    values <- c(values, rep(1 / n_ind, n_ind))
    colors <- c(colors, util_pal_outcome(ind_outcomes))
    hover <- c(hover, paste0(
      util_lab_format(indicator_cols), ': ',
      ifelse(is.na(ind_outcomes), 'No data', scales::percent(ind_outcomes, accuracy = 1))
    ))

  }

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
      title         = list(text = paste0(bay_segment, ': ', yr), x = 0.5),
      paper_bgcolor = '#fcfcfb'
    )

  return(fig)

}
