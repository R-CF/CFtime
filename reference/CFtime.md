# CFTime class

This class manages the "time" dimension of netCDF files that follow the
CF Metadata Conventions, and its productive use in R.

The class has a field `cal` which holds a specific calendar from the
allowed types (all named calendars are supported). The calendar is also
implemented as a (hidden) class which converts netCDF file encodings to
timestamps as character strings, and vice-versa. Bounds information (the
period of time over which a timestamp is valid) is used when defined in
the netCDF file.

Additionally, this class has functions to ease use of the netCDF "time"
information when processing data from netCDF files. Filtering and
indexing of time values is supported, as is the generation of factors.

## References

https://cfconventions.org/Data/cf-conventions/cf-conventions-1.13/cf-conventions.html#time-coordinate

## Public fields

- `cal`:

  The calendar of this `CFTime` instance, a descendant of the
  [CFCalendar](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
  class.

- `offsets`:

  A numeric vector of offsets from the origin of the calendar.

- `resolution`:

  The average number of time units between offsets.

## Active bindings

- `calendar`:

  (read-only) The calendar of this `CFTime` instance, a descendant of
  the
  [CFCalendar](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
  class.

- `unit`:

  (read-only) The unit string of the calendar and time series.

- `length`:

  (read-only) Retrieve the number of offsets in the time series.

- `bounds`:

  Retrieve or set the bounds for the offsets. On setting, a `matrix`
  with columns for `offsets` and low values in the first row, high
  values in the second row. This may be simply `TRUE` to set regular and
  consecutive bounds.

- `friendlyClassName`:

  Character string with class name for display purposes.

## Methods

### Public methods

- [`CFTime$new()`](#method-CFTime-new)

- [`CFTime$print()`](#method-CFTime-print)

- [`CFTime$range()`](#method-CFTime-range)

- [`CFTime$as_timestamp()`](#method-CFTime-as_timestamp)

- [`CFTime$format()`](#method-CFTime-format)

- [`CFTime$indexOf()`](#method-CFTime-indexOf)

- [`CFTime$get_bounds()`](#method-CFTime-get_bounds)

- [`CFTime$set_bounds()`](#method-CFTime-set_bounds)

- [`CFTime$equidistant()`](#method-CFTime-equidistant)

- [`CFTime$slice()`](#method-CFTime-slice)

- [`CFTime$POSIX_compatible()`](#method-CFTime-POSIX_compatible)

- [`CFTime$cut()`](#method-CFTime-cut)

- [`CFTime$factor()`](#method-CFTime-factor)

- [`CFTime$factor_units()`](#method-CFTime-factor_units)

- [`CFTime$factor_coverage()`](#method-CFTime-factor_coverage)

- [`CFTime$copy()`](#method-CFTime-copy)

- [`CFTime$subset()`](#method-CFTime-subset)

- [`CFTime$clone()`](#method-CFTime-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new instance of this class.

#### Usage

    CFTime$new(definition, calendar = "standard", offsets = NULL)

#### Arguments

- `definition`:

  Character string of the units and origin of the calendar.

- `calendar`:

  Character string of the calendar to use. Must be one of the values
  permitted by the CF Metadata Conventions. If `NULL`, the "standard"
  calendar will be used.

- `offsets`:

  Numeric or character vector, optional. When numeric, a vector of
  offsets from the origin in the time series. When a character vector of
  length 2 or more, timestamps in ISO8601 or UDUNITS format.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print a summary of the `CFTime` object to the console.

#### Usage

    CFTime$print(...)

#### Arguments

- `...`:

  Ignored.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method [`range()`](https://rdrr.io/r/base/range.html)

This method returns the first and last timestamp of the time series as a
vector. Note that the offsets do not have to be sorted.

#### Usage

    CFTime$range(format = "", bounds = FALSE)

#### Arguments

- `format`:

  Value of "date" or "timestamp". Optionally, a character string that
  specifies an alternate format.

- `bounds`:

  Logical to indicate if the extremes from the bounds should be used, if
  set. Defaults to `FALSE`.

#### Returns

Vector of two character strings that represent the starting and ending
timestamps in the time series. If a `format` is supplied, that format
will be used. Otherwise, if all of the timestamps in the time series
have a time component of `00:00:00` the date of the timestamp is
returned, otherwise the full timestamp (without any time zone
information).

------------------------------------------------------------------------

### Method [`as_timestamp()`](https://r-cf.github.io/CFtime/reference/as_timestamp.md)

This method generates a vector of character strings or `POSIXct`s that
represent the date and time in a selectable combination for each offset.

The character strings use the format `YYYY-MM-DDThh:mm:ss±hhmm`,
depending on the `format` specifier. The date in the string is not
necessarily compatible with `POSIXt` - in the `360_day` calendar
`2017-02-30` is valid and `2017-03-31` is not.

For the "proleptic_gregorian" calendar the output can also be generated
as a vector of `POSIXct` values by specifying `asPOSIX = TRUE`. The same
is possible for the "standard" and "gregorian" calendars but only if all
timestamps fall on or after 1582-10-15. If `asPOSIX = TRUE` is specified
while the calendar does not support it, an error will be generated.

#### Usage

    CFTime$as_timestamp(format = NULL, asPOSIX = FALSE)

#### Arguments

- `format`:

  character. A character string with either of the values "date" or
  "timestamp". If the argument is not specified, the format used is
  "timestamp" if there is time information, "date" otherwise.

- `asPOSIX`:

  logical. If `TRUE`, for "standard", "gregorian" and
  "proleptic_gregorian" calendars the output is a vector of `POSIXct` -
  for other calendars an error will be thrown. Default value is `FALSE`.

#### Returns

A character vector where each element represents a moment in time
according to the `format` specifier.

------------------------------------------------------------------------

### Method [`format()`](https://rdrr.io/r/base/format.html)

Format timestamps using a specific format string, using the specifiers
defined for the
[`base::strptime()`](https://rdrr.io/r/base/strptime.html) function,
with limitations. The only supported specifiers are `bBdeFhHImMpRSTYz%`.
Modifiers `E` and `O` are silently ignored. Other specifiers, including
their percent sign, are copied to the output as if they were adorning
text.

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

#### Usage

    CFTime$format(format, usetz = FALSE)

#### Arguments

- `format`:

  A character string with `strptime` format specifiers. If omitted, the
  most economical format will be used: a full timestamp when time
  information is available, a date otherwise.

- `usetz`:

  Logical. Should the time zone offset be appended to the output? This
  is always in numerical form, i.e. "-0800", from UTC. Default is
  `FALSE`.

#### Returns

A vector of character strings with a properly formatted timestamp. Any
format specifiers not recognized or supported will be returned verbatim.

------------------------------------------------------------------------

### Method [`indexOf()`](https://r-cf.github.io/CFtime/reference/indexOf.md)

Find the index in the time series for each timestamp given in argument
`x`. Alternatively, when `x` is a numeric vector of index values, return
the valid indices of the same vector, with the side effect being the
attribute "CFTime" associated with the result.

Matching also returns index values for timestamps that fall between two
elements of the time series - this can lead to surprising results when
time series elements are positioned in the middle of an interval (as the
CF Metadata Conventions instruct us to "reasonably assume"): a time
series of days in January would be encoded in a netCDF file as
`c("2024-01-01 12:00:00", "2024-01-02 12:00:00", "2024-01-03 12:00:00", ...)`
so `x <- c("2024-01-01", "2024-01-02", "2024-01-03")` would result in
`(NA, 1, 2)` (or `(NA, 1.5, 2.5)` with `method = "linear"`) because the
date values in `x` are at midnight. This situation is easily avoided by
ensuring that this `CFTime` instance has bounds set (use
`bounds(y) <- TRUE` as a proximate solution if bounds are not stored in
the netCDF file).

If bounds are set, the indices are informed by those bounds. If the
bounds are not contiguous, returned values may be `NA` even if the value
of `x` falls between two valid timestamps.

Values of `x` that are not valid timestamps according to the calendar of
this `CFTime` instance will be returned as `NA`.

Argument `x` can also be a numeric vector of index values, in which case
the valid values in `x` are returned. If negative values are passed, the
positive counterparts will be excluded and then the remainder returned.
Positive and negative values may not be mixed. Using a numeric vector
has the side effect that the result has the attribute "CFTime"
describing the temporal dimension of the slice. If index values outside
of the range of `self` are provided, an error will be thrown.

#### Usage

    CFTime$indexOf(x, method = "constant", rightmost.closed = FALSE)

#### Arguments

- `x`:

  Vector of `character`, `POSIXt` or `Date` values to find indices for,
  or a `numeric` vector.

- `method`:

  Single value of "constant" or "linear". If `"constant"`, return the
  index value for each match. If `"linear"`, return the index value with
  any fractional value.

- `rightmost.closed`:

  Whether or not to include the upper limit of argument `x`. Default is
  `FALSE`. This argument is ignored when argument `x` contains index
  values.

#### Returns

A numeric vector giving indices into `self` for the valid values of `x`.
If there is at least 1 valid index, then attribute "CFTime" contains an
instance of `CFTime` that describes the dimension of filtering the
dataset associated with `self` with the result of this method, excluding
any `NA` values.

------------------------------------------------------------------------

### Method `get_bounds()`

Return boundary values.

#### Usage

    CFTime$get_bounds(format)

#### Arguments

- `format`:

  A string specifying a format for output, optional.

#### Returns

An array with `dims(2, length(offsets))` with values for the boundaries.
`NULL` if the boundaries have not been set.

------------------------------------------------------------------------

### Method `set_bounds()`

Set or delete the boundary values of the `CFTime` instance.

#### Usage

    CFTime$set_bounds(value)

#### Arguments

- `value`:

  The boundary values to set, in units of the offsets. A matrix
  `(2, length(self$offsets))`. If `NULL`, the boundaries are deleted. If
  `TRUE`, make regular, consecutive boundaries.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `equidistant()`

This method returns `TRUE` if the time series has uniformly distributed
time steps between the extreme values, `FALSE` otherwise. First test
without sorting; this should work for most data sets. If not, only then
offsets are sorted. For most data sets that will work but for implied
resolutions of month, season, year, etc based on a "days" or finer
calendar unit this will fail due to the fact that those coarser units
have a variable number of days per time step, in all calendars except
for `360_day`. For now, an approximate solution is used that should work
in all but the most non-conformal exotic arrangements.

#### Usage

    CFTime$equidistant()

#### Returns

`TRUE` if all time steps are equidistant, `FALSE` otherwise, or `NA` if
no offsets have been set.

------------------------------------------------------------------------

### Method [`slice()`](https://r-cf.github.io/CFtime/reference/slice.md)

Given a vector of character timestamps, return a logical vector of a
length equal to the number of time steps in the time series with values
`TRUE` for those time steps that fall between the two extreme values of
the vector values, `FALSE` otherwise.

#### Usage

    CFTime$slice(extremes, closed = FALSE)

#### Arguments

- `extremes`:

  Character vector of timestamps that represent the time period of
  interest. The extreme values are selected. Badly formatted timestamps
  are silently dropped.

- `closed`:

  Is the right side closed, i.e. included in the result? Default is
  `FALSE`. A specification of `c("2022-01-01", "2023-01-01)` will thus
  include all time steps that fall in the year 2022 when
  `closed = FALSE` but include `2023-01-01` if that exact value is
  present in the time series.

#### Returns

A logical vector with a length equal to the number of time steps in
`self` with values `TRUE` for those time steps that fall between the
extreme values, `FALSE` otherwise.

An attribute 'CFTime' will have the same definition as `self` but with
offsets corresponding to the time steps falling between the two
extremes. If there are no values between the extremes, the attribute is
not set.

------------------------------------------------------------------------

### Method `POSIX_compatible()`

Can the time series be converted to POSIXt?

#### Usage

    CFTime$POSIX_compatible()

#### Returns

`TRUE` if the calendar support conversion to POSIXt, `FALSE` otherwise.

------------------------------------------------------------------------

### Method [`cut()`](https://r-cf.github.io/CFtime/reference/cut.CFTime.md)

Create a factor for a `CFTime` instance.

When argument `breaks` is one of
`"year", "season", "quarter", "month", "dekad", "day"`, a factor is
generated like by
[`CFfactor()`](https://r-cf.github.io/CFtime/reference/CFfactor.md).
When `breaks` is a vector of character timestamps a factor is produced
with a level for every interval between timestamps. The last timestamp,
therefore, is only used to close the interval started by the
pen-ultimate timestamp - use a distant timestamp (e.g. `range(x)[2]`) to
ensure that all offsets to the end of the CFTime time series are
included, if so desired. The last timestamp will become the upper bound
in the `CFTime` instance that is returned as an attribute to this
function so a sensible value for the last timestamp is advisable.

This method works similar to
[`base::cut.POSIXt()`](https://rdrr.io/r/base/cut.POSIXt.html) but there
are some differences in the arguments: for `breaks` the set of options
is different and no preceding integer is allowed, `labels` are always
assigned using values of `breaks`, and the interval is always
left-closed.

#### Usage

    CFTime$cut(breaks)

#### Arguments

- `breaks`:

  A character string of a factor period (see
  [`CFfactor()`](https://r-cf.github.io/CFtime/reference/CFfactor.md)
  for a description), or a character vector of timestamps that conform
  to the calendar of `x`, with a length of at least 2. Timestamps must
  be given in ISO8601 format, e.g. "2024-04-10 21:31:43".

#### Returns

A factor with levels according to the `breaks` argument, with attributes
'period', 'era' and 'CFTime'. When `breaks` is a factor period,
attribute 'period' has that value, otherwise it is '"day"'. When
`breaks` is a character vector of timestamps, attribute 'CFTime' holds
an instance of `CFTime` that has the same definition as `x`, but with
(ordered) offsets generated from the `breaks`. Attribute 'era' is always
-1.

------------------------------------------------------------------------

### Method [`factor()`](https://rdrr.io/r/base/factor.html)

Generate a factor for the offsets, or a part thereof. This is
specifically interesting for creating factors from the date part of the
time series that aggregate the time series into longer time periods
(such as month) that can then be used to process daily CF data sets
using, for instance, [`tapply()`](https://rdrr.io/r/base/tapply.html).

The factor will respect the calendar that the time series is built on.

The factor will be generated in the order of the offsets. While typical
CF-compliant data sources use ordered time series there is, however, no
guarantee that the factor is ordered. For most processing with a factor
the ordering is of no concern.

If the `era` parameter is specified, either as a vector of years to
include in the factor, or as a list of such vectors, the factor will
only consider those values in the time series that fall within the list
of years, inclusive of boundary values. Other values in the factor will
be set to `NA`.

The following periods are supported by this method:

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
the temporal resolution of the calendar. As an example, if the calendar
has a monthly unit, a dekad or day factor cannot be created.

Creating factors for other periods is not supported by this method.
Factors based on the timestamp information and not dependent on the
calendar can trivially be constructed from the output of the
[`as_timestamp()`](https://r-cf.github.io/CFtime/reference/as_timestamp.md)
function.

Attribute 'CFTime' of the result contains a `CFTime` instance that is
valid for the result of applying the factor to a resource that this
instance is associated with. In other words, if `CFTime` instance 'At'
describes the temporal dimension of resource 'A' and a factor 'Af' is
generated from `Af <- At$factor()`, then `Bt <- attr(Af, "CFTime")`
describes the temporal dimension of the result of, say,
`B <- apply(A, 1:2, tapply, Af, FUN)`. The 'CFTime' attribute contains a
[CFClimatology](https://r-cf.github.io/CFtime/reference/CFClimatology.md)
instance for era factors.

#### Usage

    CFTime$factor(period = "month", era = NULL)

#### Arguments

- `period`:

  character. A character string with one of the values "year", "season",
  "quarter", "month" (the default), "dekad" or "day".

- `era`:

  numeric or list, optional. Vector of years for which to construct the
  factor, or a list whose elements are each a vector of years. The
  extreme values of the supplied vector will be used. Note that if a
  single year is specified that the result is valid, but not a
  climatological statistic. If `era` is not specified, the factor will
  use the entire time series for the factor.

#### Returns

If `era` is a single vector or `NULL`, a factor with a length equal to
the number of offsets in this instance. If `era` is a list, a list with
the same number of elements and names as `era`, each containing a
factor. Elements in the factor will be set to `NA` for time series
values outside of the range of specified years.

The factor, or factors in the list, have attributes 'period', 'era' and
'CFTime'. Attribute 'period' holds the value of the `period` argument.
Attribute 'era' indicates the number of years that are included in the
era, or -1 if no `era` is provided. Attribute 'CFTime' holds an instance
of `CFTime` or `CFClimatology` that has the same definition as this
instance, but with offsets corresponding to the mid-point of the factor
levels.

------------------------------------------------------------------------

### Method `factor_units()`

Given a factor as produced by `CFTime$factor()`, this method will return
a numeric vector with the number of time units in each level of the
factor.

The result of this method is useful to convert between absolute and
relative values. Climate change anomalies, for instance, are usually
computed by differencing average values between a future period and a
baseline period. Going from average values back to absolute values for
an aggregate period (which is typical for temperature and precipitation,
among other variables) is easily done with the result of this method,
without having to consider the specifics of the calendar of the data
set.

If the factor `f` is for an era (e.g. spanning multiple years and the
levels do not indicate the specific year), then the result will indicate
the number of time units of the period in a regular single year. In
other words, for an era of 2041-2060 and a monthly factor on a standard
calendar with a `days` unit, the result will be
`c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)`. Leap days are thus
only considered for the `366_day` and `all_leap` calendars.

Note that this function gives the number of time units in each level of
the factor - the actual number of data points in the time series per
factor level may be different. Use
[`CFfactor_coverage()`](https://r-cf.github.io/CFtime/reference/CFfactor_coverage.md)
to determine the actual number of data points or the coverage of data
points relative to the factor level.

#### Usage

    CFTime$factor_units(f)

#### Arguments

- `f`:

  A factor or a list of factors derived from the method
  `CFTime$factor()`.

#### Returns

If `f` is a factor, a numeric vector with a length equal to the number
of levels in the factor, indicating the number of time units in each
level of the factor. If `f` is a list of factors, a list with each
element a numeric vector as above.

------------------------------------------------------------------------

### Method `factor_coverage()`

Calculate the number of time elements, or the relative coverage, in each
level of a factor generated by `CFTime$factor()`.

#### Usage

    CFTime$factor_coverage(f, coverage = "absolute")

#### Arguments

- `f`:

  A factor or a list of factors derived from the method
  `CFTime$factor()`.

- `coverage`:

  "absolute" or "relative".

#### Returns

If `f` is a factor, a numeric vector with a length equal to the number
of levels in the factor, indicating the number of units from the time
series contained in each level of the factor when
`coverage = "absolute"` or the proportion of units present relative to
the maximum number when `coverage = "relative"`. If `f` is a list of
factors, a list with each element a numeric vector as above.

------------------------------------------------------------------------

### Method `copy()`

Create a copy of the current instance. The copy is completely separate
from the current instance.

#### Usage

    CFTime$copy()

#### Returns

A new `CFTime` instance with identical definition and set of timestamps.

------------------------------------------------------------------------

### Method [`subset()`](https://rdrr.io/r/base/subset.html)

Get a new `CFTime` instance that is a subset of the current instance,
including any boundary values.

#### Usage

    CFTime$subset(rng)

#### Arguments

- `rng`:

  The numeric range of indices to subset this instance to.

#### Returns

A new `CFTime` instance with identical definition and set of timestamps
according to the `rng` argument.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    CFTime$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
