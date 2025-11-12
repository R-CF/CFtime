# Coordinated Universal Time CF calendar

This class represents a calendar based on the Coordinated Universal
Time. Validity is from 1972 onwards, with dates represented using the
Gregorian calendar, up to the present (so future timestamps are not
allowed). Leap seconds are considered in all calculations. Also, time
zone information is irrelevant and may not be given.

In general, the calendar should use a unit of time of a second. Minute,
hour and day are allowed but discouraged. Month and year as time unit
are not allowed as there is no practical way to maintain leap second
accuracy.

## Super classes

[`CFtime::CFCalendar`](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
-\>
[`CFtime::CFCalendarProleptic`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.md)
-\> `CFCalendarUTC`

## Methods

### Public methods

- [`CFCalendarUTC$new()`](#method-CFCalendarUTC-new)

- [`CFCalendarUTC$valid_days()`](#method-CFCalendarUTC-valid_days)

- [`CFCalendarUTC$parse()`](#method-CFCalendarUTC-parse)

- [`CFCalendarUTC$offsets2time()`](#method-CFCalendarUTC-offsets2time)

- [`CFCalendarUTC$clone()`](#method-CFCalendarUTC-clone)

Inherited methods

- [`CFtime::CFCalendar$add_day()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-add_day)
- [`CFtime::CFCalendar$is_compatible()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-is_compatible)
- [`CFtime::CFCalendar$is_equivalent()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-is_equivalent)
- [`CFtime::CFCalendar$print()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-print)
- [`CFtime::CFCalendarProleptic$POSIX_compatible()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-POSIX_compatible)
- [`CFtime::CFCalendarProleptic$date2offset()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-date2offset)
- [`CFtime::CFCalendarProleptic$leap_year()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-leap_year)
- [`CFtime::CFCalendarProleptic$month_days()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-month_days)
- [`CFtime::CFCalendarProleptic$offset2date()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-offset2date)

------------------------------------------------------------------------

### Method `new()`

Create a new CF UTC calendar.

#### Usage

    CFCalendarUTC$new(nm, definition)

#### Arguments

- `nm`:

  The name of the calendar. This must be "utc".

- `definition`:

  The string that defines the units and the origin, as per the CF
  Metadata Conventions.

------------------------------------------------------------------------

### Method `valid_days()`

Indicate which of the supplied dates are valid.

#### Usage

    CFCalendarUTC$valid_days(ymd)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. Any other columns are disregarded.

#### Returns

Logical vector with the same length as argument `ymd` has rows with
`TRUE` for valid days and `FALSE` for invalid days, or `NA` where the
row in argument `ymd` has `NA` values.

------------------------------------------------------------------------

### Method [`parse()`](https://rdrr.io/r/base/parse.html)

Parsing a vector of date-time character strings into parts. This
includes any leap seconds. Time zone indications are not allowed.

#### Usage

    CFCalendarUTC$parse(d)

#### Arguments

- `d`:

  character. A character vector of date-times.

#### Returns

A `data.frame` with columns year, month, day, hour, minute, second, time
zone, and offset. Invalid input data will appear as `NA`. Note that the
time zone is always "+0000" and is included to maintain compatibility
with results from other calendars.

------------------------------------------------------------------------

### Method `offsets2time()`

Decompose a vector of offsets, in units of the calendar, to their
timestamp values. This adds a specified amount of time to the origin of
a `CFTime` object.

#### Usage

    CFCalendarUTC$offsets2time(offsets = NULL)

#### Arguments

- `offsets`:

  Vector of numeric offsets to add to the origin of the calendar.

#### Returns

A `data.frame` with columns for the timestamp elements and as many rows
as there are offsets.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    CFCalendarUTC$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
