# Bay segment and AOI areas for non-native species density calculations

Bay segment and AOI areas for non-native species density calculations

## Usage

``` r
util_fw_nonnative_areas()
```

## Value

A named list with `bayseg_area_sqmi` (a named numeric vector of area in
square miles, one per `BAY_SEG_GP` group) and `aoi_area_sqmi` (a single
number, the total
[`aoi_shp`](https://tbep-tech.github.io/tbepreport/reference/aoi_shp.md)
area in square miles)

## Details

Recomputes area from geometry (reprojected to EPSG:3086) rather than
using
[`bayseg_shp`](https://tbep-tech.github.io/tbepreport/reference/bayseg_shp.md)'s
static `area_ac` attribute, matching the `tbep-invasives` Python
pipeline's own area calculation method.
[`bayseg_shp`](https://tbep-tech.github.io/tbepreport/reference/bayseg_shp.md)'s
7 raw segments are dissolved into 5 groups by `BAY_SEG_GP` before
computing area (i.e., BCB, TCB, MR to RALTB).

## Examples

``` r
util_fw_nonnative_areas()
#> $bayseg_area_sqmi
#>          Hillsborough Bay           Lower Tampa Bay          Middle Tampa Bay 
#>                 1281.5484                  127.6835                  411.2191 
#>             Old Tampa Bay Remainder Lower Tampa Bay 
#>                  337.6214                  488.7957 
#> 
#> $aoi_area_sqmi
#> [1] 2646.868
#> 
```
