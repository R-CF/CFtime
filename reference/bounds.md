# Bounds of the time offsets

CF-compliant netCDF files store time information as a single offset
value for each step along the dimension, typically centered on the valid
interval of the data (e.g. 12-noon for day data). Optionally, the lower
and upper values of the valid interval are stored in a so-called
"bounds" variable, as an array with two rows (lower and higher value)
and a column for each offset. With function `bounds()<-` those bounds
can be set for a `CFTime` instance. The bounds can be retrieved with the
`bounds()` function.

## Usage

``` r
bounds(x, format)

bounds(x) <- value
```

## Arguments

- x:

  A `CFTime` instance.

- format:

  Optional. A single string with format specifiers, see
  [`format()`](https://rdrr.io/r/base/format.html) for details.

- value:

  A `matrix` (or `array`) with dimensions (2, length(offsets)) giving
  the lower (first row) and higher (second row) bounds of each offset
  (this is the format that the CF Metadata Conventions uses for storage
  in netCDF files). Use `NULL` to unset any previously set bounds.

## Value

If bounds have been set, an array of bounds values with dimensions
`(2, length(offsets))`. The first row gives the lower bound, the second
row the upper bound, with each column representing an offset of `x`. If
the `format` argument is specified, the bounds values are returned as
strings according to the format. `NULL` when no bounds have been set.

## Examples

``` r
t <- CFtime("days since 2024-01-01", "standard", seq(0.5, by = 1, length.out = 366))
as_timestamp(t)[1:3]
#> [1] "2024-01-01T12:00:00" "2024-01-02T12:00:00" "2024-01-03T12:00:00"
bounds(t) <- rbind(0:365, 1:366)
bounds(t)[, 1:3]
#>      [,1] [,2] [,3]
#> [1,]    0    1    2
#> [2,]    1    2    3
bounds(t, "%d-%b-%Y")[, 1:3]
#>      [,1]          [,2]          [,3]         
#> [1,] "01-Jan-2024" "02-Jan-2024" "03-Jan-2024"
#> [2,] "02-Jan-2024" "03-Jan-2024" "04-Jan-2024"
```
