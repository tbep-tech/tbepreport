# Non-native species occurrence points, clipped and assigned to a bay segment

Non-native species occurrence points, clipped and assigned to a bay
segment

## Usage

``` r
anlz_fw_nonnative_obs(
  huc8_list = c("03100101", "03100201", "03100202", "03100203", "03100204", "03100205",
    "03100206", "03100207", "03100208"),
  fim_url =
    "https://github.com/kflahertywalia/tb_fim_nonnatives/raw/refs/heads/main/Output/tb_fim_inv.RData",
  min_yr = 2000
)
```

## Arguments

- huc8_list:

  chr vector of HUC8 codes, passed to
  [`util_fw_fetch_nas`](https://tbep-tech.github.io/tbepreport/reference/util_fw_fetch_nas.md)

- fim_url:

  chr string, FIM data URL, passed to
  [`util_fw_fetch_fim`](https://tbep-tech.github.io/tbepreport/reference/util_fw_fetch_fim.md)

- min_yr:

  integer, earliest year to include, defaults to `2000`

## Value

A data.frame with columns `scientificName`, `commonName`, `group`,
`year`, `lon`, `lat`, `source`, and `bay_segment` (full segment name,
e.g. `"Old Tampa Bay"`). Each row is one occurrence point that fell
within the AOI and a bay segment

## Details

Combines
[`util_fw_fetch_nas`](https://tbep-tech.github.io/tbepreport/reference/util_fw_fetch_nas.md)
and
[`util_fw_fetch_fim`](https://tbep-tech.github.io/tbepreport/reference/util_fw_fetch_fim.md),
filters to `yr >= min_yr` and non-missing coordinates, then clips to the
[`aoi_shp`](https://tbep-tech.github.io/tbepreport/reference/aoi_shp.md)
boundary and spatially joins each point to a `bay_segment` using
[`bayseg_shp`](https://tbep-tech.github.io/tbepreport/reference/bayseg_shp.md)'s
`BAY_SEG_GP` grouping. This is the shared, network-heavy step behind
[`anlz_fw_nonnative_abundance`](https://tbep-tech.github.io/tbepreport/reference/anlz_fw_nonnative_abundance.md)
and
[`anlz_fw_nonnative_richness`](https://tbep-tech.github.io/tbepreport/reference/anlz_fw_nonnative_richness.md),
computed once and passed to both rather than letting each re-fetch.

## Examples

``` r
if (FALSE) { # \dontrun{
anlz_fw_nonnative_obs()
} # }
```
