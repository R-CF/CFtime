#' Create a CFTime object
#'
#' This function creates an instance of the [CFTime] class. The arguments to the
#' call are typically read from a CF-compliant data file with climatological
#' observations or climate projections. Specification of arguments can also be
#' made manually in a variety of combinations.
#'
#' A time series can also be constructed like a sequence. In this case argument
#' `offsets` should be `NULL` or missing and arguments `from` and `by` provided,
#' with either of arguments `to` or `length.out` indicating the end of the time
#' series. Arguments should be named to avoid ambiguity.
#'
#' @param definition A character string describing the time coordinate.
#' @param calendar A character string describing the calendar to use with the
#'   time dimension definition string. Default value is "standard".
#' @param offsets Numeric or character vector, optional. When numeric, a vector
#'   of offsets from the origin in the time series. When a character vector,
#'   timestamps in ISO8601 or UDUNITS format.
#' @param from,to Optional. Character timestamps in ISO8601 or UDUNITS format.
#'   When `from` is given, a sequence of timestamps is generated with `from` as
#'   the starting timestamp. Either argument `to` or `length.out` must be
#'   provided as well. Ignored when argument `offsets` is not `NULL`.
#' @param by Optional. A single character string representing a time interval,
#'   composed of a number and a time unit separated by a space, such as in "6
#'   hours". When argument `from` is supplied, argument `by` will be the
#'   separation between successive timestamps. Note that the time unit in the
#'   string does not have to be the same as the unit in the `definition`
#'   argument but it must be an allowable unit of time. Time interval units of
#'   "months" and "years" are strongly discouraged unless the same time unit is
#'   used in the `definition` argument - in all other cases there is a loss of
#'   precision due to the ambiguity in the time units.
#' @param length.out Optional. An numeric value that indicates the lengths of
#'   the time series to generate, rounded up if fractional. Ignored when
#'   argument `to` is provided.
#' @returns An instance of the `CFTime` class.
#' @export
#' @name CFtime-function
#' @examples
#' # Using numeric offset values - this is how a netCDF file works
#' CFtime("days since 1850-01-01", "julian", 0:364)
#'
#' # A time object with a single defined timestamp
#' CFtime("hours since 2023-01-01", "360_day", "2023-01-30T23:00")
#'
#' # A time series from a sequence with an end point
#' CFtime("days since 2023-01-01", from = "2020-01-01", to = "2023-12-31", by = "12 days")
#'
#' # A time series from a sequence with a specified length
#' CFtime("days since 2023-01-01", from = "2020-01-01T03:00:00", by = "6 hr", length.out = 31 * 4)
CFtime <- function(definition, calendar = "standard", offsets, from, to, by, length.out) {
  if (missing(offsets)) {
    if (missing(from))
      # Barebones CFTime without offsets
      CFTime$new(definition, calendar)
    else {
      if (missing(by))
        stop("When argument `from` is provided, argument `by` must be provided too.", call. = FALSE)
      else if (!is.character(from) || length(from) > 1L)
        stop("Argument `from` must be a single character timestamp value.", call. = FALSE)
      else
        t <- CFTime$new(definition, calendar, from)

      # Process argument `by`
      intv <- NA; intv_unit <- integer(0)
      if (is.character(by) && length(by) == 1L) {
        parts <- strsplit(by, " ", fixed = TRUE)[[1L]]
        if (length(parts) == 2L) {
          intv_unit <- CFt$CFunits[CFt$CFunits$unit == parts[2L], ]$id
          suppressWarnings(intv <- as.numeric(parts[1L]))
        }
      }
      if (is.na(intv) || !length(intv_unit))
        stop("Argument `by` is an invalid time interval.", call. = FALSE)

      doff <- intv * CFt$units$seconds[intv_unit] / CFt$units$seconds[t$cal$unit]

      # End point of the time series
      from_off <- t$offsets # There is only a single offset at this point
      if (missing(to)) {
        if (missing(length.out))
          stop("One of arguments `to` or `length.out` must be supplied.", call. = FALSE)

        # Time series with a given length
        t + seq(from = from_off + doff, by = doff, length.out = length.out[1L] - 1L)
      } else {
        # Time series up to a finishing point
        to_off <- t$cal$parse(to[1L])$offset
        if (is.na(to_off))
          stop("Argument `to` must be a single character timestamp value.")
        t + seq(from = from_off + doff, to = to_off, by = doff)
      }
    }
  } else
    CFTime$new(definition, calendar, offsets)
}

# ==============================================================================
# Functions to access CFTime properties and methods

#' @aliases properties
#' @title Properties of a CFTime object
#'
#' @description These functions return the properties of an instance of the
#'   [CFTime] class. The properties are all read-only, but offsets can be added
#'   using the `+` operator.
#'
#' @param t An instance of `CFTime`.
#'
#' @returns `calendar()` and `unit()` return a character string.
#'   `origin()` returns a data frame of timestamp elements with a single row
#'   of data. `timezone()` returns the calendar time zone as a character
#'   string. `offsets()` returns a vector of offsets or `NULL` if no offsets
#'   have been set.
#'
#' @examples
#' t <- CFtime("days since 1850-01-01", "julian", 0:364)
#' definition(t)
#' calendar(t)
#' unit(t)
#' timezone(t)
#' origin(t)
#' offsets(t)
#' resolution(t)

#' @describeIn properties The definition string of the `CFTime` instance.
#' @export
definition <- function(t) t$cal$definition

