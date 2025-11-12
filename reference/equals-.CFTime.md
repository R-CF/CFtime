# Equivalence of CFTime objects

This operator can be used to test if two
[CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) objects
represent the same CF-convention time coordinates. Two `CFTime` objects
are considered equivalent if they have an equivalent calendar and the
same offsets.

## Usage

``` r
# S3 method for class 'CFTime'
e1 == e2
```

## Arguments

- e1, e2:

  Instances of the `CFTime` class.

## Value

`TRUE` if the `CFTime` objects are equivalent, `FALSE` otherwise.

## Examples

``` r
e1 <- CFtime("days since 1850-01-01", "gregorian", 0:364)
e2 <- CFtime("days since 1850-01-01 00:00:00", "standard", 0:364)
e1 == e2
#> [1] TRUE
```
