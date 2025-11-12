# Parse series of timestamps in CF format to date-time elements

This function will parse a vector of timestamps in ISO8601 or UDUNITS
format into a data frame with columns for the elements of the timestamp:
year, month, day, hour, minute, second, time zone. Those timestamps that
could not be parsed or which represent an invalid date in the indicated
`CFtime` instance will have `NA` values for the elements of the
offending timestamp (which will generate a warning).

## Usage

``` r
parse_timestamps(t, x)
```

## Arguments

- t:

  An instance of `CFTime` to use when parsing the date.

- x:

  Vector of character strings representing timestamps in ISO8601
  extended or UDUNITS broken format.

## Value

A `data.frame` with constituent elements of the parsed timestamps in
numeric format. The columns are year, month, day, hour, minute, second
(with an optional fraction), time zone (character string), and the
corresponding offset value from the origin. Invalid input data will
appear as `NA` - if this is the case, a warning message will be
displayed - other missing information on input will use default values.

## Details

The supported formats are the *broken timestamp* format from the UDUNITS
library and ISO8601 *extended*, both with minor changes, as suggested by
the CF Metadata Conventions. In general, the format is
`YYYY-MM-DD hh:mm:ss.sss hh:mm`. The year can be from 1 to 4 digits and
is interpreted literally, so `79-10-24` is the day Mount Vesuvius
erupted and destroyed Pompeii, not `1979-10-24`. The year and month are
mandatory, all other fields are optional. There are defaults for all
missing values, following the UDUNITS and CF Metadata Conventions.
Leading zeros can be omitted in the UDUNITS format, but not in the
ISO8601 format. The optional fractional part can have as many digits as
the precision calls for and will be applied to the smallest specified
time unit. In the result of this function, if the fraction is associated
with the minute or the hour, it is converted into a regular
`hh:mm:ss.sss` format, i.e. any fraction in the result is always
associated with the second, rounded down to milli-second accuracy. The
separator between the date and the time can be a single whitespace
character or a `T`.

The time zone is optional and should have at least the hour or `Z` if
present, the minute is optional. The time zone hour can have an optional
sign. In the UDUNITS format the separator between the time and the time
zone must be a single whitespace character, in ISO8601 there is no
separation between the time and the timezone. Time zone names are not
supported (as neither UDUNITS nor ISO8601 support them) and will cause
parsing to fail when supplied, with one exception: the designator "UTC"
is silently dropped (i.e. interpreted as "00:00").

Currently only the extended formats (with separators between the
elements) are supported. The vector of timestamps may have any
combination of ISO8601 and UDUNITS formats.

## Examples

``` r
t <- CFtime("days since 0001-01-01", "proleptic_gregorian")

# This will have `NA`s on output and generate a warning
timestamps <- c("2012-01-01T12:21:34Z", "12-1-23", "today",
                "2022-08-16T11:07:34.45-10", "2022-08-16 10.5+04")
parse_timestamps(t, timestamps)
#> Warning: Some dates could not be parsed. Result contains `NA` values.
#> Warning: Timestamps have multiple time zones. Some or all may be different from the calendar time zone.
#>   year month day hour minute second    tz   offset
#> 1 2012     1   1   12     21  34.00 +0000 734502.5
#> 2   12     1  23    0      0   0.00 +0000   4039.0
#> 3   NA    NA  NA   NA     NA     NA  <NA>       NA
#> 4 2022     8  16   11      7  34.45 -1000 738382.5
#> 5 2022     8  16   10     30   0.00 +0400 738382.4
```