#' @describeIn properties The calendar of the `CFTime` instance.
#' @export
calendar <- function(t) t$cal$name

#' @describeIn properties The unit of the `CFTime` instance.
#' @export
unit <- function(t) t$unit

#' @describeIn properties The origin of the `CFTime` instance in timestamp elements.
#' @export
origin <- function(t) t$cal$origin

#' @describeIn properties The time zone of the calendar of the `CFTime` instance as a character string.
#' @export
timezone <- function(t) t$cal$timezone

#' @describeIn properties The offsets of the `CFTime` instance as a numeric vector.
#' @export
offsets <- function(t) t$offsets

#' @describeIn properties The average separation between the offsets in the `CFTime` instance.
#' @export
resolution <- function(t) t$resolution

#' Bounds of the time offsets
#'
#' CF-compliant netCDF files store time information as a single offset value for
#' each step along the dimension, typically centered on the valid interval of
#' the data (e.g. 12-noon for day data). Optionally, the lower and upper values
#' of the valid interval are stored in a so-called "bounds" variable, as an
#' array with two rows (lower and higher value) and a column for each offset.
#' With function `bounds()<-` those bounds can be set for a `CFTime` instance.
#' The bounds can be retrieved with the `bounds()` function.
#'
#' @param x A `CFTime` instance.
#' @param format Optional. A single string with format specifiers, see
#'   [CFtime::format()] for details.
#' @return If bounds have been set, an array of bounds values with dimensions
#'   `(2, length(offsets))`. The first row gives the lower bound, the second row
#'   the upper bound, with each column representing an offset of `x`. If the
#'   `format` argument is specified, the bounds values are returned as strings
#'   according to the format. `NULL` when no bounds have been set.
#' @aliases bounds
#' @export
#' @examples
#' t <- CFtime("days since 2024-01-01", "standard", seq(0.5, by = 1, length.out = 366))
#' as_timestamp(t)[1:3]
#' bounds(t) <- rbind(0:365, 1:366)
#' bounds(t)[, 1:3]
#' bounds(t, "%d-%b-%Y")[, 1:3]
bounds <- function(x, format) {
  x$get_bounds(format)
}

#' @rdname bounds
#' @param value A `matrix` (or `array`) with dimensions (2, length(offsets))
#'   giving the lower (first row) and higher (second row) bounds of each offset
#'   (this is the format that the CF Metadata Conventions uses for storage in
#'   netCDF files). Use `NULL` to unset any previously set bounds.
#' @export
`bounds<-` <- function(x, value) {
  x$set_bounds(value)
  x
}

#' The length of the offsets contained in the `CFTime` instance.
#'
#' @param x The `CFTime` instance whose length will be returned
#'
#' @return The number of offsets in the specified `CFTime` instance.
#' @export
#'
#' @examples
#' t <- CFtime("days since 1850-01-01", "julian", 0:364)
#' length(t)
length.CFTime <- function(x) base::length(x$offsets)

#' Return the timestamps contained in the `CFTime` instance
#' @param x The `CFTime` instance whose timestamps will be returned.
#' @param ... Ignored.
#' @return The timestamps in the specified `CFTime` instance.
#' @export
#' @examples
#' t <- CFtime("days since 1850-01-01", "julian", 0:364)
#' as.character(t)
as.character.CFTime <- function(x, ...) {
  x$as_timestamp()
}

#' Format the timestamps in the `CFTime` instance
#'
#'   The formatting is largely oblivious to locale. The reason for this is
#'   that certain dates in certain calendars are not POSIX-compliant and the
#'   system functions necessary for locale information thus do not work
#'   consistently. The main exception to this is the (abbreviated) names of
#'   months (`bB`), which could be useful for pretty printing in the local
#'   language. For separators and other locale-specific adornments, use
#'   local knowledge instead of depending on system locale settings; e.g.
#'   specify `%m/%d/%Y` instead of `%D`.
#'
#'   Week information, including weekday names, is not supported at all as a
#'   "week" is not defined for non-standard CF calendars and not generally
#'   useful for climate projection data. If you are working with observed
#'   data and want to get pretty week formats, use the [as_timestamp()]
#'   method to generate `POSIXct` timestamps (observed data generally uses a
#'   "standard" calendar) and then use the [base::format()] function which
#'   supports the full set of specifiers.
#' @param x The `CFTime` instance whose timestamps will be formatted.
#' @param format A character string. The default for the format methods is
#'   "%Y-%m-%dT%H:%M:%S" if any timestamp has a time component which is not
#'   midnight, and "%Y-%m-%d" otherwise. The only supported specifiers are
#'   `bBdeFhHImMpRSTYz%`. Modifiers `E` and `O` are silently ignored. Other
#'   specifiers, including their percent sign, are copied to the output as if
#'   they were adorning text.
#' @param tz Ignored.
#' @param usetz Logical. Should the time zone offset be appended to the output?
#'   This is always in numerical form, i.e. "-0800", from UTC.
#' @param ... Ignored.
format.CFTime <- function(x, format = "", tz = "", usetz = FALSE, ...) {
  x$format(format, usetz)
}

