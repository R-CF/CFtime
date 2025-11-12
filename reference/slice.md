# Which time steps fall within extreme values

Given a vector of character timestamps, return a logical vector of a
length equal to the number of time steps in the time series with values
`TRUE` for those time steps that fall between the two extreme values of
the vector values, `FALSE` otherwise.

## Usage

``` r
slice(x, extremes, rightmost.closed = FALSE)
```

## Arguments

- x:

  The `CFTime` instance to operate on.

- extremes:

  Character vector of timestamps that represent the time period of
  interest. The extreme values are selected. Badly formatted timestamps
  are silently dropped.

- rightmost.closed:

  Is the right side closed, i.e. included in the result? Default is
  `FALSE`. A specification of `c("2022-01-01", "2023-01-01)` will thus
  include all time steps that fall in the year 2022 when
  `closed = FALSE` but include `2023-01-01` if that exact value is
  present in the time series.

## Value

A logical vector with a length equal to the number of time steps in `x`
with values `TRUE` for those time steps that fall between the extreme
values, `FALSE` otherwise.

An attribute 'CFTime' will have the same definition as `x` but with
offsets corresponding to the time steps falling between the two
extremes. If there are no values between the extremes, the attribute is
`NULL`.

## Details

If bounds were set these will be preserved.

## Examples

``` r
t <- CFtime("hours since 2023-01-01 00:00:00", "standard", 0:23)
slice(t, c("2022-12-01", "2023-01-01 03:00"))
#>  [1]  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> attr(,"CFTime")
#> CF calendar:
#>   Origin  : 2023-01-01T00:00:00
#>   Units   : hours
#>   Type    : standard
#> 
#> Time series:
#>   Elements: [2023-01-01T00:00:00 .. 2023-01-01T02:00:00] (average of 1.000000 hours between 3 elements)
#>   Bounds  : not set
```
