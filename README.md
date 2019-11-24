
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eads

<!-- badges: start -->

<!-- badges: end -->

The goal of `eads` is to provide local data users access to both canned
and custom data tables at a variety of [Census geographies]() and
[spatial extents](). This is a joint project of the [SLU
openGIS](https://slu-opengis.github.io) effort and the [St. Louis
Regional Data Alliance]().

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("slu-openGIS/eads")
```

## Regional Census Data

The `stl_get_census()` function provides access to both the American
Community Survey (from 2010 onwards) and the 1990, 2000, and 2010
Decennial Census products from the U.S. Census Bureau. For example, we
can obtain counts of the number of vacant housing units for the entire
metro St. Louis area:

``` r
> stl_get_census(region = "full metro", level = "county", 
+                variable = "H005001", year = 2010, 
+                product = "census")
Getting data from the 2010 decennial Census
Getting data from the 2010 decennial Census
# A tibble: 16 x 3
   GEOID NAME                         H005001
   <chr> <chr>                          <dbl>
 1 17013 Calhoun County, Illinois         750
 2 17027 Clinton County, Illinois        1306
 3 17061 Greene County, Illinois          819
 4 17083 Jersey County, Illinois         1020
 5 17117 Macoupin County, Illinois       2203
 6 17119 Madison County, Illinois        9012
 7 17133 Monroe County, Illinois          803
 8 17157 Randolph County, Illinois       1393
 9 17163 St. Clair County, Illinois     11204
10 29071 Franklin County, Missouri       4249
11 29099 Jefferson County, Missouri      5926
12 29113 Lincoln County, Missouri        2105
13 29183 St. Charles County, Missouri    6742
14 29189 St. Louis County, Missouri     33267
15 29219 Warren County, Missouri         2346
16 29510 St. Louis city, Missouri       33945
```

Alternatively, we can get the same counts, but just for East-West
Gateway counties in 2000:

``` r
> stl_get_census(region = "ew gateway", level = "county", 
+                variable = "H005001", year = 2000, 
+                product = "census")
Getting data from the 2000 decennial Census
Getting data from the 2000 decennial Census
# A tibble: 8 x 3
  GEOID NAME               H005001
  <chr> <chr>                <dbl>
1 17119 Madison County        6989
2 17133 Monroe County          474
3 17163 St. Clair County      7636
4 29071 Franklin County       3350
5 29099 Jefferson County      4087
6 29183 St. Charles County    3851
7 29189 St. Louis County     19437
8 29510 St. Louis city       29278
```

## What’s in a Name?

`eads` is a reference to the [Eads
Bridge](https://en.wikipedia.org/wiki/Eads_Bridge), the first bridge
erected across the Mississippi River in St. Louis and an iconic landmark
in the region. Like its namesake, `eads` provides a link between
disparate corners of the region, ensuring we can paint a unified
portrait with data instead of steel.

## Contributor Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