#' Create a factor for a `CFTime` instance
#'
#' Method for [base::cut()] applied to [CFTime] objects.
#'
#' When `breaks` is one of `"year", "season", "quarter", "month", "dekad",
#' "day"` a factor is generated like by [CFfactor()].
#'
#' When `breaks` is a vector of character timestamps a factor is produced with a
#' level for every interval between timestamps. The last timestamp, therefore,
#' is only used to close the interval started by the pen-ultimate timestamp -
#' use a distant timestamp (e.g. `range(x)[2]`) to ensure that all offsets to
#' the end of the `CFTime` time series are included, if so desired. The last
#' timestamp will become the upper bound in the `CFTime` instance that is
#' returned as an attribute to this function so a sensible value for the last
#' timestamp is advisable.
#'
#' This method works similar to [base::cut.POSIXt()] but there are some
#' differences in the arguments: for `breaks` the set of options is different
#' and no preceding integer is allowed, `labels` are always assigned using
#' values of `breaks`, and the interval is always left-closed.
#'
#' @param x An instance of `CFTime`.
#' @param breaks A character string of a factor period (see [CFfactor()] for a
#'   description), or a character vector of timestamps that conform to the
#'   calendar of `x`, with a length of at least 2. Timestamps must be given in
#'   ISO8601 format, e.g. "2024-04-10 21:31:43".
#' @param ... Ignored.
#' @returns A factor with levels according to the `breaks` argument, with
#'   attributes 'period', 'era' and 'CFTime'. When `breaks` is a factor
#'   period, attribute 'period' has that value, otherwise it is '"day"'. When
#'   `breaks` is a character vector of timestamps, attribute 'CFTime' holds an
#'   instance of `CFTime` that has the same definition as `x`, but with (ordered)
#'   offsets generated from the `breaks`. Attribute 'era' is always -1.
#' @aliases cut
#' @seealso [CFfactor()] produces a factor for several fixed periods, including
#'   for eras.
#' @export
#' @examples
#' x <- CFtime("days since 2021-01-01", "365_day", 0:729)
#' breaks <- c("2022-02-01", "2021-12-01", "2023-01-01")
#' cut(x, breaks)
cut.CFTime <- function (x, breaks, ...) {
  if (!inherits(x, "CFTime"))
    stop("Argument 'x' must be a CFTime instance", call. = FALSE) # nocov
  x$cut(breaks)
}

#' Find the index of timestamps in the time series
#'
#' Find the index in the time series for each timestamp given in argument `x`.
#' Values of `x` that are before the earliest value or after the latest value in
#' `y` will be returned as `NA`. Alternatively, when `x` is a numeric vector of
#' index values, return the valid indices of the same vector, with the side
#' effect being the attribute "CFTime" associated with the result.
#'
#' Timestamps can be provided as vectors of character strings, `POSIXct` or
#' `Date.`
#'
#' Matching also returns index values for timestamps that fall between two
#' elements of the time series - this can lead to surprising results when time
#' series elements are positioned in the middle of an interval (as the CF
#' Metadata Conventions instruct us to "reasonably assume"): a time series of
#' days in January would be encoded in a netCDF file as
#' `c("2024-01-01 12:00:00", "2024-01-02 12:00:00", "2024-01-03 12:00:00", ...)`
#' so `x <- c("2024-01-01", "2024-01-02", "2024-01-03")` would result in
#' `(NA, 1, 2)` (or `(NA, 1.5, 2.5)` with `method = "linear"`) because the date
#' values in `x` are at midnight. This situation is easily avoided by ensuring
#' that `y` has bounds set (use `bounds(y) <- TRUE` as a proximate solution if
#' bounds are not stored in the netCDF file). See the Examples.
#'
#' If bounds are set, the indices are informed by those bounds. If the
#' bounds are not contiguous, returned values may be `NA` even if the
#' value of `x` falls between two valid timestamps.
#'
#' Values of `x` that are not valid timestamps according to the calendar of `y`
#' will be returned as `NA`.
#'
#' `x` can also be a numeric vector of index values, in which case the valid
#' values in `x` are returned. If negative values are passed, the positive
#' counterparts will be excluded and then the remainder returned. Positive and
#' negative values may not be mixed. Using a numeric vector has the side effect
#' that the result has the attribute "CFTime" describing the temporal dimension
#' of the slice. If index values outside of the range of `y` (`1:length(y)`) are
#' provided, an error will be thrown.
#'
#' @param x Vector of `character`, `POSIXt` or `Date` values to find indices
#'   for, or a numeric vector.
#' @param y A [CFTime] instance.
#' @param method Single value of "constant" or "linear". If `"constant"` or when
#'   bounds are set on argument `y`, return the index value for each match. If
#'   `"linear"`, return the index value with any fractional value.
#' @param rightmost.closed Whether or not to include the upper limit of
#'   argument `x`. Default is `FALSE`. This argument is ignored when
#'   argument `x` contains index values.
#' @return A numeric vector giving indices into `y` for the values of
#'   `x`. If there is at least 1 valid index, then attribute "CFTime"
#'   contains an instance of `CFTime` that describes the dimension of
#'   filtering the dataset associated with `y` with the result of this
#'   method, excluding any `NA` values.
#' @export
#'
#' @examples
#' cf <- CFtime("days since 2020-01-01", "360_day", 1440:1799 + 0.5)
#' as_timestamp(cf)[1:3]
#' x <- c("2024-01-01", "2024-01-02", "2024-01-03")
#' indexOf(x, cf)
#' indexOf(x, cf, method = "linear")
#'
#' bounds(cf) <- TRUE
#' indexOf(x, cf)
#'
#' # Non-existent calendar day in a `360_day` calendar
#' x <- c("2024-03-30", "2024-03-31", "2024-04-01")
#' indexOf(x, cf)
#'
#' # Numeric x
#' indexOf(c(29, 30, 31), cf)
indexOf <- function(x, y, method = "constant", rightmost.closed = FALSE) {
  y$indexOf(x, method, rightmost.closed)
}

