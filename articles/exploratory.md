# Exploratory Analysis for TB Report Card

Indicators: \* Water Quality \* chla, water clarity \* loading \* tidal
creeks \* FIBs \* Sediment \* TBBI/AMBI \* PEL/TEL \* Fish/Wildlife \*
TBNI \* Nonnatives \* Habitat \* Seagrass \* LULC change/habitat report
card

## Water Quality

``` r

wqattain <- anlz_wq_attain(epcdata)
wqthresh <- anlz_wq_thresh(epcdata)

totanndat <- util_rdataload("https://github.com/tbep-tech/load-estimates/raw/main/data/totanndat.RData")
wqload <- anlz_wq_load(totanndat)

wqtidalcreeks <- anlz_wq_tidalcreeks(tidalcreeks, iwrraw, yrs = 1975:2024)

wqfib <- anlz_wq_fib(enterodata)
```

``` r

wqindic <- anlz_indicators(
  wq_attain    = wqattain,
  thresh       = wqthresh,
  load         = wqload,
  tidal_creeks = wqtidalcreeks,
  fib          = wqfib
)
wqoverall <- anlz_category(wq = wqindic)
```

``` r

# interactive "flower" plot for a single year: one polar bar (coxcomb)
# chart per bay segment, arranged 2x2. Each equal-angle petal is a
# component indicator (length/color = its 0-1 outcome) and the colored
# center hole is that segment's overall wqoverall score - the petals give
# context for what's driving the number in the middle. Any indicator
# missing for a segment/year (none in 2025) renders as a short gray "No
# data" petal rather than breaking the equal-angle layout
plotyr <- 2024

indic_labs <- c(
  wq_attain    = 'WQ Attain',
  chla_thresh  = 'Chl-a',
  la_thresh    = 'Light',
  tn_load      = 'TN Load',
  tnhy_load    = 'Hydro',
  tidal_creeks = 'Creeks',
  fib          = 'FIB'
)

segorder <- c('OTB', 'HB', 'MTB', 'LTB')
seglabs <- c(
  OTB = 'Old Tampa Bay',
  HB  = 'Hillsborough Bay',
  MTB = 'Middle Tampa Bay',
  LTB = 'Lower Tampa Bay'
)

# red -> orange -> yellow -> green, following the status palette used
# elsewhere for condition/attainment (worst to best)
colfun <- scales::col_numeric(
  palette = c('#d03b3b', '#ec835a', '#fab219', '#0ca30c'),
  domain  = c(0, 1)
)
nacolor <- '#c3c2b7'

petalsyr <- wqindic |>
  filter(yr == plotyr, bay_segment %in% segorder) |>
  complete(bay_segment = segorder, indicator = names(indic_labs)) |>
  mutate(
    bay_segment   = factor(bay_segment, levels = segorder),
    indicator_lab = factor(indic_labs[as.character(indicator)], levels = unname(indic_labs)),
    r_plot        = ifelse(is.na(outcome), 1, outcome),
    fillcolor     = ifelse(is.na(outcome), nacolor, colfun(outcome)),
    opacity       = ifelse(is.na(outcome), 0.25, 0.92),
    hovertext     = paste0(
      seglabs[as.character(bay_segment)], '<br>',
      indicator_lab, ': ',
      ifelse(is.na(outcome), 'No data', scales::percent(outcome, accuracy = 1))
    )
  )

centersyr <- wqoverall |>
  filter(yr == plotyr, bay_segment %in% segorder) |>
  mutate(bay_segment = factor(bay_segment, levels = segorder))

# explicit 2x2 domains (rather than plotly::subplot()) so the center hole
# size/position can be computed exactly for the score annotation below
domains <- list(
  OTB = list(x = c(0.04, 0.46), y = c(0.55, 1.00)),
  HB  = list(x = c(0.54, 0.96), y = c(0.55, 1.00)),
  MTB = list(x = c(0.04, 0.46), y = c(0.00, 0.45)),
  LTB = list(x = c(0.54, 0.96), y = c(0.00, 0.45))
)
polarnames <- c(OTB = 'polar', HB = 'polar2', MTB = 'polar3', LTB = 'polar4')
holefrac <- 0.34
figw <- 900
figh <- 840

fig <- plot_ly(width = figw, height = figh)
for (seg in segorder) {
  dd <- petalsyr |> filter(bay_segment == seg) |> arrange(indicator)
  fig <- fig |> add_trace(
    data       = dd,
    type       = 'barpolar',
    r          = ~r_plot,
    theta      = ~indicator_lab,
    marker     = list(color = ~fillcolor, opacity = ~opacity, line = list(color = 'white', width = 1)),
    subplot    = polarnames[[seg]],
    text       = ~hovertext,
    hoverinfo  = 'text',
    showlegend = FALSE
  )
}

polar_layout <- function(dom) list(
  domain      = dom,
  hole        = holefrac,
  bgcolor     = 'rgba(0,0,0,0)',
  radialaxis  = list(range = c(0, 1), showticklabels = FALSE, ticks = '', showline = FALSE, gridcolor = '#e1e0d9'),
  angularaxis = list(rotation = 90, direction = 'clockwise', tickfont = list(size = 9, color = '#52514e'), gridcolor = '#e1e0d9')
)

shapes <- list()
annos  <- list()
for (seg in segorder) {
  dom      <- domains[[seg]]
  cx       <- mean(dom$x)
  cy       <- mean(dom$y)
  qw_px    <- (dom$x[2] - dom$x[1]) * figw
  qh_px    <- (dom$y[2] - dom$y[1]) * figh
  r_px     <- min(qw_px, qh_px) / 2 * holefrac
  rx       <- r_px / figw
  ry       <- r_px / figh
  scoreval <- centersyr |> filter(bay_segment == seg) |> pull(outcome)
  ccol     <- colfun(scoreval)

  shapes[[length(shapes) + 1]] <- list(
    type = 'circle', xref = 'paper', yref = 'paper',
    x0 = cx - rx, x1 = cx + rx, y0 = cy - ry, y1 = cy + ry,
    fillcolor = ccol, line = list(color = 'white', width = 2)
  )
  annos[[length(annos) + 1]] <- list(
    x = cx, y = cy, xref = 'paper', yref = 'paper', xanchor = 'center', yanchor = 'middle',
    text = paste0('<b>', scales::percent(scoreval, accuracy = 1), '</b>'),
    showarrow = FALSE, font = list(size = 18, color = '#ffffff')
  )
  annos[[length(annos) + 1]] <- list(
    x = cx, y = dom$y[2] + 0.015, xref = 'paper', yref = 'paper', xanchor = 'center', yanchor = 'bottom',
    text = paste0('<b>', seglabs[[seg]], '</b>'),
    showarrow = FALSE, font = list(size = 13, color = '#0b0b0b')
  )
}

fig |>
  layout(
    title = list(text = paste('Bay Segment Indicator Scores —', plotyr), x = 0.5, font = list(size = 18)),
    showlegend = FALSE,
    polar  = polar_layout(domains$OTB),
    polar2 = polar_layout(domains$HB),
    polar3 = polar_layout(domains$MTB),
    polar4 = polar_layout(domains$LTB),
    shapes = shapes,
    annotations = annos,
    margin = list(t = 90, b = 20, l = 40, r = 40),
    paper_bgcolor = '#fcfcfb'
  )
```

