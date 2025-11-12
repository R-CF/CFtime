# Create a vector that represents CF timestamps

This function generates a vector of character strings or `POSIXct`s that
represent the date and time in a selectable combination for each offset.

## Usage

``` r
as_timestamp(t, format = NULL, asPOSIX = FALSE)
```

## Arguments

- t:

  The `CFTime` instance that contains the offsets to use.

- format:

  character. A character string with either of the values "date" or
  "timestamp". If the argument is not specified, the format used is
  "timestamp" if there is time information, "date" otherwise.

- asPOSIX:

  logical. If `TRUE`, for "standard", "gregorian" and
  "proleptic_gregorian" calendars the output is a vector of `POSIXct` -
  for other calendars an error will be thrown. Default value is `FALSE`.

## Value

A character vector where each element represents a moment in time
according to the `format` specifier.

## Details

The character strings use the format `YYYY-MM-DDThh:mm:ss±hhmm`,
depending on the `format` specifier. The date in the string is not
necessarily compatible with `POSIXt` - in the `360_day` calendar
`2017-02-30` is valid and `2017-03-31` is not.

For the "proleptic_gregorian" calendar the output can also be generated
as a vector of `POSIXct` values by specifying `asPOSIX = TRUE`. The same
is possible for the "standard" and "gregorian" calendars but only if all
timestamps fall on or after 1582-10-15.

## See also

The [CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md)
[`format()`](https://rdrr.io/r/base/format.html) method gives greater
flexibility through the use of `strptime`-like format specifiers.

## Examples

``` r
t <- CFtime("hours since 2020-01-01", "standard", seq(0, 24, by = 0.25))
as_timestamp(t, "timestamp")
#>  [1] "2020-01-01T00:00:00" "2020-01-01T00:15:00" "2020-01-01T00:30:00"
#>  [4] "2020-01-01T00:45:00" "2020-01-01T01:00:00" "2020-01-01T01:15:00"
#>  [7] "2020-01-01T01:30:00" "2020-01-01T01:45:00" "2020-01-01T02:00:00"
#> [10] "2020-01-01T02:15:00" "2020-01-01T02:30:00" "2020-01-01T02:45:00"
#> [13] "2020-01-01T03:00:00" "2020-01-01T03:15:00" "2020-01-01T03:30:00"
#> [16] "2020-01-01T03:45:00" "2020-01-01T04:00:00" "2020-01-01T04:15:00"
#> [19] "2020-01-01T04:30:00" "2020-01-01T04:45:00" "2020-01-01T05:00:00"
#> [22] "2020-01-01T05:15:00" "2020-01-01T05:30:00" "2020-01-01T05:45:00"
#> [25] "2020-01-01T06:00:00" "2020-01-01T06:15:00" "2020-01-01T06:30:00"
#> [28] "2020-01-01T06:45:00" "2020-01-01T07:00:00" "2020-01-01T07:15:00"
#> [31] "2020-01-01T07:30:00" "2020-01-01T07:45:00" "2020-01-01T08:00:00"
#> [34] "2020-01-01T08:15:00" "2020-01-01T08:30:00" "2020-01-01T08:45:00"
#> [37] "2020-01-01T09:00:00" "2020-01-01T09:15:00" "2020-01-01T09:30:00"
#> [40] "2020-01-01T09:45:00" "2020-01-01T10:00:00" "2020-01-01T10:15:00"
#> [43] "2020-01-01T10:30:00" "2020-01-01T10:45:00" "2020-01-01T11:00:00"
#> [46] "2020-01-01T11:15:00" "2020-01-01T11:30:00" "2020-01-01T11:45:00"
#> [49] "2020-01-01T12:00:00" "2020-01-01T12:15:00" "2020-01-01T12:30:00"
#> [52] "2020-01-01T12:45:00" "2020-01-01T13:00:00" "2020-01-01T13:15:00"
#> [55] "2020-01-01T13:30:00" "2020-01-01T13:45:00" "2020-01-01T14:00:00"
#> [58] "2020-01-01T14:15:00" "2020-01-01T14:30:00" "2020-01-01T14:45:00"
#> [61] "2020-01-01T15:00:00" "2020-01-01T15:15:00" "2020-01-01T15:30:00"
#> [64] "2020-01-01T15:45:00" "2020-01-01T16:00:00" "2020-01-01T16:15:00"
#> [67] "2020-01-01T16:30:00" "2020-01-01T16:45:00" "2020-01-01T17:00:00"
#> [70] "2020-01-01T17:15:00" "2020-01-01T17:30:00" "2020-01-01T17:45:00"
#> [73] "2020-01-01T18:00:00" "2020-01-01T18:15:00" "2020-01-01T18:30:00"
#> [76] "2020-01-01T18:45:00" "2020-01-01T19:00:00" "2020-01-01T19:15:00"
#> [79] "2020-01-01T19:30:00" "2020-01-01T19:45:00" "2020-01-01T20:00:00"
#> [82] "2020-01-01T20:15:00" "2020-01-01T20:30:00" "2020-01-01T20:45:00"
#> [85] "2020-01-01T21:00:00" "2020-01-01T21:15:00" "2020-01-01T21:30:00"
#> [88] "2020-01-01T21:45:00" "2020-01-01T22:00:00" "2020-01-01T22:15:00"
#> [91] "2020-01-01T22:30:00" "2020-01-01T22:45:00" "2020-01-01T23:00:00"
#> [94] "2020-01-01T23:15:00" "2020-01-01T23:30:00" "2020-01-01T23:45:00"
#> [97] "2020-01-02T00:00:00"

t2 <- CFtime("days since 2002-01-21", "standard", 0:20)
tail(as_timestamp(t2, asPOSIX = TRUE))
#> [1] "2002-02-05 UTC" "2002-02-06 UTC" "2002-02-07 UTC" "2002-02-08 UTC"
#> [5] "2002-02-09 UTC" "2002-02-10 UTC"

tail(as_timestamp(t2))
#> [1] "2002-02-05" "2002-02-06" "2002-02-07" "2002-02-08" "2002-02-09"
#> [6] "2002-02-10"

tail(as_timestamp(t2 + 1.5))
#> Warning: Offsets not monotonically increasing.
#> [1] "2002-02-06T00:00:00" "2002-02-07T00:00:00" "2002-02-08T00:00:00"
#> [4] "2002-02-09T00:00:00" "2002-02-10T00:00:00" "2002-01-22T12:00:00"
```