#' Extreme time series values
#'
#' Character representation of the extreme values in the time series.
#'
#' @param x An instance of the [CFTime] class.
#' @param format A character string with format specifiers, optional. If it is
#'   missing or an empty string, the most economical ISO8601 format is chosen:
#'   "date" when no time information is present in `x`, "timestamp" otherwise.
#'   Otherwise a suitable format specifier can be provided.
#' @param bounds Logical to indicate if the extremes from the bounds should be
#'   used, if set. Defaults to `FALSE`.
#' @param ... Ignored.
#' @param na.rm Ignored.
#' @return Vector of two character representations of the extremes of the time
#'   series.
#' @export
#' @examples
#' cf <- CFtime("days since 1850-01-01", "julian", 0:364)
#' range(cf)
#' range(cf, "%Y-%b-%e")
range.CFTime <- function(x, format = "", bounds = FALSE, ..., na.rm = FALSE) {
  x$range(format, bounds)
}

#' Indicates if the time series is complete
#'
#' This function indicates if the time series is complete, meaning that the time
#' steps are equally spaced and there are thus no gaps in the time series.
#'
#' This function gives exact results for time series where the nominal
#' *unit of separation* between observations in the time series is exact in
#' terms of the calendar unit. As an example, for a calendar unit of "days" where the
#' observations are spaced a fixed number of days apart the result is exact, but
#' if the same calendar unit is used for data that is on a monthly basis, the
#' *assessment* is approximate because the number of days per month is variable
#' and dependent on the calendar (the exception being the `360_day` calendar,
#' where the assessment is exact). The *result* is still correct in most cases
#' (including all CF-compliant data sets that the developers have seen) although
#' there may be esoteric constructions of CFTime and offsets that trip up this
#' implementation.
#'
#' @param x An instance of the [CFTime] class.
#' @returns logical. `TRUE` if the time series is complete, with no gaps;
#'   `FALSE` otherwise. If no offsets have been added to the `CFTime` instance,
#'   `NA` is returned.
#' @export
#' @examples
#' t <- CFtime("days since 1850-01-01", "julian", 0:364)
#' is_complete(t)
is_complete <- function(x) {
  if (!inherits(x, "CFTime")) stop("Argument must be an instance of `CFTime`", call. = FALSE)
  x$equidistant()
}

#' Which time steps fall within extreme values
#'
#' Given a vector of character timestamps, return a logical vector of a length
#' equal to the number of time steps in the time series with values `TRUE` for
#' those time steps that fall between the two extreme values of the vector
#' values, `FALSE` otherwise.
#'
#' If bounds were set these will be preserved.
#'
#' @param x The `CFTime` instance to operate on.
#' @param extremes Character vector of timestamps that represent the time period
#'   of interest. The extreme values are selected. Badly formatted timestamps
#'   are silently dropped.
#' @param rightmost.closed Is the right side closed, i.e. included in the
#'   result? Default is `FALSE`. A specification of `c("2022-01-01",
#'   "2023-01-01)` will thus include all time steps that fall in the year 2022
#'   when `closed = FALSE` but include `2023-01-01` if that exact value is
#'   present in the time series.
#' @returns A logical vector with a length equal to the number of time steps in
#'   `x` with values `TRUE` for those time steps that fall between the extreme
#'   values, `FALSE` otherwise.
#'
#'   An attribute 'CFTime' will have the same definition as `x` but with offsets
#'   corresponding to the time steps falling between the two extremes. If there
#'   are no values between the extremes, the attribute is `NULL`.
#' @export
#' @examples
#' t <- CFtime("hours since 2023-01-01 00:00:00", "standard", 0:23)
#' slice(t, c("2022-12-01", "2023-01-01 03:00"))
slice <- function(x, extremes, rightmost.closed = FALSE) {
  if (!inherits(x, "CFTime")) stop("First argument must be an instance of `CFTime`", call. = FALSE)
  x$slice(extremes, rightmost.closed)
}

#' Equivalence of CFTime objects
#'
#' This operator can be used to test if two [CFTime] objects represent the same
#' CF-convention time coordinates. Two `CFTime` objects are considered equivalent
#' if they have an equivalent calendar and the same offsets.
#'
#' @param e1,e2 Instances of the `CFTime` class.
#' @returns `TRUE` if the `CFTime` objects are equivalent, `FALSE` otherwise.
#' @export
#' @aliases CFtime-equivalent
#' @examples
#' e1 <- CFtime("days since 1850-01-01", "gregorian", 0:364)
#' e2 <- CFtime("days since 1850-01-01 00:00:00", "standard", 0:364)
#' e1 == e2
"==.CFTime" <- function(e1, e2)
  e1$cal$is_equivalent(e2$cal) &&
  length(e1$offsets) == length(e2$offsets) &&
  all(e1$offsets == e2$offsets)

