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
#'   outcome.
#' @param thresh numeric, the cutoff value to compare \code{x} against when
#'   \code{type = "threshold"}
#' @param op chr string, one of \code{"<"}, \code{"<="}, \code{">"},
#'   \code{">="}. Defines the condition under which \code{x}
#'   attains an outcome of 1 when \code{type = "threshold"}
#' @param smooth for \code{type = "threshold"}, one of \code{"logistic"}
#'   (the default), \code{"ramp"}, or \code{"none"}. See Details.
#' @param pct numeric, the fraction of \code{abs(thresh)} used as the
#'   steepness of the \code{"logistic"}/\code{"ramp"} transition when
#'   \code{smooth} is one of those. Smaller values give a sharper
#'   transition. Defaults to \code{0.1} (10% of \code{thresh}).
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
#' \code{c(0, 1)}. Values of \code{x} outside \code{from} are pinned to
#' \code{0} or \code{1} rather than extrapolated. This lets \code{from} act
#' as a transition window narrower than the full range of \code{x} (e.g.
#' TBNI's 32-46 breakpoints within its 0-100 score).
#'
#' \strong{threshold}: \code{x} is compared to \code{thresh} using \code{op},
#' in one of three ways selected by \code{smooth}:
#' \itemize{
#'   \item \code{"logistic"} (the default): a smooth logistic transition
#'     centered at \code{thresh}, exactly \code{0.5} at \code{thresh}
#'     and approaching \code{0}/\code{1} on either side, in the direction
#'     \code{op} would have used (e.g. \code{op = "<"} still means lower
#'     \code{x} is better).
#'   \item \code{"ramp"}: \code{1} once \code{x} reaches the "good" side of
#'     \code{thresh} (as defined by \code{op}). This is not just \code{0.5}
#'     there like \code{"logistic"}. It decays exponentially toward
#'     \code{0} the further \code{x} is on the "bad" side. Use this when
#'     meeting or beating a target should already be full credit rather
#'     than half credit (e.g. an acreage target that's fine to exceed by
#'     any amount).
#'   \item \code{"none"}: a hard \code{0}/\code{1} cutoff, no transition.
#' }
#' For \code{"logistic"} and \code{"ramp"}, the steepness of the transition
#' is a percentage (\code{pct}) of \code{thresh} rather than a fixed
#' absolute value, so it stays meaningful across indicators/thresholds with
#' very different units and magnitudes (e.g. a threshold of 1 vs. a
#' threshold in the hundreds).
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
#' # breakpoints. Values outside the window are clamped to 0/1
#' util_outcome(c(20, 32, 39, 46, 60), type = 'continuous', from = c(32, 46))
#'
#' # threshold, e.g. chlorophyll attainment (lower is better). Smooth by
#' # default, a logistic transition rather than a hard cutoff
#' util_outcome(c(5, 10, 15), type = 'threshold', thresh = 10)
#'
#' # a larger pct widens the transition (steepness relative to thresh)
#' util_outcome(12, type = 'threshold', thresh = 10, pct = 0.1)
#' util_outcome(12, type = 'threshold', thresh = 10, pct = 0.2)
#'
#' # smooth = "none" instead gives a hard 0/1 cutoff
#' util_outcome(c(5, 15), type = 'threshold', thresh = 10, op = '<', smooth = 'none')
#'
#' # smooth = "ramp": meeting/beating a target (op = ">=") is full credit,
#' # decaying toward 0 the further short of it a value falls
#' util_outcome(c(90, 95, 100, 105), type = 'threshold', thresh = 100, op = '>=', smooth = 'ramp')
#'
#' # category, e.g. FIB grades
#' util_outcome(c('A', 'C', 'E'), type = 'category',
#'   levels = c(A = 1, B = 0.75, C = 0.5, D = 0.25, E = 0))
util_outcome <- function(x, type = c('continuous', 'threshold', 'category'), from = NULL,
                          reverse = FALSE, thresh = NULL, op = '<', smooth = 'logistic',
                          pct = 0.1, levels = NULL) {

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

    smooth <- match.arg(smooth, c('logistic', 'ramp', 'none'))

    if (smooth == 'none') {

      out <- switch(op,
        '<'  = as.numeric(x < thresh),
        '<=' = as.numeric(x <= thresh),
        '>'  = as.numeric(x > thresh),
        '>=' = as.numeric(x >= thresh)
      )

    } else {

      scl <- ifelse(thresh != 0, pct * abs(thresh), 1)

      # sgn flips the transition so it moves in the same direction op
      # would have used (e.g. op = '<' still means lower x is better)
      sgn <- ifelse(op %in% c('<', '<='), 1, -1)

      if (smooth == 'logistic') {

        out <- 1 / (1 + exp(sgn * (x - thresh) / scl))

      } else if (smooth == 'ramp') {

        # 1 once x reaches the "good" side of thresh, decaying
        # exponentially toward 0 the further x is on the "bad" side
        d <- pmax(sgn * (x - thresh), 0)
        out <- exp(-d / scl)

      }

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
