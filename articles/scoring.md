# Report Card Scoring

This article walks through the full report card pipeline: computing each
individual indicator, converting raw indicator values to a common 0-1
outcome scale, combining indicators into category scores and an overall
bay segment score, and visualizing the results. The four categories -
Water Quality, Sediment, Fish and Wildlife, and Habitat - are each
covered below, followed by sections on scoring, combining, and plotting.

## Water Quality

### Targets

Combines chlorophyll and light attenuation attainment into a single
continuous outcome: the two sub-scores are summed, so a lower combined
sub-score (better attainment on both fronts) gives a higher outcome.
These outcomes come directly from the management targets for each bay
segment, as described in the tbeptools [water quality
vignette](https://tbep-tech.github.io/tbeptools/articles/intro.html).

``` r

wqattain <- anlz_wq_attain(epcdata)
```

### Chlorophyll and Light Thresholds

Compares annual mean chlorophyll and light attenuation values directly
against bay-segment-specific thresholds, independent of the combined
attainment score above. Each gives its own binary (threshold) outcome.

``` r

wqthresh <- anlz_wq_thresh(epcdata)
```

### Nutrient and Hydrologic Loading

Compares total nitrogen load and a hydrologically-normalized loading
against fixed bay-segment thresholds, each as its own binary (threshold)
outcome.

``` r

totanndat <- util_rdataload("https://github.com/tbep-tech/load-estimates/raw/main/data/totanndat.RData")
wqload <- anlz_wq_load(totanndat)
```

### Tidal Creeks

Assigns each tidal creek to a bay segment, converts its condition
category (Prioritize/Investigate/Caution/Monitor) to an outcome, then
averages by bay segment/year weighted by creek length so longer creek
segments contribute proportionally more.

``` r

wqtidalcreeks <- anlz_wq_tidalcreeks(tidalcreeks, iwrraw, yrs = 1975:2024)
```

### Fecal Indicator Bacteria

Grades each bay segment/year A-E from enterococcus monitoring data, then
converts the letter grade to an outcome.

``` r

wqfib <- anlz_wq_fib(enterodata)
```

## Sediment

### Contaminants

Grades each bay segment/year A-F from its average sediment contamination
score (PEL/TEL), then converts the letter grade to an outcome.

``` r

peltel <- anlz_sed_peltel(sedimentdata, yrs = 1993:2024)
```

### Benthic Index

Grades each bay segment/year Poor/Fair/Good from the Tampa Bay Benthic
Index (TBBI), then converts the grade to an outcome.

``` r

tbbi <- anlz_sed_tbbi(benthicdata)
```

## Fish and Wildlife

### Nekton Index

Scores each bay segment/year 0-100 with the Tampa Bay Nekton Index
(TBNI), then rescales to an outcome using TBNI’s own grade breakpoints
(On Alert below 32, Caution from 32 to 46, Stay the Course above 46):
scores below 32 give an outcome of 0, scores above 46 give an outcome of
1, and scores in between are linearly rescaled.

``` r

tbni <- anlz_fw_tbni(fimdata)
```

### Non-natives

Ports the non-native species “report card” metrics from the
[tbep-invasives](https://github.com/tbep-tech) Python pipeline
(`src/tbep_invasives/steps/report_cards.py`) to R. Returns non-native
species abundance (observations per unit area per year) and richness
(unique species per unit area per year) by bay segment, converted to
percentiles and then reversed to an outcome (higher abundance/richness
is worse).

``` r

nonnative_obs <- anlz_fw_nonnative_obs()
nonnative_abundance <- anlz_fw_nonnative_abundance(nonnative_obs)
nonnative_richness  <- anlz_fw_nonnative_richness(nonnative_obs)
```

## Habitat

### Seagrass Transects

Estimates frequency of seagrass occurrence (0-100) at each bay
segment/year from transect monitoring data, then linearly rescales to an
outcome.

``` r

trnsct <- anlz_hab_seagrass_transect(transect)
```

### Seagrass Coverage

Compares mapped seagrass acreage against a fixed per-segment target (a
binary/threshold outcome), where the targets are the baywide 40,000-acre
seagrass coverage target apportioned across segments by each segment’s
share of total bay area. Coverage maps are flown only every couple of
years, so non-survey years carry forward the most recent actual estimate
and outcome.

``` r

cov <- anlz_hab_seagrass_coverage(sgsegest)
```

## Scoring

Every indicator above ends with the same step: a raw measurement is
converted to a 0-1 outcome, where 1 is always the best possible
condition. That conversion happens in one place,
[`util_outcome()`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md),
so how an indicator is scored can change without touching the `anlz_*`
function that uses it.
[`util_outcome()`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md)
supports three types:

- **Continuous** - a raw value is linearly rescaled to 0-1 over a known
  range, clamped so values outside that range are pinned to 0 or 1
  rather than extrapolated (e.g. seagrass transect frequency of
  occurrence over its full 0-100 range, or the Nekton Index’s 0-100
  score rescaled over just its 32-46 breakpoint window).
- **Category** - a discrete grade or condition category is mapped to a
  fixed outcome (e.g. FIB bacteria grades A-E, sediment PEL/TEL grades
  A-F, tidal creek condition categories, TBBI Poor/Fair/Good).
- **Binary (threshold)** - a raw value is compared against a cutoff,
  giving a hard 0 or 1 (e.g. nutrient loading against a bay-segment
  target, chlorophyll/light attenuation against their thresholds,
  seagrass coverage against an acreage target).

``` r

# continuous: linearly rescale a raw value between known bounds
util_outcome(75, type = 'continuous', from = c(0, 100))
#> [1] 0.75

# category: map a discrete grade to a fixed outcome
util_outcome('B', type = 'category', levels = c(A = 1, B = 0.75, C = 0.5, D = 0.25, F = 0))
#> [1] 0.75

# binary (threshold): compare against a cutoff
util_outcome(8, type = 'threshold', thresh = 10, op = '<')
#> [1] 1
```

The non-native abundance and richness indicators are the one exception -
rather than
[`util_outcome()`](https://tbep-tech.github.io/tbepreport/reference/util_outcome.md),
they convert a percentile (via
[`util_percentile()`](https://tbep-tech.github.io/tbepreport/reference/util_percentile.md))
directly to an outcome (`1 - percentile / 100`), since there’s no fixed
range, grade, or threshold to compare against.

## Combining Scores

Once every indicator has a 0-1 outcome, three functions combine them
into increasingly aggregated scores:

- [`anlz_indicators()`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md)
  stacks any number of named indicator data.frames into one long table
  (`bay_segment`, `yr`, `indicator`, `outcome`), without filling in gaps
  where an indicator has no data for a given segment/year.
- [`anlz_category()`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  calls
  [`anlz_indicators()`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md)
  internally, then averages `outcome` within each bay segment/year to
  get a category score - the result also keeps one wide column per
  indicator, so the indicators behind a category score stay visible
  alongside it.
- [`anlz_score()`](https://tbep-tech.github.io/tbepreport/reference/anlz_score.md)
  is a thin wrapper around
  [`anlz_category()`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md):
  the four category scores are themselves just another set of
  “indicators” to average, giving the overall bay segment score.

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

sedoverall <- anlz_category(sed_peltel = peltel, sed_tbbi = tbbi)
```

``` r

fwoverall <- anlz_category(
  tbni                 = tbni,
  nonnative_abundance  = nonnative_abundance,
  nonnative_richness   = nonnative_richness
)
```

``` r

haboverall <- anlz_category(
  seagrass_transect = trnsct,
  seagrass_coverage = cov
)
```

``` r

score <- anlz_score(wqoverall, sedoverall, fwoverall, haboverall)
```

## Visualizing Scores

[`plot_category()`](https://tbep-tech.github.io/tbepreport/reference/plot_category.md)
and
[`plot_score()`](https://tbep-tech.github.io/tbepreport/reference/plot_score.md)
both plot a two- or three-ring sunburst - a colored center hole for the
overall score, surrounded by a ring per component, each colored on the
same continuous red/yellow/green outcome scale.
[`plot_category()`](https://tbep-tech.github.io/tbepreport/reference/plot_category.md)
takes the same named indicator data.frames as
[`anlz_category()`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
(and calls it internally) to plot one category’s indicators around its
score, for a chosen bay segment and year:

``` r

plot_category(wq = wqindic, bay_segment = 'OTB', yr = 2024)
```

``` r

plot_category(sed_peltel = peltel, sed_tbbi = tbbi, bay_segment = 'OTB', yr = 2024)
```

``` r

plot_category(
  tbni                = tbni,
  nonnative_abundance = nonnative_abundance,
  nonnative_richness  = nonnative_richness,
  bay_segment = 'OTB', yr = 2024
)
```

``` r

plot_category(
  seagrass_transect = trnsct,
  seagrass_coverage = cov,
  bay_segment = 'OTB', yr = 2024
)
```

[`plot_score()`](https://tbep-tech.github.io/tbepreport/reference/plot_score.md)
takes the same four category data.frames as
[`anlz_score()`](https://tbep-tech.github.io/tbepreport/reference/anlz_score.md)
(and calls it internally) to plot the full hierarchy - indicators, then
categories, then the overall score - for a chosen bay segment and year:

``` r

plot_score(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB', yr = 2024)
```

## Notes

- Indices that use categories from a continuous scale, revert to
  continuous data to get outcome
- For outcomes that are binary based on threshold, maybe use a sigmoidal
  conversion
- Lots of redundancy in the water quality indicators
- How to incorporate land use change by bay segment? Is this even
  appropriate?