#' Extend a CFTime or CFClimatology object
#'
#' A [CFTime] or [CFClimatology] instance can be extended with this operator,
#' using values from another `CFTime` or `CFClimatology` instance, respectively,
#' or a vector of numeric offsets or character timestamps. If the values come
#' from another `CFTime` or `CFClimatology` instance, the calendars of the two
#' instances must be compatible. If the calendars of the instances are not
#' compatible, an error is thrown.
#'
#' The resulting `CFTime` or `CFClimatology` instance will have the offsets of
#' the original instance, appended with offsets from argument `e2` in the order
#' that they are specified. If the new sequence of offsets is not monotonically
#' increasing a warning is generated (the COARDS metadata convention requires
#' offsets to be monotonically increasing).
#'
#' There is no reordering or removal of duplicates. This is because the time
#' series are usually associated with a data set and the correspondence between
#' the data in the files and the instance is thus preserved. When merging the
#' data sets described by this time series, the order must be identical to the
#' merging here.
#'
#' Note that when adding multiple vectors of offsets to a `CFTime` instance, it
#' is more efficient to first concatenate the vectors and then do a final
#' addition to the `CFTime` instance. So avoid `CFtime(definition, calendar, e1) + CFtime(definition, calendar, e2) + CFtime(definition, calendar, e3) + ...`
#' but rather do `CFtime(definition, calendar) + c(e1, e2, e3, ...)`. It is the
#' responsibility of the operator to ensure that the offsets of the different
#' data sets are in reference to the same calendar.
#'
#' Note also that `RNetCDF` and `ncdf4` packages both return the values of the
#' "time" dimension as a 1-dimensional array. You have to de-class the array to
#' a vector before adding offsets to an existing `CFtime` instance.
#'
#' If both operands to this operator are `CFTime` or `CFClimatology` instances
#' and both have bounds set, then their bounds will be preserved in the result.
#'
#' @param e1 Instance of the `CFTime` class.
#' @param e2 Instance of the `CFTime` class with a calendar compatible with that
#'   of argument `e1`. This argument may also be a numeric vector with offsets
#'   from the origin of argument `e1`, or a vector of `character` timestamps in
#'   ISO8601 or UDUNITS format.
#' @returns A `CFTime` object with the offsets of argument `e1` extended by the
#'   values from argument `e2`.
#' @export
#' @aliases CFtime-merge
#' @examples
#' e1 <- CFTime$new("days since 1850-01-01", "gregorian", 0:364)
#' e2 <- CFTime$new("days since 1850-01-01 00:00:00", "standard", 365:729)
#' e1 + e2
"+.CFTime" <- function(e1, e2) {
  diff <- NULL
  new_time <- if (inherits(e2, "CFTime")) {
    if (!e1$cal$is_compatible(e2$cal)) stop("Calendars not compatible", call. = FALSE) # nocov
    if (all(e1$cal$origin[1:6] == e2$cal$origin[1:6]))
      CFTime$new(e1$cal$definition, e1$cal$name, c(e1$offsets, e2$offsets))
    else {
      diff <- e1$cal$parse(paste(e2$cal$origin_date, e2$cal$origin_time))$offset
      CFTime$new(e1$cal$definition, e1$cal$name, c(e1$offsets, e2$offsets + diff))
    }
  } else if (is.numeric(e2) && .validOffsets(e2)) {
    CFTime$new(e1$cal$definition, e1$cal$name, c(e1$offsets, e2))
  } else {
    time <- e1$cal$parse(e2)
    if (anyNA(time$year)) stop("Argument `e2` contains invalid timestamps", call. = FALSE) # nocov
    CFTime$new(e1$cal$definition, e1$cal$name, c(e1$offsets, time$offset))
  }

  if (!is.null(be1 <- e1$bounds) && !is.null(be2 <- e2$bounds)) {
    if (!is.null(diff))
      be2 <- be2 + diff
    new_time$bounds <- cbind(be1, be2)
  }

  new_time
}

#' @title Extending a CFClimatology object
#' @rdname plus-.CFTime
#' @param c1,c2 Instances of the `CFClimatology` class, having compatible
#'   calendars.
#' @returns A `CFClimatology` object with the offsets of argument `c1` extended
#'   by the values from argument `c2`.
#' @export
"+.CFClimatology" <- function(c1, c2) {
  if (!inherits(c2, "CFClimatology"))
    stop("Can only merge a `CFClimatology` instance to another `CFClimatology`")
  if (!c1$cal$is_compatible(c2$cal)) stop("Calendars not compatible", call. = FALSE) # nocov

  if (all(c1$cal$origin[1:6] == c2$cal$origin[1:6]))
    CFClimatology$new(c1$cal$definition, c1$cal$name, c(c1$offsets, c2$offsets), cbind(c1$bounds, c2$bounds))
  else {
    diff <- c1$cal$parse(paste(c2$cal$origin_date, c2$cal$origin_time))$offset
    CFClimatology$new(c1$cal$definition, c1$cal$name, c(c1$offsets, c2$offsets + diff), cbind(c1$bounds, c2$bounds + diff))
  }
}

# ==============================================================================
# Factors and coverage

