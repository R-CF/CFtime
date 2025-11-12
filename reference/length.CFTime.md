# The length of the offsets contained in the `CFTime` instance.

The length of the offsets contained in the `CFTime` instance.

## Usage

``` r
# S3 method for class 'CFTime'
length(x)
```

## Arguments

- x:

  The `CFTime` instance whose length will be returned

## Value

The number of offsets in the specified `CFTime` instance.

## Examples

``` r
t <- CFtime("days since 1850-01-01", "julian", 0:364)
length(t)
#> [1] 365
```
