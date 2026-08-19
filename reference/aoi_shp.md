# Area of interest boundary for non-native species occurrence data

Area of interest boundary for non-native species occurrence data

## Usage

``` r
aoi_shp
```

## Format

An `sf` object (EPSG:4326, WGS 84) with 1 row and 3 columns:

- BAY_SEG:

  chr, boundary name

- area_ac:

  numeric, area in acres

- geometry:

  polygon geometry

## Details

The Tampa Bay area of interest polygon used to clip non-native species
occurrence points to the area covered by the report card (see
[`anlz_fw_nonnative_obs()`](https://tbep-tech.github.io/tbepreport/reference/anlz_fw_nonnative_obs.md)).
Copied from the [tbep-invasives](https://github.com/tbep-tech) repo
(`input_data/shp/TBEP_AOI_4326.shp`).

See `data-raw/aoi_shp.R` for construction.

## Examples

``` r
aoi_shp
#> Simple feature collection with 1 feature and 2 fields
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -82.85086 ymin: 27.35114 xmax: -81.88329 ymax: 28.4071
#> Geodetic CRS:  WGS 84
#>   BAY_SEG area_ac                       geometry
#> 1     AOI 1693935 POLYGON ((-82.09111 27.6401...
```
