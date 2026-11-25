# Format timestamps

The timestamps in the
[CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) instance are
formatted in character strings using formatting strings similar to the
[`base::strptime()`](https://rdrr.io/r/base/strptime.html) function,
with limitations.

## Usage

``` r
# S3 method for class 'CFTime'
format(x, format = "", tz = "", usetz = FALSE, ...)
```

## Arguments

- x:

  The `CFTime` instance whose timestamps will be formatted.

- format:

  A character string. The default for the format methods is
  "%Y-%m-%dT%H:%M:%S" if any timestamp has a time component which is not
  midnight, and "%Y-%m-%d" otherwise. The only supported specifiers are
  `bBdeFhHImMpRSTYz%`. Modifiers `E` and `O` are silently ignored. Other
  specifiers, including their percent sign, are copied to the output as
  if they were adorning text.

- tz:

  Ignored.

- usetz:

  Logical. Should the time zone offset be appended to the output? This
  is always in numerical form, i.e. "-0800", from UTC.

- ...:

  Ignored.

## Details

The formatting is largely oblivious to locale. The reason for this is
that certain dates in certain calendars are not POSIX-compliant and the
system functions necessary for locale information thus do not work
consistently. The main exception to this is the (abbreviated) names of
months (`bB`), which could be useful for pretty printing in the local
language. For separators and other locale-specific adornments, use local
knowledge instead of depending on system locale settings; e.g. specify
`%m/%d/%Y` instead of `%D`.

Week information, including weekday names, is not supported at all as a
"week" is not defined for non-standard CF calendars and not generally
useful for climate projection data. If you are working with observed
data and want to get pretty week formats, use the
[`as_timestamp()`](https://r-cf.github.io/CFtime/reference/as_timestamp.md)
method to generate `POSIXct` timestamps (observed data generally uses a
"standard" calendar) and then use the
[`base::format()`](https://rdrr.io/r/base/format.html) function which
supports the full set of specifiers.

## Examples

``` r
x <- CFtime("days since 2021-01-01", "365_day", 0:9)
format(x)
#>  [1] "2021-01-01" "2021-01-02" "2021-01-03" "2021-01-04" "2021-01-05"
#>  [6] "2021-01-06" "2021-01-07" "2021-01-08" "2021-01-09" "2021-01-10"
```
