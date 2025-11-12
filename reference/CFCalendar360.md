# 360-day CF calendar

This class represents a CF calendar of 360 days per year, evenly divided
over 12 months of 30 days. This calendar is obviously not compatible
with the standard POSIXt calendar.

This calendar supports dates before year 1 and includes the year 0.

## Super class

[`CFtime::CFCalendar`](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
-\> `CFCalendar360`

## Methods

### Public methods

- [`CFCalendar360$new()`](#method-CFCalendar360-new)

- [`CFCalendar360$valid_days()`](#method-CFCalendar360-valid_days)

- [`CFCalendar360$month_days()`](#method-CFCalendar360-month_days)

- [`CFCalendar360$leap_year()`](#method-CFCalendar360-leap_year)

- [`CFCalendar360$date2offset()`](#method-CFCalendar360-date2offset)

- [`CFCalendar360$offset2date()`](#method-CFCalendar360-offset2date)

- [`CFCalendar360$clone()`](#method-CFCalendar360-clone)

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

    CFCalendar360$new(nm, definition)

#### Arguments

- `nm`:

  The name of the calendar. This must be "360_day". This argument is
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

    CFCalendar360$valid_days(ymd)

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

    CFCalendar360$month_days(ymd = NULL)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. Any other columns are disregarded.

#### Returns

A vector indicating the number of days in each month for the dates
supplied as argument `ymd`. If no dates are supplied, the number of days
per month for the calendar as a vector of length 12.

------------------------------------------------------------------------

### Method `leap_year()`

Indicate which years are leap years.

#### Usage

    CFCalendar360$leap_year(yr)

#### Arguments

- `yr`:

  Integer vector of years to test.

#### Returns

Logical vector with the same length as argument `yr`. Since this
calendar does not use leap days, all values will be `FALSE`, or `NA`
where argument `yr` is `NA`.

------------------------------------------------------------------------

### Method `date2offset()`

Calculate difference in days between a `data.frame` of time parts and
the origin.

#### Usage

    CFCalendar360$date2offset(x)

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

    CFCalendar360$offset2date(x)

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

    CFCalendar360$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
