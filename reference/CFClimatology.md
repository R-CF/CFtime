# CFClimatology class

This class represents a climatological time coordinate, both its
"calendar" and its "climatology" bounds values.

The "calendar" portion is managed by the
[CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) class, from
which this class is inherited. This class implements the specific
behaviour of the climatological bounds values and includes methods to
query the structure of the climatological data.

## References

https://cfconventions.org/Data/cf-conventions/cf-conventions-1.13/cf-conventions.html#climatological-statistics

## Super class

[`CFtime::CFTime`](https://r-cf.github.io/CFtime/reference/CFtime.md)
-\> `CFClimatology`

## Active bindings

- `period`:

  (read-only) Character string indicating the period during the year
  over which the climatology was calculated.

- `years`:

  (read-only) Vector of two integer values indicating the years over
  which the climatology was calculated.

- `friendlyClassName`:

  Character string with class name for display purposes.

## Methods

### Public methods

- [`CFClimatology$new()`](#method-CFClimatology-new)

- [`CFClimatology$print()`](#method-CFClimatology-print)

- [`CFClimatology$clone()`](#method-CFClimatology-clone)

Inherited methods

- [`CFtime::CFTime$POSIX_compatible()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-POSIX_compatible)
- [`CFtime::CFTime$as_timestamp()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-as_timestamp)
- [`CFtime::CFTime$copy()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-copy)
- [`CFtime::CFTime$cut()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-cut)
- [`CFtime::CFTime$equidistant()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-equidistant)
- [`CFtime::CFTime$factor()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-factor)
- [`CFtime::CFTime$factor_coverage()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-factor_coverage)
- [`CFtime::CFTime$factor_units()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-factor_units)
- [`CFtime::CFTime$format()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-format)
- [`CFtime::CFTime$get_bounds()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-get_bounds)
- [`CFtime::CFTime$indexOf()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-indexOf)
- [`CFtime::CFTime$range()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-range)
- [`CFtime::CFTime$set_bounds()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-set_bounds)
- [`CFtime::CFTime$slice()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-slice)
- [`CFtime::CFTime$subset()`](https://r-cf.github.io/CFtime/reference/CFTime.html#method-subset)

------------------------------------------------------------------------

### Method `new()`

Create a new instance of this class.

#### Usage

    CFClimatology$new(definition, calendar = "standard", offsets, bounds)

#### Arguments

- `definition`:

  Character string of the units and origin of the calendar.

- `calendar`:

  Character string of the calendar to use. Must be one of the values
  permitted by the CF Metadata Conventions. If `NULL`, the "standard"
  calendar will be used.

- `offsets`:

  Numeric or character vector. When numeric, a vector of offsets from
  the origin in the time series. When a character vector of length 2 or
  more, timestamps in ISO8601 or UDUNITS format.

- `bounds`:

  The climatological bounds for the offsets. A `matrix` with columns for
  `offsets` and low values in the first row, high values in the second
  row. The bounds will oftentimes overlap or be discontinuous.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print a summary of the `CFClimatology` object to the console.

#### Usage

    CFClimatology$print(...)

#### Arguments

- `...`:

  Ignored.

#### Returns

`self` invisibly.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    CFClimatology$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
