# Proleptic Gregorian CF calendar

This class represents a standard CF calendar, but with the Gregorian
calendar extended backwards to before the introduction of the Gregorian
calendar. This calendar is compatible with the standard POSIXt calendar,
but note that daylight savings time is not considered.

This calendar includes dates 1582-10-14 to 1582-10-05 (the gap between
the Gregorian and Julian calendars, which is observed by the standard
calendar), and extends to years before the year 1, including year 0.

## Super class

[`CFtime::CFCalendar`](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
-\> `CFCalendarProleptic`

## Methods

### Public methods

- [`CFCalendarProleptic$new()`](#method-CFCalendarProleptic-new)

- [`CFCalendarProleptic$valid_days()`](#method-CFCalendarProleptic-valid_days)

- [`CFCalendarProleptic$month_days()`](#method-CFCalendarProleptic-month_days)

- [`CFCalendarProleptic$leap_year()`](#method-CFCalendarProleptic-leap_year)

- [`CFCalendarProleptic$POSIX_compatible()`](#method-CFCalendarProleptic-POSIX_compatible)

- [`CFCalendarProleptic$date2offset()`](#method-CFCalendarProleptic-date2offset)

- [`CFCalendarProleptic$offset2date()`](#method-CFCalendarProleptic-offset2date)

- [`CFCalendarProleptic$clone()`](#method-CFCalendarProleptic-clone)

Inherited methods

- [`CFtime::CFCalendar$add_day()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-add_day)
- [`CFtime::CFCalendar$is_compatible()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-is_compatible)
- [`CFtime::CFCalendar$is_equivalent()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-is_equivalent)
- [`CFtime::CFCalendar$offsets2time()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-offsets2time)
- [`CFtime::CFCalendar$parse()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-parse)
- [`CFtime::CFCalendar$print()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a new CF calendar.

#### Usage

    CFCalendarProleptic$new(nm, definition)

#### Arguments

- `nm`:

  The name of the calendar. This must be "proleptic_gregorian". This
  argument is superfluous but maintained to be consistent with the
  initialization methods of the parent and sibling classes.

- `definition`:

  The string that defines the units and the origin, as per the CF
  Metadata Conventions.

#### Returns

A new instance of this class.

------------------------------------------------------------------------

### Method `valid_days()`

Indicate which of the supplied dates are valid.

#### Usage

    CFCalendarProleptic$valid_days(ymd)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. Any other columns are disregarded.

#### Returns

Logical vector with the same length as argument `ymd` has rows with
`TRUE` for valid days and `FALSE` for invalid days, or `NA` where the
row in argument `ymd` has `NA` values.

------------------------------------------------------------------------

### Method [`month_days()`](https://r-cf.github.io/CFtime/reference/month_days.md)

Determine the number of days in the month of the calendar.

#### Usage

    CFCalendarProleptic$month_days(ymd = NULL)

#### Arguments

- `ymd`:

  `data.frame`, optional, with dates parsed into their parts.

#### Returns

Integer vector indicating the number of days in each month for the dates
supplied as argument `ymd`. If no dates are supplied, the number of days
per month for the calendar as a vector of length 12, for a regular year
without a leap day.

------------------------------------------------------------------------

### Method `leap_year()`

Indicate which years are leap years.

#### Usage

    CFCalendarProleptic$leap_year(yr)

#### Arguments

- `yr`:

  Integer vector of years to test.

#### Returns

Logical vector with the same length as argument `yr`. `NA` is returned
where elements in argument `yr` are `NA`.

------------------------------------------------------------------------

### Method `POSIX_compatible()`

Indicate if the time series described using this calendar can be safely
converted to a standard date-time type (`POSIXct`, `POSIXlt`, `Date`).

#### Usage

    CFCalendarProleptic$POSIX_compatible(offsets)

#### Arguments

- `offsets`:

  The offsets from the CFtime instance.

#### Returns

`TRUE`.

------------------------------------------------------------------------

### Method `date2offset()`

Calculate difference in days between a `data.frame` of time parts and
the origin.

#### Usage

    CFCalendarProleptic$date2offset(x)

#### Arguments

- `x`:

  `data.frame`. Dates to calculate the difference for.

#### Returns

Integer vector of a length equal to the number of rows in argument `x`
indicating the number of days between `x` and the `origin`, or `NA` for
rows in `x` with `NA` values.

------------------------------------------------------------------------

### Method `offset2date()`

Calculate date parts from day differences from the origin. This only
deals with days as these are impacted by the calendar.
Hour-minute-second timestamp parts are handled in
[CFCalendar](https://r-cf.github.io/CFtime/reference/CFCalendar.md).

#### Usage

    CFCalendarProleptic$offset2date(x)

#### Arguments

- `x`:

  Integer vector of days to add to the origin.

#### Returns

A `data.frame` with columns 'year', 'month' and 'day' and as many rows
as the length of vector `x`.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    CFCalendarProleptic$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
