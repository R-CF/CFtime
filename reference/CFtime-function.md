# Create a CFTime object

This function creates an instance of the
[CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) class. The
arguments to the call are typically read from a CF-compliant data file
with climatological observations or climate projections. Specification
of arguments can also be made manually in a variety of combinations.

## Usage

``` r
CFtime(definition, calendar = "standard", offsets, from, to, by, length.out)
```

## Arguments

- definition:

  A character string describing the time coordinate.

- calendar:

  A character string describing the calendar to use with the time
  dimension definition string. Default value is "standard".

- offsets:

  Numeric or character vector, optional. When numeric, a vector of
  offsets from the origin in the time series. When a character vector,
  timestamps in ISO8601 or UDUNITS format.

- from, to:

  Optional. Character timestamps in ISO8601 or UDUNITS format. When
  `from` is given, a sequence of timestamps is generated with `from` as
  the starting timestamp. Either argument `to` or `length.out` must be
  provided as well. Ignored when argument `offsets` is not `NULL`.

- by:

  Optional. A single character string representing a time interval,
  composed of a number and a time unit separated by a space, such as in
  "6 hours". When argument `from` is supplied, argument `by` will be the
  separation between successive timestamps. Note that the time unit in
  the string does not have to be the same as the unit in the
  `definition` argument but it must be an allowable unit of time. Time
  interval units of "months" and "years" are strongly discouraged unless
  the same time unit is used in the `definition` argument - in all other
  cases there is a loss of precision due to the ambiguity in the time
  units.

- length.out:

  Optional. An numeric value that indicates the lengths of the time
  series to generate, rounded up if fractional. Ignored when argument
  `to` is provided.

## Value

An instance of the `CFTime` class.

## Details

A time series can also be constructed like a sequence. In this case
argument `offsets` should be `NULL` or missing and arguments `from` and
`by` provided, with either of arguments `to` or `length.out` indicating
the end of the time series. Arguments should be named to avoid
ambiguity.

## Examples

``` r
# Using numeric offset values - this is how a netCDF file works
CFtime("days since 1850-01-01", "julian", 0:364)
#> CF calendar:
#>   Origin  : 1850-01-01T00:00:00
#>   Units   : days
#>   Type    : julian
#> 
#> Time series:
#>   Elements: [1850-01-01 .. 1850-12-31] (average of 1.000000 days between 365 elements)
#>   Bounds  : not set

# A time object with a single defined timestamp
CFtime("hours since 2023-01-01", "360_day", "2023-01-30T23:00")
#> CF calendar:
#>   Origin  : 2023-01-01T00:00:00
#>   Units   : hours
#>   Type    : 360_day
#> 
#> Time series:
#>   Element : 2023-01-30T23:00:00 
#>   Bounds  : not set

# A time series from a sequence with an end point
CFtime("days since 2023-01-01", from = "2020-01-01", to = "2023-12-31", by = "12 days")
#> CF calendar:
#>   Origin  : 2023-01-01T00:00:00
#>   Units   : days
#>   Type    : standard
#> 
#> Time series:
#>   Elements: [2020-01-01 .. 2023-12-23] (average of 12.000000 days between 122 elements)
#>   Bounds  : not set

# A time series from a sequence with a specified length
CFtime("days since 2023-01-01", from = "2020-01-01T03:00:00", by = "6 hr", length.out = 31 * 4)
#> CF calendar:
#>   Origin  : 2023-01-01T00:00:00
#>   Units   : days
#>   Type    : standard
#> 
#> Time series:
#>   Elements: [2020-01-01T03:00:00 .. 2020-01-31T21:00:00] (average of 0.250000 days between 124 elements)
#>   Bounds  : not set
```