#' Create a factor from the offsets in a `CFTime` instance
#'
#' With this function a factor can be generated for the time series, or a part
#' thereof, contained in the [CFTime] instance. This is specifically interesting
#' for creating factors from the date part of the time series that aggregate the
#' time series into longer time periods (such as month) that can then be used to
#' process daily CF data sets using, for instance, `tapply()`.
#'
#' The factor will respect the calendar that the time series is built on. For
#' `period`s longer than a day this will result in a factor where the calendar
#' is no longer relevant (because calendars impacts days, not dekads, months,
#' quarters, seasons or years).
#'
#' The factor will be generated in the order of the offsets of the `CFTime`
#' instance. While typical CF-compliant data sources use ordered time series
#' there is, however, no guarantee that the factor is ordered as multiple
#' `CFTime` objects may have been merged out of order. For most processing with
#' a factor the ordering is of no concern.
#'
#' If the `era` parameter is specified, either as a vector of years to include
#' in the factor, or as a list of such vectors, the factor will only consider
#' those values in the time series that fall within the list of years, inclusive
#' of boundary values. Other values in the factor will be set to `NA`. The years
#' need not be contiguous, within a single vector or among the list items, or in
#' order.
#'
#' The following periods are supported by this function:
#'
#' \itemize{
#'   \item `year`, the year of each offset is returned as "YYYY".
#'   \item `season`, the meteorological season of each offset is returned as
#'   "Sx", with x being 1-4, preceeded by "YYYY" if no `era` is
#'   specified. Note that December dates are labeled as belonging to the
#'   subsequent year, so the date "2020-12-01" yields "2021S1". This implies
#'   that for standard CMIP files having one or more full years of data the
#'   first season will have data for the first two months (January and
#'   February), while the final season will have only a single month of data
#'   (December).
#'   \item `quarter`, the calendar quarter of each offset is returned as "Qx",
#'   with x being 1-4, preceeded by "YYYY" if no `era` is specified.
#'   \item `month`, the month of each offset is returned as "01" to
#'   "12", preceeded by "YYYY-" if no `era` is specified. This is the default
#'   period.
#'   \item `dekad`, ten-day periods are returned as
#'   "Dxx", where xx runs from "01" to "36", preceeded by "YYYY" if no `era`
#'   is specified. Each month is subdivided in dekads as follows: 1- days 01 -
#'   10; 2- days 11 - 20; 3- remainder of the month.
#'   \item `day`, the month and day of each offset are returned as "MM-DD",
#'   preceeded by "YYYY-" if no `era` is specified.
#' }
#'
#' It is not possible to create a factor for a period that is shorter than the
#' temporal resolution of the source data set from which the `t` argument
#' derives. As an example, if the source data set has monthly data, a dekad or
#' day factor cannot be created.
#'
#' Creating factors for other periods is not supported by this function. Factors
#' based on the timestamp information and not dependent on the calendar can
#' trivially be constructed from the output of the [as_timestamp()] function.
#'
#' For non-era factors the attribute 'CFTime' of the result contains a `CFTime`
#' instance that is valid for the result of applying the factor to a data set
#' that the `t` argument is associated with. In other words, if `CFTime`
#' instance 'At' describes the temporal dimension of data set 'A' and a factor
#' 'Af' is generated like `Af <- CFfactor(At)`, then `Bt <- attr(Af, "CFTime")`
#' describes the temporal dimension of the result of, say,
#' `B <- apply(A, 1:2, tapply, Af, FUN)`. The 'CFTime' attribute is `NULL` for
#' era factors.
#'
#' @param t An instance of the `CFTime` class whose offsets will be used to
#'   construct the factor.
#' @param period character. A character string with one of the values "year",
#'   "season", "quarter", "month" (the default), "dekad" or "day".
#' @param era numeric or list, optional. Vector of years for which to
#'   construct the factor, or a list whose elements are each a vector of years.
#'   If `era` is not specified, the factor will use the entire time series for
#'   the factor.
#'
#' @returns If `era` is a single vector or not specified, a factor with a
#'   length equal to the number of offsets in `t`. If `era` is a list, a list
#'   with the same number of elements and names as `era`, each containing a
#'   factor. Elements in the factor will be set to `NA` for time series values
#'   outside of the range of specified years.
#'
#'   The factor, or factors in the list, have attributes 'period', 'era' and
#'   'CFTime'. Attribute 'period' holds the value of the `period` argument.
#'   Attribute 'era' indicates the number of years that are included in the
#'   era, or -1 if no `era` is provided. Attribute 'CFTime' holds an
#'   instance of `CFTime` that has the same definition as `t`, but with offsets
#'   corresponding to the mid-point of non-era factor levels; if the `era`
#'   argument is specified, attribute 'CFTime' is `NULL`.
#' @seealso [cut()] creates a non-era factor for arbitrary cut points.
#' @export
#'
#' @examples
#' t <- CFtime("days since 1949-12-01", "360_day", 19830:54029)
#'
#' # Create a dekad factor for the whole time series
#' f <- CFfactor(t, "dekad")
#'
#' # Create three monthly factors for early, mid and late 21st century eras
#' ep <- CFfactor(t, era = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
CFfactor <- function(t, period = "month", era = NULL) {
  if (!(inherits(t, "CFTime"))) stop("First argument to CFfactor() must be an instance of the `CFTime` class", call. = FALSE) # nocov
  t$factor(period, era)
}

