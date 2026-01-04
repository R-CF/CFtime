# CFtime

CFtime is an R package that supports working with [CF Metadata
Conventions](https://cfconventions.org) time coordinates, specifically
geared to time-referencing data sets of climate projections such as
those produced under the [World Climate Research
Programme](https://www.wcrp-climate.org) and re-analysis data such as
ERA5 from the European Centre for Medium-range Weather Forecasts
(ECMWF).

The data sets include in their metadata an epoch, or origin, a point in
time from which other points in time are calculated. This epoch takes
the form of `days since 1949-12-01`, with each data collection (Coupled
Model Intercomparison Project (CMIP) generation, model, etc) having its
own epoch. The data itself has a temporal dimension if a coordinate
variable in the netCDF file has an attribute `units` with a string value
describing an epoch. The coordinate variable, say “time”, has data
values such as 43289, which are offsets from the epoch in units of the
epoch string (“days” in this case). To convert this offset to a date,
using a specific calendar, is what this package does. Given that the
calendars supported by the CF Metadata Conventions are not compatible
with `POSIXt`, this conversion is not trivial because the standard R
date-time operations do not give correct results. That it is important
to account for these differences is easily demonstrated:

``` r
library(CFtime)

# POSIXt calculations on a standard calendar
as.Date("1949-12-01") + 43289
#> [1] "2068-06-08"

# CFtime calculation on a "360_day" calendar
as_timestamp(CFtime("days since 1949-12-01", "360_day", 43289))
#> [1] "2070-02-30"
```

That’s a difference of nearly 21 months! (And yes, 30 February is a
valid date on a `360_day` calendar.)

All defined calendars of the CF Metadata Conventions are supported:

- `standard` (or the deprecated `gregorian`): This calendar is valid for
  the Common Era only; it starts at `0001-01-01T00:00:00`, i.e. 1
  January of year 1. Time periods prior to the introduction of the
  Gregorian calendar (`1582-10-15`) use the `julian` calendar that was
  in common use then. The 10-day gap between the Julian and Gregorian
  calendars is observed, so dates in the range 5 to 14 October 1582 are
  invalid.
- `proleptic_gregorian`: This calendar uses the Gregorian calendar for
  periods prior to the introduction of that calendar as well, and it
  extends to periods before the Common Era, e.g. year 0 and negative
  years.
- `tai`: International Atomic Time, a global standard for linear time
  based on multiple atomic clocks: it counts seconds since its start at
  `1958-01-01T00:00:00`. For presentation it uses the Gregorian
  calendar. Timestamps prior to its start are not allowed.
- `utc`: Coordinated Universal Time, the standard for civil timekeeping
  all over the world. It is based on International Atomic Time but it
  uses occasional leap seconds to remain synchronous with Earth’s
  rotation around the Sun; at the end of 2025 it is 37 seconds behind
  `tai`. It uses the Gregorian calendar with a start at
  `1972-01-01T00:00:00`; earlier timestamps are not allowed. Future
  timestamps are also not allowed because the insertion of leap seconds
  is unpredictable. Most computer clocks synchronize against UTC but
  calculations of periods do not consider leap seconds (but `CFtime`
  does).
- `julian`: The `julian` calendar has a leap year every four years,
  including centennial years. Otherwise it is the same as the `standard`
  calendar.
- `365_day` or `noleap`: This is a “model time” calendar in which no
  leap years occur. Year 0 exists, as well as years prior to that.
- `366_day` or `all_leap`: This is a “model time” calendar in which all
  years are leap years. Year 0 exists, as well as years prior to that.
- `360_day`: This is a “model time” calendar in which every year has 360
  days divided over 12 months of 30 days each. Year 0 exists, as well as
  years prior to that.
- `none`: Perpetual “calendar” for experiments that are simulated on a
  given instant during the year. All the elements in this calendar thus
  represent the same instant in time.

Use of custom calendars is currently not supported.

This package facilitates use of a suite of models of climate projections
that use different calendars in a consistent manner. This package is
particularly useful for working with climate projection data having a
daily or higher resolution, but it will work equally well on data with a
lower resolution.

Timestamps are generated using the [ISO8601
standard](https://en.wikipedia.org/wiki/ISO_8601).

Calendar-aware factors can be generated to support processing of data
using [`tapply()`](https://rdrr.io/r/base/tapply.html) and similar
functions. Merging of multiple data sets and subsetting facilitate
analysis while preserving computer resources.

## Working with CFtime

Check out the multiple articles that provide detailed instructions and
examples for use of this package.

## Installation

Get the latest stable version on CRAN:

``` r
install.packages("CFtime")
```

You can install the development version of CFtime from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("R-CF/CFtime")
```

## Coverage

This package has been tested with the following data sets:

- ERA5 (including multiple variables, levels, and mixed ERA5/ERA5T data)
- CMIP5
- CORDEX
- CMIP6
- ROMS

The package also operates on geographical and/or temporal subsets of
data sets so long as the subsetted data complies with the CF Metadata
Conventions. This includes subsetting in the [Climate Data
Store](https://cds.climate.copernicus.eu/#!/home). Subsetted data from
Climate4Impact is not automatically supported because the dimension
names are not compliant with the CF Metadata Conventions, use the
corresponding dimension names instead.
