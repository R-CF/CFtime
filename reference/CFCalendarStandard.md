# Standard CF calendar

This class represents a standard calendar of 365 or 366 days per year.
This calendar is compatible with the standard POSIXt calendar for
periods after the introduction of the Gregorian calendar, 1582-10-15
00:00:00. The calendar starts at 0001-01-01 00:00:00, e.g. the start of
the Common Era.

Note that this calendar, despite its name, is not the same as that used
in ISO8601 or many computer systems for periods prior to the
introduction of the Gregorian calendar. Use of the "proleptic_gregorian"
calendar is recommended for periods before or straddling the
introduction date, as that calendar is compatible with POSIXt on most
OSes.

## Super class

[`CFtime::CFCalendar`](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
-\> `CFCalendarStandard`

## Methods

### Public methods

- [`CFCalendarStandard$new()`](#method-CFCalendarStandard-new)

- [`CFCalendarStandard$valid_days()`](#method-CFCalendarStandard-valid_days)

- [`CFCalendarStandard$is_gregorian_date()`](#method-CFCalendarStandard-is_gregorian_date)

- [`CFCalendarStandard$POSIX_compatible()`](#method-CFCalendarStandard-POSIX_compatible)

- [`CFCalendarStandard$month_days()`](#method-CFCalendarStandard-month_days)

- [`CFCalendarStandard$leap_year()`](#method-CFCalendarStandard-leap_year)

- [`CFCalendarStandard$date2offset()`](#method-CFCalendarStandard-date2offset)

- [`CFCalendarStandard$offset2date()`](#method-CFCalendarStandard-offset2date)

- [`CFCalendarStandard$clone()`](#method-CFCalendarStandard-clone)

Inherited methods

- [`CFtime::CFCalendar$add_day()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-add_day)
- [`CFtime::CFCalendar$is_compatible()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-is_compatible)
- [`CFtime::CFCalendar$is_equivalent()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-is_equivalent)
- [`CFtime::CFCalendar$offsets2time()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-offsets2time)
- [`CFtime::CFCalendar$parse()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-parse)
- [`CFtime::CFCalendar$print()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a new CF calendar. When called with the deprecated 'gregorian' it
is automatically converted to the equivalent 'standard'.

#### Usage

    CFCalendarStandard$new(nm, definition)

#### Arguments

- `nm`:

  The name of the calendar. This must be "standard" or "gregorian"
  (deprecated).

- `definition`:

  The string that defines the units and the origin, as per the CF
  Metadata Conventions.

#### Returns

A new instance of this class.

------------------------------------------------------------------------

### Method `valid_days()`

Indicate which of the supplied dates are valid.

#### Usage

    CFCalendarStandard$valid_days(ymd)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. Any other columns are disregarded.

#### Returns

Logical vector with the same length as argument `ymd` has rows with
`TRUE` for valid days and `FALSE` for invalid days, or `NA` where the
row in argument `ymd` has `NA` values.

------------------------------------------------------------------------

### Method `is_gregorian_date()`

Indicate which of the supplied dates are in the Gregorian part of the
calendar, e.g. 1582-10-15 or after.

#### Usage

    CFCalendarStandard$is_gregorian_date(ymd)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. Any other columns are disregarded.

#### Returns

Logical vector with the same length as argument `ymd` has rows with
`TRUE` for days in the Gregorian part of the calendar and `FALSE`
otherwise, or `NA` where the row in argument `ymd` has `NA` values.

------------------------------------------------------------------------

### Method `POSIX_compatible()`

Indicate if the time series described using this calendar can be safely
converted to a standard date-time type (`POSIXct`, `POSIXlt`, `Date`).
This is only the case if all offsets are for timestamps fall on or after
the start of the Gregorian calendar, 1582-10-15 00:00:00.

#### Usage

    CFCalendarStandard$POSIX_compatible(offsets)

#### Arguments

- `offsets`:

  The offsets from the CFtime instance.

#### Returns

`TRUE`.

------------------------------------------------------------------------

### Method [`month_days()`](https://r-cf.github.io/CFtime/reference/month_days.md)

Determine the number of days in the month of the calendar.

#### Usage

    CFCalendarStandard$month_days(ymd = NULL)

#### Arguments

- `ymd`:

  `data.frame`, optional, with dates parsed into their parts.

#### Returns

A vector indicating the number of days in each month for the dates
supplied as argument `ymd`. If no dates are supplied, the number of days
per month for the calendar as a vector of length 12, for a regular year
without a leap day.

------------------------------------------------------------------------

### Method `leap_year()`

Indicate which years are leap years.

#### Usage

    CFCalendarStandard$leap_year(yr)

#### Arguments

- `yr`:

  Integer vector of years to test.

#### Returns

Logical vector with the same length as argument `yr`. `NA` is returned
where elements in argument `yr` are `NA`.

------------------------------------------------------------------------

### Method `date2offset()`

Calculate difference in days between a `data.frame` of time parts and
the origin.

#### Usage

    CFCalendarStandard$date2offset(x)

#### Arguments

- `x`:

  `data.frame`. Dates to calculate the difference for.

#### Returns

Integer vector of a length equal to the number of rows in argument `x`
indicating the number of days between `x` and the origin of the
calendar, or `NA` for rows in `x` with `NA` values.

------------------------------------------------------------------------

### Method `offset2date()`

Calculate date parts from day differences from the origin. This only
deals with days as these are impacted by the calendar.
Hour-minute-second timestamp parts are handled in
[CFCalendar](https://r-cf.github.io/CFtime/reference/CFCalendar.md).

#### Usage

    CFCalendarStandard$offset2date(x)

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

    CFCalendarStandard$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