#' Number of base time units in each factor level
#'
#' Given a factor as returned by [CFfactor()] and the [CFTime] instance from
#' which the factor was derived, this function will return a numeric vector with
#' the number of time units in each level of the factor.
#'
#' The result of this function is useful to convert between absolute and
#' relative values. Climate change anomalies, for instance, are usually computed
#' by differencing average values between a future period and a baseline period.
#' Going from average values back to absolute values for an aggregate period
#' (which is typical for temperature and precipitation, among other variables)
#' is easily done with the result of this function, without having to consider
#' the specifics of the calendar of the data set.
#'
#' If the factor `f` is for an era (e.g. spanning multiple years and the
#' levels do not indicate the specific year), then the result will indicate the
#' number of time units of the period in a regular single year. In other words,
#' for an era of 2041-2060 and a monthly factor on a standard calendar with a
#' `days` unit, the result will be `c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)`.
#' Leap days are thus only considered for the `366_day` and `all_leap` calendars.
#'
#' Note that this function gives the number of time units in each level of the
#' factor - the actual number of data points in the `cf` instance per factor
#' level may be different. Use [CFfactor_coverage()] to determine the actual
#' number of data points or the coverage of data points relative to the factor
#' level.
#'
#' @param t An instance of `CFTime`.
#' @param f A factor or a list of factors derived from the
#'   parameter `t`. The factor or list thereof should generally be generated by
#'   the function [CFfactor()].
#'
#' @returns If `f` is a factor, a numeric vector with a length equal to the
#'   number of levels in the factor, indicating the number of time units in each
#'   level of the factor. If `f` is a list of factors, a list with each element
#'   a numeric vector as above.
#' @export
#'
#' @examples
#' t <- CFtime("days since 2001-01-01", "365_day", 0:364)
#' f <- CFfactor(t, "dekad")
#' CFfactor_units(t, f)
CFfactor_units <- function(t, f) {
  if (!inherits(t, "CFTime")) stop("First argument to `CFfactor_units()` must be an instance of the `CFTime` class", call. = FALSE)
  t$factor_units(f)
}

#' Coverage of time elements for each factor level
#'
#' This function calculates the number of time elements, or the relative
#' coverage, in each level of a factor generated by [CFfactor()].
#'
#' @param t An instance of [CFTime].
#' @param f factor or list. A factor or a list of factors derived from the
#'   parameter `t`. The factor or list thereof should generally be generated by
#'   the function [CFfactor()].
#' @param coverage "absolute" or "relative".
#' @returns If `f` is a factor, a numeric vector with a length equal to the
#'   number of levels in the factor, indicating the number of units from the
#'   time series in `t` contained in each level of the factor when
#'   `coverage = "absolute"` or the proportion of units present relative to the
#'   maximum number when `coverage = "relative"`. If `f` is a list of factors, a
#'   list with each element a numeric vector as above.
#' @export
#'
#' @examples
#' t <- CFtime("days since 2001-01-01", "365_day", 0:364)
#' f <- CFfactor(t, "dekad")
#' CFfactor_coverage(t, f, "absolute")
CFfactor_coverage <- function(t, f, coverage = "absolute") {
  if (!inherits(t, "CFTime")) stop("First argument to `CFfactor_coverage()` must be an instance of the `CFTime` class", call. = FALSE) # nocov
  t$factor_coverage(f, coverage)
}

# ==============================================================================
# Regular functions

#' Create a vector that represents CF timestamps
#'
#' This function generates a vector of character strings or `POSIXct`s that
#' represent the date and time in a selectable combination for each offset.
#'
#' The character strings use the format `YYYY-MM-DDThh:mm:ss±hhmm`, depending on
#' the `format` specifier. The date in the string is not necessarily compatible
#' with `POSIXt` - in the `360_day` calendar `2017-02-30` is valid and
#' `2017-03-31` is not.
#'
#' For the "proleptic_gregorian" calendar the output can also be generated as a
#' vector of `POSIXct` values by specifying `asPOSIX = TRUE`. The same is
#' possible for the "standard" and "gregorian" calendars but only if all
#' timestamps fall on or after 1582-10-15.
#'
#' @param t The `CFTime` instance that contains the offsets to use.
#' @param format character. A character string with either of the values "date"
#'   or "timestamp". If the argument is not specified, the format used is
#'   "timestamp" if there is time information, "date" otherwise.
#' @param asPOSIX logical. If `TRUE`, for "standard", "gregorian" and
#'   "proleptic_gregorian" calendars the output is a vector of `POSIXct` - for
#'   other calendars an error will be thrown. Default value is `FALSE`.
#' @seealso The [CFTime] `format()` method gives greater flexibility through
#'   the use of `strptime`-like format specifiers.
#' @returns A character vector where each element represents a moment in time
#'   according to the `format` specifier.
#' @export
#' @examples
#' t <- CFtime("hours since 2020-01-01", "standard", seq(0, 24, by = 0.25))
#' as_timestamp(t, "timestamp")
#'
#' t2 <- CFtime("days since 2002-01-21", "standard", 0:20)
#' tail(as_timestamp(t2, asPOSIX = TRUE))
#'
#' tail(as_timestamp(t2))
#'
#' tail(as_timestamp(t2 + 1.5))
as_timestamp <- function(t, format = NULL, asPOSIX = FALSE) {
  if (!(inherits(t, "CFTime")))
    stop("First argument to `as_timestamp()` must be an instance of the `CFTime` class", call. = FALSE)
  t$as_timestamp(format, asPOSIX)
}

