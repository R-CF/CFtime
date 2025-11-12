# Basic CF calendar

This class represents a basic CF calendar. It should not be instantiated
directly; instead, use one of the descendant classes.

This internal class stores the information to represent date and time
values using the CF conventions. An instance is created by the exported
[CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) class, which
also exposes the relevant properties of this class.

The following calendars are supported:

- [`gregorian\standard`](https://r-cf.github.io/CFtime/reference/CFCalendarStandard.md),
  the international standard calendar for civil use.

- [`proleptic_gregorian`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.md),
  the standard calendar but extending before 1582-10-15 when the
  Gregorian calendar was adopted.

- [`tai`](https://r-cf.github.io/CFtime/reference/CFCalendarTAI.md),
  International Atomic Time clock with dates expressed using the
  Gregorian calendar.

- [`utc`](https://r-cf.github.io/CFtime/reference/CFCalendarUTC.md),
  Coordinated Universal Time clock with dates expressed using the
  Gregorian calendar.

- [`julian`](https://r-cf.github.io/CFtime/reference/CFCalendarJulian.md),
  every fourth year is a leap year.

- [`noleap\365_day`](https://r-cf.github.io/CFtime/reference/CFCalendar365.md),
  all years have 365 days.

- [`all_leap\366_day`](https://r-cf.github.io/CFtime/reference/CFCalendar366.md),
  all years have 366 days.

- [`360_day`](https://r-cf.github.io/CFtime/reference/CFCalendar360.md),
  all years have 360 days, divided over 12 months of 30 days.

## References

https://cfconventions.org/Data/cf-conventions/cf-conventions-1.12/cf-conventions.html#calendar

## Active bindings

- `name`:

  (read-only) Name of the calendar, as per the CF Metadata Conventions.

- `definition`:

  (read-only) The string that defines the units and the origin, as per
  the CF Metadata Conventions.

- `unit`:

  (read-only) The numeric id of the unit of the calendar.

- `prefix_id`:

  (read-only) The index value of the prefix of the time unit. If the
  unit does not have a prefix, returns the value 0L.

- `origin`:

  (read-only) `data.frame` with fields for the origin of the calendar.

- `origin_date`:

  (read-only) Character string with the date of the calendar.

- `origin_time`:

  (read-only) Character string with the time of the calendar.

- `timezone`:

  (read-only) Character string with the time zone of the origin of the
  calendar.

## Methods

### Public methods

- [`CFCalendar$new()`](#method-CFCalendar-new)

- [`CFCalendar$print()`](#method-CFCalendar-print)

- [`CFCalendar$valid_days()`](#method-CFCalendar-valid_days)

- [`CFCalendar$add_day()`](#method-CFCalendar-add_day)

- [`CFCalendar$POSIX_compatible()`](#method-CFCalendar-POSIX_compatible)

- [`CFCalendar$is_compatible()`](#method-CFCalendar-is_compatible)

- [`CFCalendar$is_equivalent()`](#method-CFCalendar-is_equivalent)

- [`CFCalendar$parse()`](#method-CFCalendar-parse)

- [`CFCalendar$offsets2time()`](#method-CFCalendar-offsets2time)

- [`CFCalendar$clone()`](#method-CFCalendar-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new CF calendar.

#### Usage

    CFCalendar$new(nm, definition)

#### Arguments

- `nm`:

  The name of the calendar. This must follow the CF Metadata
  Conventions.

- `definition`:

  The string that defines the units and the origin, as per the CF
  Metadata Conventions.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print information about the calendar to the console.

#### Usage

    CFCalendar$print(...)

#### Arguments

- `...`:

  Ignored.

#### Returns

`self`, invisibly.

------------------------------------------------------------------------

### Method `valid_days()`

Indicate which of the supplied dates are valid.

#### Usage

    CFCalendar$valid_days(ymd)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. Any other columns are disregarded.

#### Returns

`NULL`. A warning will be generated to the effect that a descendant
class should be used for this method.

------------------------------------------------------------------------

### Method `add_day()`

Add a day to the supplied dates.

#### Usage

    CFCalendar$add_day(ymd)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. Any other columns are disregarded.

#### Returns

A `data.frame` like argument `ymd` but with a day added for every row.

------------------------------------------------------------------------

### Method `POSIX_compatible()`

Indicate if the time series described using this calendar can be safely
converted to a standard date-time type (`POSIXct`, `POSIXlt`, `Date`).

Only the 'standard' calendar and the 'proleptic_gregorian' calendar when
all dates in the time series are more recent than 1582-10-15 (inclusive)
can be safely converted, so this method returns `FALSE` by default to
cover the majority of cases.

#### Usage

    CFCalendar$POSIX_compatible(offsets)

#### Arguments

- `offsets`:

  The offsets from the CFtime instance.

#### Returns

`FALSE` by default.

------------------------------------------------------------------------

### Method `is_compatible()`

This method tests if the `CFCalendar` instance in argument `cal` is
compatible with `self`, meaning that they are of the same class and have
the same unit and prefix. Calendars "standard", and "gregorian" are
compatible, as are the pairs of "365_day" and "no_leap", and "366_day"
and "all_leap".

#### Usage

    CFCalendar$is_compatible(cal)

#### Arguments

- `cal`:

  Instance of a descendant of the `CFCalendar` class.

#### Returns

`TRUE` if the instance in argument `cal` is compatible with `self`,
`FALSE` otherwise.

------------------------------------------------------------------------

### Method `is_equivalent()`

This method tests if the `CFCalendar` instance in argument `cal` is
equivalent to `self`, meaning that they are of the same class, have the
same unit and prefix, and equivalent origins. Calendars "standard", and
"gregorian" are equivalent, as are the pairs of "365_day" and "no_leap",
and "366_day" and "all_leap".

Note that the origins need not be identical, but their parsed values
have to be. "2000-01" is parsed the same as "2000-01-01 00:00:00", for
instance.

#### Usage

    CFCalendar$is_equivalent(cal)

#### Arguments

- `cal`:

  Instance of a descendant of the `CFCalendar` class.

#### Returns

`TRUE` if the instance in argument `cal` is equivalent to `self`,
`FALSE` otherwise.

------------------------------------------------------------------------

### Method [`parse()`](https://rdrr.io/r/base/parse.html)

Parsing a vector of date-time character strings into parts.

#### Usage

    CFCalendar$parse(d)

#### Arguments

- `d`:

  character. A character vector of date-times.

#### Returns

A `data.frame` with columns year, month, day, hour, minute, second, time
zone, and offset. Invalid input data will appear as `NA`.

------------------------------------------------------------------------

### Method `offsets2time()`

Decompose a vector of offsets, in units of the calendar, to their
timestamp values. This adds a specified amount of time to the origin of
a `CFTime` object.

This method may introduce inaccuracies where the calendar unit is
"months" or "years", due to the ambiguous definition of these units.

#### Usage

    CFCalendar$offsets2time(offsets = NULL)

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

    CFCalendar$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
