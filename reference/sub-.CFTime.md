# Subset a `CFTime` instance by position in the time series

Subset a `CFTime` instance by position in the time series

## Usage

``` r
# S3 method for class 'CFTime'
x[i = TRUE, ...]
```

## Arguments

- x:

  A `CFTime` instance.

- i:

  A vector a positive integer values to indicate which values to extract
  from the time series by position. If negative values are passed, their
  positive counterparts will be excluded and then the remainder
  returned. Positive and negative values may not be mixed.

- ...:

  Ignored.

## Value

A numeric vector with those values of `i` (or the inverse, when
negative) that are valid in `x`. If there is at least 1 valid result,
then attribute "CFTime" of the returned value contains an instance of
`CFTime` that describes the dimension of filtering the dataset
associated with `x` with the result of this function, excluding any `NA`
values.

## References

https://github.com/R-CF/CFtime/issues/20
