# Extreme time series values

Character representation of the extreme values in the time series.

## Usage

``` r
# S3 method for class 'CFTime'
range(x, format = "", bounds = FALSE, ..., na.rm = FALSE)
```

## Arguments

- x:

  An instance of the
  [CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) class.

- format:

  A character string with format specifiers, optional. If it is missing
  or an empty string, the most economical ISO8601 format is chosen:
  "date" when no time information is present in `x`, "timestamp"
  otherwise. Otherwise a suitable format specifier can be provided.

- bounds:

  Logical to indicate if the extremes from the bounds should be used, if
  set. Defaults to `FALSE`.

- ...:

  Ignored.

- na.rm:

  Ignored.

## Value

Vector of two character representations of the extremes of the time
series.

## Examples

``` r
cf <- CFtime("days since 1850-01-01", "julian", 0:364)
range(cf)
#> [1] "1850-01-01" "1850-12-31"
range(cf, "%Y-%b-%e")
#> [1] "1850-Jan- 1" "1850-Dec-31"
```
