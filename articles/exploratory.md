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

plot_category(wq = wqindic, bay_segment = 'OTB', yr = 2024)
```

## Sediment

``` r

peltel <- anlz_sed_peltel(sedimentdata, yrs = 1993:2024)
tbbi <- anlz_sed_tbbi(benthicdata)

sedoverall <- anlz_category(sed_peltel = peltel, sed_tbbi = tbbi)
```

``` r

plot_category(sed_peltel = peltel, sed_tbbi = tbbi, bay_segment = 'OTB', yr = 2024)
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

``` r

plot_category(
  tbni                = tbni,
  nonnative_abundance = nonnative_abundance,
  nonnative_richness  = nonnative_richness,
  bay_segment = 'OTB', yr = 2024
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

``` r

plot_category(
  seagrass_transect = trnsct,
  seagrass_coverage = cov |> mutate(bay_segment = segabbr[bay_segment]),
  bay_segment = 'OTB', yr = 2024
)
```

## Overall

``` r

score <- anlz_score(wqoverall, sedoverall, fwoverall, haboverall)
```

``` r

plot_score(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB', yr = 2024)
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
