#' Convert raw indicator values to a 0-1 outcome score
#'
#' @param x vector of raw values to convert
#' @param type chr string indicating how to interpret \code{x}:
#'   \code{"continuous"} rescales a continuous value, \code{"threshold"}
#'   compares against a cutoff, \code{"category"} maps discrete categories to
#'   fixed outcome values
#' @param from numeric vector of length 2, the \code{c(min, max)} range of
#'   \code{x} to rescale from when \code{type = "continuous"}. Defaults to
#'   \code{range(x, na.rm = TRUE)}.
#' @param reverse logical, if \code{TRUE} the outcome is flipped
#'   (\code{1 - outcome}) so a higher raw value in \code{x} indicates a worse
#'   outcome. Applies to \code{type = "continuous"} and
#'   \code{type = "threshold"}.
#' @param thresh numeric, the cutoff value to compare \code{x} against when
#'   \code{type = "threshold"}
#' @param op chr string, one of \code{"<"}, \code{"<="}, \code{">"},
#'   \code{">="} - the comparison defining the condition under which \code{x}
#'   attains an outcome of 1 when \code{type = "threshold"}
#' @param smooth logical, if \code{TRUE} and \code{type = "threshold"}, use a
#'   smooth logistic transition centered at \code{thresh} (in the direction
#'   given by \code{op}) instead of a hard cutoff (see Details)
#' @param scl numeric, controls the steepness of the logistic transition when
#'   \code{smooth = TRUE} - smaller values are a sharper transition. Defaults
#'   to 10% of \code{abs(thresh)} (or \code{1} if \code{thresh = 0}).
#' @param levels named numeric vector mapping each category value in \code{x}
#'   to a fixed outcome when \code{type = "category"}, e.g.
#'   \code{c(Poor = 0, Fair = 0.5, Good = 1)}. Values of \code{x} not found in
#'   \code{levels} return \code{NA}.
#'
#' @details
#' This is meant as the single point of modification for how a raw indicator
#' value becomes a 0-1 outcome, since that conversion is expected to change
#' as individual indicators are refined (e.g. moving a category-based
#' indicator to use its underlying continuous value instead, or a hard
#' threshold to a smooth one) without needing to change every \code{anlz_*}
#' function that calls it.
#'
#' \strong{continuous}: \code{x} is linearly rescaled from \code{from} to
#' \code{c(0, 1)} with \code{\link[scales]{rescale}}, then clamped to
#' \code{c(0, 1)} - values of \code{x} outside \code{from} are pinned to
#' \code{0} or \code{1} rather than extrapolated. This lets \code{from} act
#' as a transition window narrower than the full range of \code{x} (e.g.
#' TBNI's 32-46 breakpoints within its 0-100 score).
#'
#' \strong{threshold}: by default, \code{x} is compared to \code{thresh}
#' using \code{op} and converted to a hard \code{0}/\code{1}. Setting
#' \code{smooth = TRUE} instead applies a logistic function centered at
#' \code{thresh}, so outcomes near the threshold transition gradually rather
#' than jumping discretely, in the same direction \code{op} would have used
#' (e.g. \code{op = "<"} still means lower \code{x} is better).
#'
#' \strong{category}: \code{x} is mapped to an outcome via \code{levels}.
#'
#' In all cases, \code{reverse = TRUE} flips the result so a higher raw value
#' in \code{x} corresponds to a lower (worse) outcome.
#'
#' @returns A numeric vector the same length as \code{x}, with values from 0
#'   to 1 (\code{1} = best).
#'
#' @export
#'
#' @examples
#' # continuous, e.g. TBNI scores from 0-100
#' util_outcome(c(20, 46, 90), type = 'continuous', from = c(0, 100))
#'
#' # continuous with a narrower transition window, e.g. TBNI's 32-46
#' # breakpoints - values outside the window are clamped to 0/1
#' util_outcome(c(20, 32, 39, 46, 60), type = 'continuous', from = c(32, 46))
#'
#' # threshold, e.g. chlorophyll attainment (lower is better)
#' util_outcome(c(5, 15), type = 'threshold', thresh = 10, op = '<')
#'
#' # threshold with a smooth transition instead of a hard cutoff
#' util_outcome(c(5, 10, 15), type = 'threshold', thresh = 10, smooth = TRUE)
#'
#' # category, e.g. FIB grades
#' util_outcome(c('A', 'C', 'E'), type = 'category',
#'   levels = c(A = 1, B = 0.75, C = 0.5, D = 0.25, E = 0))
util_outcome <- function(x, type = c('continuous', 'threshold', 'category'), from = NULL,
                          reverse = FALSE, thresh = NULL, op = '<', smooth = FALSE, scl = NULL,
                          levels = NULL) {

  type <- match.arg(type)

  if (type == 'continuous') {

    if (is.null(from))
      from <- range(x, na.rm = TRUE)

    out <- scales::rescale(x, to = c(0, 1), from = from)
    out <- pmin(pmax(out, 0), 1)

  }

  if (type == 'threshold') {

    if (is.null(thresh))
      stop('thresh must be provided when type = "threshold"')

    op <- match.arg(op, c('<', '<=', '>', '>='))

    if (smooth) {

      if (is.null(scl))
        scl <- ifelse(thresh != 0, 0.1 * abs(thresh), 1)

      # sgn flips the logistic so it transitions in the same direction op
      # would have used (e.g. op = '<' still means lower x is better)
      sgn <- ifelse(op %in% c('<', '<='), 1, -1)
      out <- 1 / (1 + exp(sgn * (x - thresh) / scl))

    } else {

      out <- switch(op,
        '<'  = as.numeric(x < thresh),
        '<=' = as.numeric(x <= thresh),
        '>'  = as.numeric(x > thresh),
        '>=' = as.numeric(x >= thresh)
      )

    }

  }

  if (type == 'category') {

    if (is.null(levels))
      stop('levels must be provided when type = "category"')

    out <- unname(levels[as.character(x)])

  }

  if (reverse)
    out <- 1 - out

  out

}
