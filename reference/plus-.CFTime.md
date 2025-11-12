# Extend a CFTime object

A [CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) instance
can be extended with this operator, using values from another `CFTime`
instance, or a vector of numeric offsets or character timestamps. If the
values come from another `CFTime` instance, the calendars of the two
instances must be compatible If the calendars of the `CFTime` instances
are not compatible, an error is thrown.

## Usage

``` r
# S3 method for class 'CFTime'
e1 + e2
```

## Arguments

- e1:

  Instance of the `CFTime` class.

- e2:

  Instance of the `CFTime` class with a calendar compatible with that of
  argument `e1`, or a numeric vector with offsets from the origin of
  argument `e1`, or a vector of `character` timestamps in ISO8601 or
  UDUNITS format.

## Value

A `CFTime` object with the offsets of argument `e1` extended by the
values from argument `e2`.

## Details

The resulting `CFTime` instance will have the offsets of the original
`CFTime` instance, appended with offsets from argument `e2` in the order
that they are specified. If the new sequence of offsets is not
monotonically increasing a warning is generated (the COARDS metadata
convention requires offsets to be monotonically increasing).

There is no reordering or removal of duplicates. This is because the
time series are usually associated with a data set and the
correspondence between the data in the files and the `CFTime` instance
is thus preserved. When merging the data sets described by this time
series, the order must be identical to the merging here.

Note that when adding multiple vectors of offsets to a `CFTime`
instance, it is more efficient to first concatenate the vectors and then
do a final addition to the `CFTime` instance. So avoid
`CFtime(definition, calendar, e1) + CFtime(definition, calendar, e2) + CFtime(definition, calendar, e3) + ...`
but rather do `CFtime(definition, calendar) + c(e1, e2, e3, ...)`. It is
the responsibility of the operator to ensure that the offsets of the
different data sets are in reference to the same calendar.

Note also that `RNetCDF` and `ncdf4` packages both return the values of
the "time" dimension as a 1-dimensional array. You have to
`dim(time_values) <- NULL` to de-class the array to a vector before
adding offsets to an existing `CFtime` instance.

Any bounds that were set will be removed. Use
[`bounds()`](https://r-cf.github.io/CFtime/reference/bounds.md) to
retrieve the bounds of the individual `CFTime` instances and then set
them again after merging the two instances.

## Examples

``` r
e1 <- CFtime("days since 1850-01-01", "gregorian", 0:364)
e2 <- CFtime("days since 1850-01-01 00:00:00", "standard", 365:729)
e1 + e2
#> CF calendar:
#>   Origin  : 1850-01-01T00:00:00
#>   Units   : days
#>   Type    : standard
#> 
#> Time series:
#>   Elements: [1850-01-01 .. 1851-12-31] (average of 1.000000 days between 730 elements)
#>   Bounds  : not set
```