#' Return the number of days in a month given a certain CF calendar
#'
#' Given a vector of dates as strings in ISO 8601 or UDUNITS format and a
#' [CFTime] object, this function will return a vector of the same length as the
#' dates, indicating the number of days in the month according to the calendar
#' specification. If no vector of days is supplied, the function will return an
#' integer vector of length 12 with the number of days for each month of the
#' calendar (disregarding the leap day for `standard` and `julian` calendars).
#'
#' @param t The `CFTime` instance to use.
#' @param x character. An optional vector of dates as strings with format
#'   `YYYY-MM-DD`. Any time part will be silently ingested.
#'
#' @returns A vector indicating the number of days in each month for the vector
#'   of dates supplied as argument `x`. Invalidly specified dates will result in
#'   an `NA` value. If no dates are supplied, the number of days per month for
#'   the calendar as a vector of length 12.
#'
#' @export
#' @seealso When working with factors generated by [CFfactor()], it is usually
#'   better to use [CFfactor_units()] as that will consider leap days for
#'   non-era factors. [CFfactor_units()] can also work with other time periods
#'   and calendar units, such as "hours per month", or "days per season".
#' @examples
#' dates <- c("2021-11-27", "2021-12-10", "2022-01-14", "2022-02-18")
#' t <- CFtime("days since 1850-01-01", "standard")
#' month_days(t, dates)
#'
#' t <- CFtime("days since 1850-01-01", "360_day")
#' month_days(t, dates)
#'
#' t <- CFtime("days since 1850-01-01", "all_leap")
#' month_days(t, dates)
#'
#' month_days(t)
month_days <- function(t, x = NULL) {
  stopifnot(inherits(t, "CFTime"))

  if (is.null(x))
    return(t$cal$month_days())
  else {
    if (!(is.character(x))) stop("Argument `x` must be a character vector of dates in 'YYYY-MM-DD' format")

    ymd <- t$cal$parse(x)
    if (anyNA(ymd$year)) warning("Some dates could not be parsed. Result contains `NA` values.", call. = FALSE)
    return(t$cal$month_days(ymd))
  }
}

#' Parse series of timestamps in CF format to date-time elements
#'
#' This function will parse a vector of timestamps in ISO8601 or UDUNITS format
#' into a data frame with columns for the elements of the timestamp: year,
#' month, day, hour, minute, second, time zone. Those timestamps that could not
#' be parsed or which represent an invalid date in the indicated `CFtime`
#' instance will have `NA` values for the elements of the offending timestamp
#' (which will generate a warning).
#'
#' The supported formats are the *broken timestamp* format from the UDUNITS
#' library and ISO8601 *extended*, both with minor changes, as suggested by the
#' CF Metadata Conventions. In general, the format is `YYYY-MM-DD hh:mm:ss.sss
#' hh:mm`. The year can be from 1 to 4 digits and is interpreted literally, so
#' `79-10-24` is the day Mount Vesuvius erupted and destroyed Pompeii, not
#' `1979-10-24`. The year and month are mandatory, all other fields are
#' optional. There are defaults for all missing values, following the UDUNITS
#' and CF Metadata Conventions. Leading zeros can be omitted in the UDUNITS
#' format, but not in the ISO8601 format. The optional fractional part can have
#' as many digits as the precision calls for and will be applied to the smallest
#' specified time unit. In the result of this function, if the fraction is
#' associated with the minute or the hour, it is converted into a regular
#' `hh:mm:ss.sss` format, i.e. any fraction in the result is always associated
#' with the second, rounded down to milli-second accuracy. The separator between
#' the date and the time can be a single whitespace character or a `T`.
#'
#' The time zone is optional and should have at least the hour or `Z` if
#' present, the minute is optional. The time zone hour can have an optional
#' sign. In the UDUNITS format the separator between the time and the time zone
#' must be a single whitespace character, in ISO8601 there is no separation
#' between the time and the timezone. Time zone names are not supported (as
#' neither UDUNITS nor ISO8601 support them) and will cause parsing to fail when
#' supplied, with one exception: the designator "UTC" is silently dropped (i.e.
#' interpreted as "00:00").
#'
#' Currently only the extended formats (with separators between the elements)
#' are supported. The vector of timestamps may have any combination of ISO8601
#' and UDUNITS formats.
#'
#' @param t An instance of `CFTime` to use when parsing the date.
#' @param x Vector of character strings representing timestamps in
#'   ISO8601 extended or UDUNITS broken format.
#' @returns A `data.frame` with constituent elements of the parsed timestamps in
#'   numeric format. The columns are year, month, day, hour, minute, second
#'   (with an optional fraction), time zone (character string), and the
#'   corresponding offset value from the origin. Invalid input data will appear
#'   as `NA` - if this is the case, a warning message will be displayed - other
#'   missing information on input will use default values.
#' @importFrom stats na.omit
#' @export
#' @examples
#' t <- CFtime("days since 0001-01-01", "proleptic_gregorian")
#'
#' # This will have `NA`s on output and generate a warning
#' timestamps <- c("2012-01-01T12:21:34Z", "12-1-23", "today",
#'                 "2022-08-16T11:07:34.45-10", "2022-08-16 10.5+04")
#' parse_timestamps(t, timestamps)
parse_timestamps <- function(t, x) {
  stopifnot(is.character(x), inherits(t, "CFTime"))
  if (t$cal$unit > 4) stop("Parsing of timestamps on a 'month' or 'year' time unit is not supported.", call. = FALSE)

  out <- t$cal$parse(x)
  if (anyNA(out$year))
    warning("Some dates could not be parsed. Result contains `NA` values.") # nocov
  if (length(unique(na.omit(out$tz))) > 1)
    warning("Timestamps have multiple time zones. Some or all may be different from the calendar time zone.") # nocov
  else if (out$tz[1] != t$cal$timezone)
    warning("Timestamps have time zone that is different from the calendar.") # nocov
  out
}
