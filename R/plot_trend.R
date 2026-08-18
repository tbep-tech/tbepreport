#' Faceted trend plot of indicator, category, and overall outcomes over time
#'
#' @param wqoverall output of \code{\link{anlz_category}} for water quality
#' @param sedoverall output of \code{\link{anlz_category}} for sediment
#' @param fwoverall output of \code{\link{anlz_category}} for fish/wildlife
#' @param haboverall output of \code{\link{anlz_category}} for habitat
#' @param bay_segment chr string, single bay segment to plot
#' @param yr_range numeric vector of length 2, \code{c(min, max)} years to
#'   plot (inclusive). Defaults to \code{NULL}, plotting every year
#'   available in \code{wqoverall}, \code{sedoverall}, \code{fwoverall}, and
#'   \code{haboverall}.
#' @param wt named numeric vector of category weights, passed to
#'   \code{\link{anlz_score}}
#' @param facets chr vector, one or more of \code{"Overall"}, \code{"wq"},
#'   \code{"sed"}, \code{"fw"}, \code{"hab"} indicating which facet(s) to
#'   plot. Defaults to all five.
#' @param labels logical, whether to draw direct labels on each line at its
#'   right-most value. Defaults to \code{TRUE}. When \code{FALSE}, the
#'   extra right-margin/x-axis space reserved for labels is also removed.
#'
#' @details Calls \code{\link{anlz_score}} on the four category data.frames
#' to get the overall bay segment score and each category's own score across
#' all years for \code{bay_segment}, then plots up to five stacked facets
#' (one column, top to bottom, or a subset via \code{facets}): an "Overall"
#' facet with the bay segment score and one colored line per category
#' (\code{wq}, \code{sed}, \code{fw}, \code{hab}), followed by one facet per
#' category with that category's own score and one colored line per
#' indicator column of \code{wqoverall}, \code{sedoverall}, \code{fwoverall},
#' \code{haboverall}. In every facet, the score itself is drawn as a thick
#' dark "Score" line and each component (category or indicator) is a
#' thinner colored line, labeled directly at its right-most value when
#' \code{labels = TRUE}.
#'
#' @returns A \code{ggplot} object
#'
#' @export
#'
#' @examples
#' wqoverall <- anlz_category(
#'   wq_attain = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.6, 0.7, 0.8))
#' )
#' sedoverall <- anlz_category(
#'   sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.5, 0.6, 0.6))
#' )
#' fwoverall <- anlz_category(
#'   tbni = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.7, 0.65, 0.7))
#' )
#' haboverall <- anlz_category(
#'   seagrass = data.frame(bay_segment = 'OTB', yr = 2018:2020, outcome = c(0.4, 0.5, 0.5))
#' )
#' plot_trend(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB')
#'
#' # a single facet, with labels turned off
#' plot_trend(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB',
#'             facets = 'Overall', labels = FALSE)
plot_trend <- function(wqoverall, sedoverall, fwoverall, haboverall, bay_segment, yr_range = NULL,
                        wt = NULL, facets = c('Overall', 'wq', 'sed', 'fw', 'hab'), labels = TRUE) {

  cats <- list(wq = wqoverall, sed = sedoverall, fw = fwoverall, hab = haboverall)

  facets <- match.arg(facets, choices = c('Overall', names(cats)), several.ok = TRUE)

  score <- anlz_score(wqoverall, sedoverall, fwoverall, haboverall, wt = wt) |>
    dplyr::filter(.data$bay_segment == !!bay_segment)

  if (!is.null(yr_range)) {
    score <- dplyr::filter(score, .data$yr >= yr_range[1], .data$yr <= yr_range[2])
    cats  <- purrr::map(cats, function(x) {
      dplyr::filter(x, .data$yr >= yr_range[1], .data$yr <= yr_range[2])
    })
  }

  if (nrow(score) == 0)
    stop('bay_segment/yr_range combination has no rows in the combined score')

  overall_long <- score |>
    dplyr::select(dplyr::all_of(c('yr', 'outcome', names(cats)))) |>
    tidyr::pivot_longer(cols = -'yr', names_to = 'series', values_to = 'value') |>
    dplyr::mutate(
      facet  = 'Overall',
      role   = ifelse(.data$series == 'outcome', 'parent', 'child'),
      series = ifelse(.data$series == 'outcome', 'Score', util_lab_format(.data$series))
    )

  cat_long <- purrr::imap(cats, function(cat_df, cat_nm) {
    indicator_cols <- util_indicator_cols(cat_df)

    cat_df |>
      dplyr::filter(.data$bay_segment == !!bay_segment) |>
      dplyr::select(dplyr::all_of(c('yr', 'outcome', indicator_cols))) |>
      tidyr::pivot_longer(cols = -'yr', names_to = 'series', values_to = 'value') |>
      dplyr::mutate(
        facet  = util_lab_format(cat_nm),
        role   = ifelse(.data$series == 'outcome', 'parent', 'child'),
        series = ifelse(.data$series == 'outcome', 'Score', util_lab_format(.data$series))
      )
  }) |>
    dplyr::bind_rows()

  toplo <- dplyr::bind_rows(overall_long, cat_long) |>
    dplyr::mutate(facet = factor(.data$facet, levels = c('Overall', util_lab_format(names(cats)))))

  facet_labs <- c(Overall = 'Overall', stats::setNames(util_lab_format(names(cats)), names(cats)))
  toplo <- toplo |>
    dplyr::filter(.data$facet %in% facet_labs[facets]) |>
    dplyr::mutate(facet = factor(.data$facet, levels = intersect(levels(.data$facet), unique(.data$facet))))

  child_series <- sort(unique(toplo$series[toplo$role == 'child']))
  pal <- stats::setNames(scales::hue_pal()(length(child_series)), child_series)
  pal <- c(pal, Score = 'grey15')

  lastpt <- toplo |>
    dplyr::filter(!is.na(.data$value)) |>
    dplyr::group_by(.data$facet, .data$series) |>
    dplyr::filter(.data$yr == max(.data$yr)) |>
    dplyr::ungroup()

  xexpand <- if (labels) ggplot2::expansion(mult = c(0.02, 0.3)) else ggplot2::expansion(mult = c(0.02, 0.05))
  rmargin <- if (labels) 80 else 5

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = .data$yr, y = .data$value, color = .data$series)) +
    ggplot2::geom_line(
      data = ~ dplyr::filter(.x, .data$role == 'child'), ggplot2::aes(group = .data$series),
      linewidth = 0.7
    ) +
    ggplot2::geom_line(
      data = ~ dplyr::filter(.x, .data$role == 'parent'), ggplot2::aes(group = .data$series),
      linewidth = 1.1
    ) +
    (if (labels) ggrepel::geom_text_repel(
      data = lastpt, ggplot2::aes(label = .data$series, fontface = .data$role),
      hjust = 0, direction = 'y', xlim = c(NA, Inf), size = 3,
      segment.size = 0.3, min.segment.length = 0, box.padding = 0.2,
      force = 3, force_pull = 0.5, max.overlaps = Inf, seed = 1
    )) +
    ggplot2::facet_wrap(~.data$facet, ncol = 1) +
    ggplot2::scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
    ggplot2::scale_x_continuous(expand = xexpand) +
    ggplot2::scale_color_manual(values = pal, guide = 'none') +
    ggplot2::scale_discrete_manual(
      aesthetics = 'fontface', values = c(parent = 'bold', child = 'plain'), guide = 'none'
    ) +
    ggplot2::coord_cartesian(clip = 'off') +
    ggplot2::labs(title = bay_segment, x = NULL, y = 'Outcome') +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = 'none',
      plot.margin = ggplot2::margin(r = rmargin, t = 5, b = 5, l = 5)
    )

  return(p)

}
