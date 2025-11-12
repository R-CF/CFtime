# Julian CF calendar

This class represents a Julian calendar of 365 days per year, with every
fourth year being a leap year of 366 days. The months and the year align
with the standard calendar. This calendar is not compatible with the
standard POSIXt calendar.

This calendar starts on 1 January of year 1: 0001-01-01 00:00:00. Any
dates before this will generate an error.

## Super class

[`CFtime::CFCalendar`](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
-\> `CFCalendarJulian`

## Methods

### Public methods

- [`CFCalendarJulian$new()`](#method-CFCalendarJulian-new)

- [`CFCalendarJulian$valid_days()`](#method-CFCalendarJulian-valid_days)

- [`CFCalendarJulian$month_days()`](#method-CFCalendarJulian-month_days)

- [`CFCalendarJulian$leap_year()`](#method-CFCalendarJulian-leap_year)

- [`CFCalendarJulian$date2offset()`](#method-CFCalendarJulian-date2offset)

- [`CFCalendarJulian$offset2date()`](#method-CFCalendarJulian-offset2date)

- [`CFCalendarJulian$clone()`](#method-CFCalendarJulian-clone)

Inherited methods

- [`CFtime::CFCalendar$POSIX_compatible()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-POSIX_compatible)
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

    CFCalendarJulian$new(nm, definition)

#### Arguments

- `nm`:

  The name of the calendar. This must be "julian". This argument is
  superfluous but maintained to be consistent with the initialization
  methods of the parent and sibling classes.

- `definition`:

  The string that defines the units and the origin, as per the CF
  Metadata Conventions.

#### Returns

A new instance of this class.

------------------------------------------------------------------------

### Method `valid_days()`

Indicate which of the supplied dates are valid.

#### Usage

    CFCalendarJulian$valid_days(ymd)

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

    CFCalendarJulian$month_days(ymd = NULL)

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

    CFCalendarJulian$leap_year(yr)

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

    CFCalendarJulian$date2offset(x)

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

    CFCalendarJulian$offset2date(x)

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

    CFCalendarJulian$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
