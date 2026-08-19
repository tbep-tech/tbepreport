# Seagrass coverage estimates by bay segment and year

Seagrass coverage estimates by bay segment and year

## Usage

``` r
sgsegest
```

## Format

A `data.frame` with 126 rows and 3 columns:

- segment:

  Factor with 7 levels, the bay segment name (e.g. "Old Tampa Bay")

- acres:

  numeric, estimated seagrass coverage in acres

- year:

  numeric, year of the estimate

## Details

Seagrass coverage estimates by bay segment, sourced from the
[seagrass-analysis](https://github.com/tbep-tech/seagrass-analysis)
pipeline. Used in
[`anlz_hab_seagrass_coverage()`](https://tbep-tech.github.io/tbepreport/reference/anlz_hab_seagrass_coverage.md)
to compare estimated coverage against bay segment targets.

See `data-raw/sgsegest.R` for construction.

## Examples

``` r
sgsegest
#>              segment       acres year
#> 1     Boca Ciega Bay  6258.93258 1988
#> 2   Hillsborough Bay     6.77081 1988
#> 3    Lower Tampa Bay  5523.98436 1988
#> 4      Manatee River   347.24909 1988
#> 5   Middle Tampa Bay  5195.76170 1988
#> 6      Old Tampa Bay  5033.28543 1988
#> 7     Terra Ceia Bay   950.16396 1988
#> 8     Boca Ciega Bay  6805.05660 1990
#> 9   Hillsborough Bay    47.17890 1990
#> 10   Lower Tampa Bay  6153.00533 1990
#> 11     Manatee River   363.02868 1990
#> 12  Middle Tampa Bay  5297.15573 1990
#> 13     Old Tampa Bay  5589.79901 1990
#> 14    Terra Ceia Bay  1003.27897 1990
#> 15    Boca Ciega Bay  6952.42994 1992
#> 16  Hillsborough Bay    45.98546 1992
#> 17   Lower Tampa Bay  6252.59415 1992
#> 18     Manatee River   363.02866 1992
#> 19  Middle Tampa Bay  5259.69248 1992
#> 20     Old Tampa Bay  5907.42659 1992
#> 21    Terra Ceia Bay  1006.27192 1992
#> 22    Boca Ciega Bay  7129.04430 1994
#> 23  Hillsborough Bay   147.16181 1994
#> 24   Lower Tampa Bay  6214.88618 1994
#> 25     Manatee River   365.44286 1994
#> 26  Middle Tampa Bay  5770.84943 1994
#> 27     Old Tampa Bay  5936.17563 1994
#> 28    Terra Ceia Bay  1002.93902 1994
#> 29    Boca Ciega Bay  7715.79450 1996
#> 30  Hillsborough Bay   193.03874 1996
#> 31   Lower Tampa Bay  6391.56090 1996
#> 32     Manatee River   366.07745 1996
#> 33  Middle Tampa Bay  5518.83871 1996
#> 34     Old Tampa Bay  5804.42727 1996
#> 35    Terra Ceia Bay   976.92970 1996
#> 36    Boca Ciega Bay  7471.52939 1999
#> 37  Hillsborough Bay   192.44087 1999
#> 38   Lower Tampa Bay  5856.71796 1999
#> 39     Manatee River   375.88981 1999
#> 40  Middle Tampa Bay  5624.06817 1999
#> 41     Old Tampa Bay  4427.33777 1999
#> 42    Terra Ceia Bay   932.08200 1999
#> 43    Boca Ciega Bay  7682.80710 2001
#> 44  Hillsborough Bay   480.54611 2001
#> 45   Lower Tampa Bay  5619.99622 2001
#> 46     Manatee River   381.81621 2001
#> 47  Middle Tampa Bay  5709.44169 2001
#> 48     Old Tampa Bay  5304.78957 2001
#> 49    Terra Ceia Bay   941.28550 2001
#> 50    Boca Ciega Bay  7738.74453 2004
#> 51  Hillsborough Bay   566.76099 2004
#> 52   Lower Tampa Bay  6330.91980 2004
#> 53     Manatee River   448.98513 2004
#> 54  Middle Tampa Bay  6280.59751 2004
#> 55     Old Tampa Bay  4643.75202 2004
#> 56    Terra Ceia Bay  1057.44667 2004
#> 57    Boca Ciega Bay  8971.28497 2006
#> 58  Hillsborough Bay   415.99978 2006
#> 59   Lower Tampa Bay  6589.06245 2006
#> 60     Manatee River   816.06498 2006
#> 61  Middle Tampa Bay  5097.56219 2006
#> 62     Old Tampa Bay  5442.08377 2006
#> 63    Terra Ceia Bay  1009.16520 2006
#> 64    Boca Ciega Bay  8469.86562 2008
#> 65  Hillsborough Bay   811.33807 2008
#> 66   Lower Tampa Bay  6332.33899 2008
#> 67     Manatee River   639.58267 2008
#> 68  Middle Tampa Bay  6669.85392 2008
#> 69     Old Tampa Bay  5837.54933 2008
#> 70    Terra Ceia Bay   933.79956 2008
#> 71    Boca Ciega Bay  8566.62726 2010
#> 72  Hillsborough Bay   837.76699 2010
#> 73   Lower Tampa Bay  6873.24251 2010
#> 74     Manatee River   753.33058 2010
#> 75  Middle Tampa Bay  8221.34194 2010
#> 76     Old Tampa Bay  6696.98262 2010
#> 77    Terra Ceia Bay  1000.14295 2010
#> 78    Boca Ciega Bay  8557.26338 2012
#> 79  Hillsborough Bay  1450.71593 2012
#> 80   Lower Tampa Bay  6970.72881 2012
#> 81     Manatee River   655.59503 2012
#> 82  Middle Tampa Bay  9039.87176 2012
#> 83     Old Tampa Bay  7010.01058 2012
#> 84    Terra Ceia Bay  1013.03373 2012
#> 85    Boca Ciega Bay  8893.65611 2014
#> 86  Hillsborough Bay  1976.58134 2014
#> 87   Lower Tampa Bay  7650.55595 2014
#> 88     Manatee River   657.65364 2014
#> 89  Middle Tampa Bay  9710.21566 2014
#> 90     Old Tampa Bay 10288.27663 2014
#> 91    Terra Ceia Bay  1182.30618 2014
#> 92    Boca Ciega Bay  9083.81860 2016
#> 93  Hillsborough Bay  2010.43512 2016
#> 94   Lower Tampa Bay  7810.05188 2016
#> 95     Manatee River   724.81002 2016
#> 96  Middle Tampa Bay  9668.33922 2016
#> 97     Old Tampa Bay 11163.79975 2016
#> 98    Terra Ceia Bay  1260.46014 2016
#> 99    Boca Ciega Bay  9217.53952 2018
#> 100 Hillsborough Bay  1465.90517 2018
#> 101  Lower Tampa Bay  7966.74185 2018
#> 102    Manatee River   720.92782 2018
#> 103 Middle Tampa Bay  9451.63511 2018
#> 104    Old Tampa Bay 10757.62327 2018
#> 105   Terra Ceia Bay  1136.24115 2018
#> 106   Boca Ciega Bay  8812.15244 2020
#> 107 Hillsborough Bay   838.63612 2020
#> 108  Lower Tampa Bay  7901.19413 2020
#> 109    Manatee River   570.96334 2020
#> 110 Middle Tampa Bay  8437.69596 2020
#> 111    Old Tampa Bay  6710.77852 2020
#> 112   Terra Ceia Bay  1080.98884 2020
#> 113   Boca Ciega Bay  8753.01972 2022
#> 114 Hillsborough Bay   409.32270 2022
#> 115  Lower Tampa Bay  7638.31195 2022
#> 116    Manatee River   461.85123 2022
#> 117 Middle Tampa Bay  7739.05914 2022
#> 118    Old Tampa Bay  4189.70256 2022
#> 119   Terra Ceia Bay   994.09337 2022
#> 120 Hillsborough Bay  1181.61881 2024
#> 121 Middle Tampa Bay  7978.46375 2024
#> 122   Terra Ceia Bay   993.46151 2024
#> 123    Old Tampa Bay  3857.51330 2024
#> 124    Manatee River   463.09388 2024
#> 125  Lower Tampa Bay  8035.85607 2024
#> 126   Boca Ciega Bay  9052.52930 2024
```
