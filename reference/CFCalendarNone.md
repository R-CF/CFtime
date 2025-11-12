# CF calendar with no annual cycle

This class represents a CF calendar with no annual cycle. All datetimes
in the calendar are the same. This is useful only for repeated
experiments simulating a fixed time in the year.

## Super class

[`CFtime::CFCalendar`](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
-\> `CFCalendarNone`

## Methods

### Public methods

- [`CFCalendarNone$new()`](#method-CFCalendarNone-new)

- [`CFCalendarNone$valid_days()`](#method-CFCalendarNone-valid_days)

- [`CFCalendarNone$month_days()`](#method-CFCalendarNone-month_days)

- [`CFCalendarNone$leap_year()`](#method-CFCalendarNone-leap_year)

- [`CFCalendarNone$date2offset()`](#method-CFCalendarNone-date2offset)

- [`CFCalendarNone$offset2date()`](#method-CFCalendarNone-offset2date)

- [`CFCalendarNone$clone()`](#method-CFCalendarNone-clone)

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

    CFCalendarNone$new(nm, definition)

#### Arguments

- `nm`:

  The name of the calendar. This must be "none". This argument is
  superfluous but maintained to be consistent with the initialization
  methods of the parent and sibling classes.

- `definition`:

  The string that defines the units and the origin, as per the CF
  Metadata Conventions.

#### Returns

A new instance of this class.

------------------------------------------------------------------------

### Method `valid_days()`

Indicate which of the supplied dates are valid. In this calendar only
one date is valid, namely the one that the calendar is initialized with.

#### Usage

    CFCalendarNone$valid_days(ymd)

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

Determine the number of days in the month of the calendar. This always
returns a vector of `NA` values because this method has no meaning for
this class.

#### Usage

    CFCalendarNone$month_days(ymd = NULL)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. Any other columns are disregarded.

#### Returns

A vector with `NA` values for the dates supplied as argument `ymd`. If
no dates are supplied, a vector of `NA` values of length 12.

------------------------------------------------------------------------

### Method `leap_year()`

Indicate which years are leap years. This always returns a vector of
`NA` values because this method has no meaning for this class.

#### Usage

    CFCalendarNone$leap_year(yr)

#### Arguments

- `yr`:

  Integer vector of years to test.

#### Returns

Vector with the same length as argument `yr` with `NA` values.

------------------------------------------------------------------------

### Method `date2offset()`

Calculate difference in days between a `data.frame` of time parts and
the origin. The difference is always 0, given that this is not a true
calendar and there can be no calculations to determine any difference.

#### Usage

    CFCalendarNone$date2offset(x)

#### Arguments

- `x`:

  `data.frame`. Dates to calculate the difference for.

#### Returns

Integer vector of a length equal to the number of rows in argument `x`
indicating 0 for the days that equal the origin of the calendar, or `NA`
otherwise.

------------------------------------------------------------------------

### Method `offset2date()`

Calculate date parts from day differences from the origin. This always
returns 0's for the year, month and day as other values are not valid in
this calendar. Hour-minute-second datetime parts are handled in
[CFCalendar](https://r-cf.github.io/CFtime/reference/CFCalendar.md).

#### Usage

    CFCalendarNone$offset2date(x)

#### Arguments

- `x`:

  Integer vector of days to add to the origin.

#### Returns

A `data.frame` with columns 'year', 'month' and 'day' and as many rows
as the length of vector `x`. Rows with values of `x` other than 0 will
return the values for the origin of the calendar nonetheless, in
accordance with the CF Metadata Conventions.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    CFCalendarNone$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
