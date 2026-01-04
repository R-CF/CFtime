# CFtime: working with CF Metadata Conventions "time" dimensions

Support for all calendars as specified in the Climate and Forecast (CF)
Metadata Conventions for climate and forecasting data. The CF Metadata
Conventions is widely used for distributing files with climate
observations or projections, including the Coupled Model Intercomparison
Project (CMIP) data used by climate change scientists and the
Intergovernmental Panel on Climate Change (IPCC). This package
specifically allows the user to work with any of the CF-compliant
calendars (many of which are not compliant with POSIXt). The CF time
coordinate is formally defined in the [CF Metadata Conventions
document](https://cfconventions.org/Data/cf-conventions/cf-conventions-1.13/cf-conventions.html#time-coordinate).

## Details

This package also supports the creation of a "time" dimension, using
class `CFClimatology`, for climatological statistics as defined
[here](https://cfconventions.org/Data/cf-conventions/cf-conventions-1.13/cf-conventions.html#climatological-statistics).

The package can create a
[CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) or
[CFClimatology](https://r-cf.github.io/CFtime/reference/CFClimatology.md)
instance from scratch or, more commonly, it can use the dimension
attributes and dimension variable values from a netCDF resource. The
package does not actually do any of the reading and the user is free to
use their netCDF package of preference. The recommended package to use
(with any netCDF resources) is
[ncdfCF](https://cran.r-project.org/package=ncdfCF). `ncdfCF` will
automatically use this package to manage the "time" dimension of any
netCDF resource. As with this package, it reads and interprets the
attributes of the resource to apply the CF Metadata Conventions,
supporting axes, auxiliary coordinate variables, coordinate reference
systems, etc. Alternatively, for more basic netCDF reading and writing,
the two main options are
[RNetCDF](https://cran.r-project.org/package=RNetCDF) and
[ncdf4](https://cran.r-project.org/package=ncdf4)).

**Create, modify, inquire**

- [`CFtime()`](https://r-cf.github.io/CFtime/reference/CFtime-function.md):
  Create a [CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md)
  instance

- [`Properties`](https://r-cf.github.io/CFtime/reference/properties.md)
  of the `CFTime` instance

- [`parse_timestamps()`](https://r-cf.github.io/CFtime/reference/parse_timestamps.md):
  Parse a vector of character timestamps into `CFTime` elements

- [`Compare`](https://r-cf.github.io/CFtime/reference/equals-.CFTime.md)
  two `CFTime` instances

- [`Merge`](https://r-cf.github.io/CFtime/reference/plus-.CFTime.md) two
  `CFTime` instances or append additional time steps to a `CFTime`
  instance

- [`as_timestamp()`](https://r-cf.github.io/CFtime/reference/as_timestamp.md)
  and [`format()`](https://rdrr.io/r/base/format.html): Generate a
  vector of character or `POSIXct` timestamps from a `CFTime` instance

- [`range()`](https://rdrr.io/r/base/range.html): Timestamps of the two
  endpoints in the time series

- `copy()`: Create a copy of a CFTime instance

- [`subset()`](https://rdrr.io/r/base/subset.html): Create a new CFTime
  instance which is a subset by index positions of another CFTime
  instance

- [`is_complete()`](https://r-cf.github.io/CFtime/reference/is_complete.md):
  Does the `CFTime` instance have a complete time series between
  endpoints?

- [`month_days()`](https://r-cf.github.io/CFtime/reference/month_days.md):
  How many days are there in a month using the calendar of the `CFTime`
  instance?

**Factors and coverage**

- [`CFfactor()`](https://r-cf.github.io/CFtime/reference/CFfactor.md)
  and [`cut()`](https://r-cf.github.io/CFtime/reference/cut.CFTime.md):
  Create factors for different time periods

- [`CFfactor_units()`](https://r-cf.github.io/CFtime/reference/CFfactor_units.md):
  How many units of time are there in each factor level?

- [`CFfactor_coverage()`](https://r-cf.github.io/CFtime/reference/CFfactor_coverage.md):
  How much data is available for each level of the factor?

**Filtering and selection**

- [`slice()`](https://r-cf.github.io/CFtime/reference/slice.md): Logical
  vector of time steps between two extreme points.

- [`indexOf()`](https://r-cf.github.io/CFtime/reference/indexOf.md):
  Index values in the time series of given timestamps, possibly with
  fractional part for interpolation.

## See also

Useful links:

- <https://r-cf.github.io/CFtime/>

- <https://github.com/R-CF/CFtime>

- Report bugs at <https://github.com/R-CF/CFtime/issues>

## Author

**Maintainer**: Patrick Van Laake <patrick@vanlaake.net> \[copyright
holder\]
