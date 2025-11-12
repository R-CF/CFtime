#nocov start
# Create environment for global CFtime variables
CFt <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  assign("CFunits", data.frame(unit = c("years", "year", "yr", "months", "month", "mon", "days", "day", "d", "hours", "hour", "hr", "h", "minutes", "minute", "min", "seconds", "second", "sec", "s"),
                               id   = c(6L, 6L, 6L, 5L, 5L, 5L, 4L, 4L, 4L, 3L, 3L, 3L, 3L, 2L, 2L, 2L, 1L, 1L, 1L, 1L)), envir = CFt)
  assign("units", data.frame(name     = c("seconds", "minutes", "hours", "days", "months", "years"),
                             seconds  = c(1L, 60L, 3600L, 86400L, 86400L * 30L, 86400L * 365L),
                             per_day  = c(86400, 1440, 24, 1, 1/30, 1/365)), envir = CFt)
  assign("prefixes", data.frame(name        = c("yocto", "zepto", "atto", "femto", "pico", "nano", "micro", "micro", "micro",
                                                "milli", "centi", "deci", "deca", "deka", "hecto", "kilo", "mega", "giga",
                                                "tera", "peta", "exa", "zetta", "yotta"),
                                abbrev      = c("y", "z", "a", "f", "p", "n", "u", "\u00B5", "\u03BC", "m", "c", "d", "da", "da",
                                                "h", "k", "M", "G", "T", "P", "E", "Z", "Y"),
                                multiplier  = c(1e-24, 1e-21, 1e-18, 1e-15, 1e-12, 1e-9, 1e-6, 1e-6, 1e-6, 1e-3, 1e-2, 1e-1,
                                                1e1, 1e1, 1e2, 1e3, 1e6, 1e9, 1e12, 1e15, 1e18, 1e21, 1e24)), envir = CFt)
  assign("factor_periods", c("year", "season", "quarter", "month", "dekad", "day"), envir = CFt)
  assign("eps", .Machine$double.eps^0.5, envir = CFt)
}
#nocov end
