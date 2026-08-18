# Fetch the Tampa Bay FIM species dataset

Fetch the Tampa Bay FIM species dataset

## Usage

``` r
util_fw_fetch_fim(
  fim_url =
    "https://github.com/kflahertywalia/tb_fim_nonnatives/raw/refs/heads/main/Output/tb_fim_inv.RData"
)
```

## Arguments

- fim_url:

  chr string, the URL of the FIM species RData file, defaults to the
  [tb_fim_nonnatives](https://github.com/kflahertywalia/tb_fim_nonnatives)
  repo's output

## Value

A data.frame with columns `scientificName`, `commonName`, `group`,
`year`, `lon`, `lat`, and `source` (always `"FIM"`)

## Details

Downloads and parses the FIM RData file directly (not via
[`util_rdataload`](https://tbep-tech.github.io/tbepreport/reference/util_rdataload.md)).
Only `Fish`/`Turtle` taxa are present in this dataset. They're recoded
to `Fishes`/ `Reptiles` to match
[`util_fw_fetch_nas`](https://tbep-tech.github.io/tbepreport/reference/util_fw_fetch_nas.md)'s
group names. Year is recovered from the `Reference` field.

## Examples

``` r
if (FALSE) { # \dontrun{
util_fw_fetch_fim()
} # }
```
