# 366-day CF calendar

This class represents a CF calendar of 366 days per year, having leap
days in every year. This calendar is not compatible with the standard
POSIXt calendar.

This calendar supports dates before year 1 and includes the year 0.

## Super class

[`CFtime::CFCalendar`](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
-\> `CFCalendar366`

## Methods

### Public methods

- [`CFCalendar366$new()`](#method-CFCalendar366-new)

- [`CFCalendar366$valid_days()`](#method-CFCalendar366-valid_days)

- [`CFCalendar366$month_days()`](#method-CFCalendar366-month_days)

- [`CFCalendar366$leap_year()`](#method-CFCalendar366-leap_year)

- [`CFCalendar366$date2offset()`](#method-CFCalendar366-date2offset)

- [`CFCalendar366$offset2date()`](#method-CFCalendar366-offset2date)

- [`CFCalendar366$clone()`](#method-CFCalendar366-clone)

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

Create a new CF calendar of 366 days per year.

#### Usage

    CFCalendar366$new(nm, definition)

#### Arguments

- `nm`:

  The name of the calendar. This must be "366_day" or "all_leap".

- `definition`:

  The string that defines the units and the origin, as per the CF
  Metadata Conventions.

#### Returns

A new instance of this class.

------------------------------------------------------------------------

### Method `valid_days()`

Indicate which of the supplied dates are valid.

#### Usage

    CFCalendar366$valid_days(ymd)

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

    CFCalendar366$month_days(ymd = NULL)

#### Arguments

- `ymd`:

  `data.frame`, optional, with dates parsed into their parts.

#### Returns

A vector indicating the number of days in each month for the dates
supplied as argument `ymd`. If no dates are supplied, the number of days
per month for the calendar as a vector of length 12.

------------------------------------------------------------------------

### Method `leap_year()`

Indicate which years are leap years.

#### Usage

    CFCalendar366$leap_year(yr)

#### Arguments

- `yr`:

  Integer vector of years to test.

#### Returns

Logical vector with the same length as argument `yr`. Since in this
calendar all years have a leap day, all values will be `TRUE`, or `NA`
where argument `yr` is `NA`.

------------------------------------------------------------------------

### Method `date2offset()`

Calculate difference in days between a `data.frame` of time parts and
the origin.

#### Usage

    CFCalendar366$date2offset(x)

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

    CFCalendar366$offset2date(x)

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

    CFCalendar366$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
