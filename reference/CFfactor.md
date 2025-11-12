# Create a factor from the offsets in a `CFTime` instance

With this function a factor can be generated for the time series, or a
part thereof, contained in the
[CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) instance.
This is specifically interesting for creating factors from the date part
of the time series that aggregate the time series into longer time
periods (such as month) that can then be used to process daily CF data
sets using, for instance,
[`tapply()`](https://rdrr.io/r/base/tapply.html).

## Usage

``` r
CFfactor(t, period = "month", era = NULL)
```

## Arguments

- t:

  An instance of the `CFTime` class whose offsets will be used to
  construct the factor.

- period:

  character. A character string with one of the values "year", "season",
  "quarter", "month" (the default), "dekad" or "day".

- era:

  numeric or list, optional. Vector of years for which to construct the
  factor, or a list whose elements are each a vector of years. If `era`
  is not specified, the factor will use the entire time series for the
  factor.

## Value

If `era` is a single vector or not specified, a factor with a length
equal to the number of offsets in `t`. If `era` is a list, a list with
the same number of elements and names as `era`, each containing a
factor. Elements in the factor will be set to `NA` for time series
values outside of the range of specified years.

The factor, or factors in the list, have attributes 'period', 'era' and
'CFTime'. Attribute 'period' holds the value of the `period` argument.
Attribute 'era' indicates the number of years that are included in the
era, or -1 if no `era` is provided. Attribute 'CFTime' holds an instance
of `CFTime` that has the same definition as `t`, but with offsets
corresponding to the mid-point of non-era factor levels; if the `era`
argument is specified, attribute 'CFTime' is `NULL`.

## Details

The factor will respect the calendar that the time series is built on.
For `period`s longer than a day this will result in a factor where the
calendar is no longer relevant (because calendars impacts days, not
dekads, months, quarters, seasons or years).

The factor will be generated in the order of the offsets of the `CFTime`
instance. While typical CF-compliant data sources use ordered time
series there is, however, no guarantee that the factor is ordered as
multiple `CFTime` objects may have been merged out of order. For most
processing with a factor the ordering is of no concern.

If the `era` parameter is specified, either as a vector of years to
include in the factor, or as a list of such vectors, the factor will
only consider those values in the time series that fall within the list
of years, inclusive of boundary values. Other values in the factor will
be set to `NA`. The years need not be contiguous, within a single vector
or among the list items, or in order.

The following periods are supported by this function:

- `year`, the year of each offset is returned as "YYYY".

- `season`, the meteorological season of each offset is returned as
  "Sx", with x being 1-4, preceeded by "YYYY" if no `era` is specified.
  Note that December dates are labeled as belonging to the subsequent
  year, so the date "2020-12-01" yields "2021S1". This implies that for
  standard CMIP files having one or more full years of data the first
  season will have data for the first two months (January and February),
  while the final season will have only a single month of data
  (December).

- `quarter`, the calendar quarter of each offset is returned as "Qx",
  with x being 1-4, preceeded by "YYYY" if no `era` is specified.

- `month`, the month of each offset is returned as "01" to "12",
  preceeded by "YYYY-" if no `era` is specified. This is the default
  period.

- `dekad`, ten-day periods are returned as "Dxx", where xx runs from
  "01" to "36", preceeded by "YYYY" if no `era` is specified. Each month
  is subdivided in dekads as follows: 1- days 01 - 10; 2- days 11 - 20;
  3- remainder of the month.

- `day`, the month and day of each offset are returned as "MM-DD",
  preceeded by "YYYY-" if no `era` is specified.

It is not possible to create a factor for a period that is shorter than
the temporal resolution of the source data set from which the `t`
argument derives. As an example, if the source data set has monthly
data, a dekad or day factor cannot be created.

Creating factors for other periods is not supported by this function.
Factors based on the timestamp information and not dependent on the
calendar can trivially be constructed from the output of the
[`as_timestamp()`](https://r-cf.github.io/CFtime/reference/as_timestamp.md)
function.

For non-era factors the attribute 'CFTime' of the result contains a
`CFTime` instance that is valid for the result of applying the factor to
a data set that the `t` argument is associated with. In other words, if
`CFTime` instance 'At' describes the temporal dimension of data set 'A'
and a factor 'Af' is generated like `Af <- CFfactor(At)`, then
`Bt <- attr(Af, "CFTime")` describes the temporal dimension of the
result of, say, `B <- apply(A, 1:2, tapply, Af, FUN)`. The 'CFTime'
attribute is `NULL` for era factors.

## See also

[`cut()`](https://r-cf.github.io/CFtime/reference/cut.CFTime.md) creates
a non-era factor for arbitrary cut points.

## Examples

``` r
t <- CFtime("days since 1949-12-01", "360_day", 19830:54029)

# Create a dekad factor for the whole time series
f <- CFfactor(t, "dekad")

# Create three monthly factors for early, mid and late 21st century eras
ep <- CFfactor(t, era = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
```
