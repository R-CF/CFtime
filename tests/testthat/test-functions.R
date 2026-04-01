test_that("Various minor functions", {
  cf1 <- CFTime$new("days since 2001-01-01", "standard", 0:999)
  cf2 <- CFTime$new("days since 2001-01-01", "julian", 0:999)
  cf3 <- CFTime$new("days since 2001-01-01", "360_day", 0:999)
  cf4 <- CFTime$new("days since 2001-01-01", "365_day", 0:999)
  cf5 <- CFTime$new("days since 2001-01-01", "366_day", 0:999)
  cf6 <- CFTime$new("days since 2001-01-01", "proleptic_gregorian", 0:999)

  # Days in a month
  expect_error(month_days("1-2-3"))
  expect_equal(month_days(cf1), c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))
  expect_equal(month_days(cf2), c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))
  expect_equal(month_days(cf3), rep(30, 12))
  expect_equal(month_days(cf4), c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))
  expect_equal(month_days(cf5), c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))
  expect_equal(month_days(cf6), c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))

  expect_error(month_days(cf1, 4))
  expect_warning(month_days(cf1, c("2001-01-01", "abc")), "^Some dates could not be parsed")
  x <- c("2021-11-27", "2021-12-10", "2022-02-14", "2022-02-18", "2024-02-03", "2100-02-02")
  expect_equal(month_days(cf1, x), c(30, 31, 28, 28, 29, 28))
  expect_equal(month_days(cf2, x), c(30, 31, 28, 28, 29, 29))
  expect_equal(month_days(cf3, x), rep(30, 6))
  expect_equal(month_days(cf4, x), c(30, 31, 28, 28, 28, 28))
  expect_equal(month_days(cf5, x), c(30, 31, 29, 29, 29, 29))
  expect_equal(month_days(cf6, x), c(30, 31, 28, 28, 29, 28))

  # doy
  expect_equal(cf1$doy(), rep(1:365, 3)[1:1000])
  expect_equal(cf2$doy(), rep(1:365, 3)[1:1000])
  expect_equal(cf3$doy(), rep(1:360, 3)[1:1000])
  expect_equal(cf4$doy(), rep(1:365, 3)[1:1000])
  expect_equal(cf5$doy(), rep(1:366, 3)[1:1000])
  expect_equal(cf6$doy(), rep(1:365, 3)[1:1000])

  cf <- CFTime$new("days since 2001-01-01", "standard", 0:1999)
  reg <- 1:365
  leap <- 1:366
  expect_equal(cf$doy(), c(reg, reg, reg, leap, reg, reg)[1:2000])

  ymd <- data.frame(year = rep(2024L, 6), month = c(1L, 2L, 13L, 2L, 4L, 4L), day = c(31L, 29L, 3L, 43L, 30L, 31L))
  expect_equal(cf1$doy(ymd), c(31L, 60L, NA_integer_, NA_integer_, 121L, NA_integer_))
})