## Sediment

``` r

peltel <- anlz_sed_peltel(sedimentdata, yrs = 1993:2024)
tbbi <- anlz_sed_tbbi(benthicdata)

sedoverall <- anlz_category(sed_peltel = peltel, sed_tbbi = tbbi)
```

## Fish/Wildlife

``` r

tbni <- anlz_fw_tbni(fimdata)
```

### Nonnatives

Ports the non-native species “report card” metrics from the
[tbep-invasives](https://github.com/tbep-tech) Python pipeline
(`src/tbep_invasives/steps/report_cards.py`) to R: non-native species
abundance (observations per unit area per year) and richness (unique
species per unit area per year) by bay segment, converted to
percentiles. Numeric output only (no plot) - two tidy year x bay-segment
data frames, `nonnative_abundance` and `nonnative_richness`.

``` r

nonnative_obs <- anlz_fw_nonnative_obs()
nonnative_abundance <- anlz_fw_nonnative_abundance(nonnative_obs)
nonnative_richness  <- anlz_fw_nonnative_richness(nonnative_obs)

fwoverall <- anlz_category(
  tbni                 = tbni,
  nonnative_abundance  = nonnative_abundance,
  nonnative_richness   = nonnative_richness
)
```

## Habitat

``` r

trnsct <- anlz_hab_seagrass_transect(transect)
cov <- anlz_hab_seagrass_coverage(sgsegest)

# anlz_hab_seagrass_coverage() reports full segment names - map to the same
# abbreviations every other category uses before combining
segabbr <- c(
  'Old Tampa Bay'    = 'OTB',
  'Hillsborough Bay' = 'HB',
  'Middle Tampa Bay' = 'MTB',
  'Lower Tampa Bay'  = 'LTB',
  'Boca Ciega Bay'   = 'BCB',
  'Terra Ceia Bay'   = 'TCB',
  'Manatee River'    = 'MR'
)

haboverall <- anlz_category(
  seagrass_transect = trnsct,
  seagrass_coverage = cov |> mutate(bay_segment = segabbr[bay_segment])
)
```

## Overall

``` r

score <- anlz_score(wqoverall, sedoverall, fwoverall, haboverall)
```

## Notes

- Indices that use categories from a continuous scale, revert to
  continuous data to get outcome
- For TBNI, the scores range from 0-100 but the categories have breaks
  at 32 and 46, take this into consideration.
- For outcomes that are binary based on threshold, maybe use a sigmoidal
  conversion
- Lots of redundancy in the water quality indicators
- How to incorporate land use change by bay segment? Is this even
  appropriate?
