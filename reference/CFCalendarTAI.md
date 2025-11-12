# International Atomic Time CF calendar

This class represents a calendar based on the International Atomic Time.
Validity is from 1958 onwards, with dates represented using the
Gregorian calendar. Given that this "calendar" is based on a universal
clock, the concepts of leap second, time zone and daylight savings time
do not apply.

## Super classes

[`CFtime::CFCalendar`](https://r-cf.github.io/CFtime/reference/CFCalendar.md)
-\>
[`CFtime::CFCalendarProleptic`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.md)
-\> `CFCalendarTAI`

## Methods

### Public methods

- [`CFCalendarTAI$valid_days()`](#method-CFCalendarTAI-valid_days)

- [`CFCalendarTAI$clone()`](#method-CFCalendarTAI-clone)

Inherited methods

- [`CFtime::CFCalendar$add_day()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-add_day)
- [`CFtime::CFCalendar$is_compatible()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-is_compatible)
- [`CFtime::CFCalendar$is_equivalent()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-is_equivalent)
- [`CFtime::CFCalendar$offsets2time()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-offsets2time)
- [`CFtime::CFCalendar$parse()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-parse)
- [`CFtime::CFCalendar$print()`](https://r-cf.github.io/CFtime/reference/CFCalendar.html#method-print)
- [`CFtime::CFCalendarProleptic$POSIX_compatible()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-POSIX_compatible)
- [`CFtime::CFCalendarProleptic$date2offset()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-date2offset)
- [`CFtime::CFCalendarProleptic$initialize()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-initialize)
- [`CFtime::CFCalendarProleptic$leap_year()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-leap_year)
- [`CFtime::CFCalendarProleptic$month_days()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-month_days)
- [`CFtime::CFCalendarProleptic$offset2date()`](https://r-cf.github.io/CFtime/reference/CFCalendarProleptic.html#method-offset2date)

------------------------------------------------------------------------

### Method `valid_days()`

Indicate which of the supplied dates are valid.

#### Usage

    CFCalendarTAI$valid_days(ymd)

#### Arguments

- `ymd`:

  `data.frame` with dates parsed into their parts in columns `year`,
  `month` and `day`. If present, the `tz` column is checked for illegal
  time zone offsets. Any other columns are disregarded.

#### Returns

Logical vector with the same length as argument `ymd` has rows with
`TRUE` for valid days and `FALSE` for invalid days, or `NA` where the
row in argument `ymd` has `NA` values.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    CFCalendarTAI$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
