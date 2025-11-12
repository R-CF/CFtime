# Find the index of timestamps in the time series

Find the index in the time series for each timestamp given in argument
`x`. Values of `x` that are before the earliest value or after the
latest value in `y` will be returned as `NA`. Alternatively, when `x` is
a numeric vector of index values, return the valid indices of the same
vector, with the side effect being the attribute "CFTime" associated
with the result.

## Usage

``` r
indexOf(x, y, method = "constant", rightmost.closed = FALSE)
```

## Arguments

- x:

  Vector of `character`, `POSIXt` or `Date` values to find indices for,
  or a numeric vector.

- y:

  A [CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md)
  instance.

- method:

  Single value of "constant" or "linear". If `"constant"` or when bounds
  are set on argument `y`, return the index value for each match. If
  `"linear"`, return the index value with any fractional value.

- rightmost.closed:

  Whether or not to include the upper limit of argument `x`. Default is
  `FALSE`. This argument is ignored when argument `x` contains index
  values.

## Value

A numeric vector giving indices into `y` for the values of `x`. If there
is at least 1 valid index, then attribute "CFTime" contains an instance
of `CFTime` that describes the dimension of filtering the dataset
associated with `y` with the result of this method, excluding any `NA`
values.

## Details

Timestamps can be provided as vectors of character strings, `POSIXct` or
`Date.`

Matching also returns index values for timestamps that fall between two
elements of the time series - this can lead to surprising results when
time series elements are positioned in the middle of an interval (as the
CF Metadata Conventions instruct us to "reasonably assume"): a time
series of days in January would be encoded in a netCDF file as
`c("2024-01-01 12:00:00", "2024-01-02 12:00:00", "2024-01-03 12:00:00", ...)`
so `x <- c("2024-01-01", "2024-01-02", "2024-01-03")` would result in
`(NA, 1, 2)` (or `(NA, 1.5, 2.5)` with `method = "linear"`) because the
date values in `x` are at midnight. This situation is easily avoided by
ensuring that `y` has bounds set (use `bounds(y) <- TRUE` as a proximate
solution if bounds are not stored in the netCDF file). See the Examples.

If bounds are set, the indices are informed by those bounds. If the
bounds are not contiguous, returned values may be `NA` even if the value
of `x` falls between two valid timestamps.

Values of `x` that are not valid timestamps according to the calendar of
`y` will be returned as `NA`.

`x` can also be a numeric vector of index values, in which case the
valid values in `x` are returned. If negative values are passed, the
positive counterparts will be excluded and then the remainder returned.
Positive and negative values may not be mixed. Using a numeric vector
has the side effect that the result has the attribute "CFTime"
describing the temporal dimension of the slice. If index values outside
of the range of `y` (`1:length(y)`) are provided, an error will be
thrown.

## Examples

``` r
cf <- CFtime("days since 2020-01-01", "360_day", 1440:1799 + 0.5)
as_timestamp(cf)[1:3]
#> [1] "2024-01-01T12:00:00" "2024-01-02T12:00:00" "2024-01-03T12:00:00"
x <- c("2024-01-01", "2024-01-02", "2024-01-03")
indexOf(x, cf)
#> [1] NA  1  2
#> attr(,"CFTime")
#> CF calendar:
#>   Origin  : 2020-01-01T00:00:00
#>   Units   : days
#>   Type    : 360_day
#> 
#> Time series:
#>   Elements: [2024-01-02 .. 2024-01-03] (average of 1.000000 days between 2 elements)
#>   Bounds  : not set
indexOf(x, cf, method = "linear")
#> [1]  NA 1.5 2.5
#> attr(,"CFTime")
#> CF calendar:
#>   Origin  : 2020-01-01T00:00:00
#>   Units   : days
#>   Type    : 360_day
#> 
#> Time series:
#>   Elements: [2024-01-02 .. 2024-01-03] (average of 1.000000 days between 2 elements)
#>   Bounds  : not set

bounds(cf) <- TRUE
indexOf(x, cf)
#> [1] 1 2 3
#> attr(,"CFTime")
#> CF calendar:
#>   Origin  : 2020-01-01T00:00:00
#>   Units   : days
#>   Type    : 360_day
#> 
#> Time series:
#>   Elements: [2024-01-01 .. 2024-01-03] (average of 1.000000 days between 3 elements)
#>   Bounds  : set

# Non-existent calendar day in a `360_day` calendar
x <- c("2024-03-30", "2024-03-31", "2024-04-01")
indexOf(x, cf)
#> [1] 90 NA 91
#> attr(,"CFTime")
#> CF calendar:
#>   Origin  : 2020-01-01T00:00:00
#>   Units   : days
#>   Type    : 360_day
#> 
#> Time series:
#>   Elements: [2024-03-30 .. 2024-04-01] (average of 1.000000 days between 2 elements)
#>   Bounds  : set

# Numeric x
indexOf(c(29, 30, 31), cf)
#> [1] 29 30 31
#> attr(,"CFTime")
#> CF calendar:
#>   Origin  : 2020-01-01T00:00:00
#>   Units   : days
#>   Type    : 360_day
#> 
#> Time series:
#>   Elements: [2024-01-29T12:00:00 .. 2024-02-01T12:00:00] (average of 1.000000 days between 3 elements)
#>   Bounds  : set
```
