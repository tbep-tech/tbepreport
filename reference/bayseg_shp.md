# Bay segment boundaries for non-native species occurrence data

Bay segment boundaries for non-native species occurrence data

## Usage

``` r
bayseg_shp
```

## Format

An `sf` object (EPSG:4326, WGS 84) with 7 rows and 5 columns:

- BAY_SEG:

  chr, raw bay segment name (7 unique values, e.g. "Boca Ciega Bay")

- BAY_SEG_GP:

  chr, grouped bay segment name (5 unique values). The 7 raw segments
  grouped into "Old Tampa Bay", "Hillsborough Bay", "Middle Tampa Bay",
  "Lower Tampa Bay", and "Remainder Lower Tampa Bay" (Boca Ciega Bay,
  Manatee River, and Terra Ceia Bay dissolved together)

- BAY_GP_ABB:

  chr, abbreviation of `BAY_SEG_GP` (OTB, HB, MTB, LTB, RLTB)

- area_ac:

  numeric, area of the raw `BAY_SEG` polygon in acres

- geometry:

  polygon geometry

## Details

Bay segment boundaries used to spatially join non-native species
occurrence points to a bay segment (see `anlz_nonnative_obs()`). Copied
from the [tbep-invasives](https://github.com/tbep-tech) repo
(`input_data/shp/TBEP_Bay_Segments_4326.shp`), so segment grouping and
areas match its report cards exactly. Note `area_ac` is a static
attribute of each raw polygon. Functions using this data recompute area
from the geometry instead (grouped by `BAY_SEG_GP`), which matches this
static value closely but is used for consistency with the source
pipeline's own area calculation.

See `data-raw/bayseg_shp.R` for construction.

## Examples

``` r
bayseg_shp
#> Simple feature collection with 7 features and 4 fields
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -82.85086 ymin: 27.35114 xmax: -81.88329 ymax: 28.4071
#> Geodetic CRS:  WGS 84
#>            BAY_SEG                BAY_SEG_GP BAY_GP_ABB area_ac
#> 1   Boca Ciega Bay Remainder Lower Tampa Bay       RLTB   72270
#> 2 Hillsborough Bay          Hillsborough Bay         HB  820162
#> 3  Lower Tampa Bay           Lower Tampa Bay        LTB   81715
#> 4    Manatee River Remainder Lower Tampa Bay       RLTB  229751
#> 5 Middle Tampa Bay          Middle Tampa Bay        MTB  263171
#> 6    Old Tampa Bay             Old Tampa Bay        OTB  216070
#> 7   Terra Ceia Bay Remainder Lower Tampa Bay       RLTB   10798
#>                         geometry
#> 1 POLYGON ((-82.78454 27.9343...
#> 2 POLYGON ((-82.31257 28.4017...
#> 3 POLYGON ((-82.5503 27.64465...
#> 4 POLYGON ((-82.1053 27.64425...
#> 5 POLYGON ((-82.62934 27.8644...
#> 6 POLYGON ((-82.46478 28.1966...
#> 7 POLYGON ((-82.54618 27.5799...
```
