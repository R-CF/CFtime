# Indicates if the time series is complete

This function indicates if the time series is complete, meaning that the
time steps are equally spaced and there are thus no gaps in the time
series.

## Usage

``` r
is_complete(x)
```

## Arguments

- x:

  An instance of the
  [CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) class.

## Value

logical. `TRUE` if the time series is complete, with no gaps; `FALSE`
otherwise. If no offsets have been added to the `CFTime` instance, `NA`
is returned.

## Details

This function gives exact results for time series where the nominal
*unit of separation* between observations in the time series is exact in
terms of the calendar unit. As an example, for a calendar unit of "days"
where the observations are spaced a fixed number of days apart the
result is exact, but if the same calendar unit is used for data that is
on a monthly basis, the *assessment* is approximate because the number
of days per month is variable and dependent on the calendar (the
exception being the `360_day` calendar, where the assessment is exact).
The *result* is still correct in most cases (including all CF-compliant
data sets that the developers have seen) although there may be esoteric
constructions of CFTime and offsets that trip up this implementation.

## Examples

``` r
t <- CFtime("days since 1850-01-01", "julian", 0:364)
is_complete(t)
#> [1] TRUE
```
