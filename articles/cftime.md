# Working with CFtime

## Climate change models and calendars

Around the world, many climate change models are being developed (100+)
under the umbrella of the [World Climate Research
Programme](https://www.wcrp-climate.org) to assess the rate of climate
change. Published data is generally publicly available to download for
research and other (non-commercial) purposes through partner
organizations in the Earth Systems Grid Federation.

The data are all formatted to comply with the [CF Metadata
Conventions](http://cfconventions.org), a set of standards to support
standardization among research groups and published data sets. These
conventions greatly facilitate use and analysis of the climate
projections because standard processing work flows (should) work across
the various data sets.

On the flip side, the CF Metadata Conventions needs to cater to a wide
range of modeling requirements and that means that some of the areas
covered by the standards are more complex than might be assumed. One of
those areas is the temporal dimension of the data sets. The CF Metadata
Conventions supports no less than 12 different calendar definitions,
that, upon analysis, fall into 9 distinct calendars (from the
perspective of computation of climate projections):

- `standard` (or `gregorian`, deprecated): The Gregorian calendar that
  is in common use in many countries around the world, adopted by edict
  of Pope Gregory XIII in 1582 and in effect from 15 October of that
  year. The earliest valid time in this calendar is
  `0001-01-01T00:00:00` (1 January of year 1) as year 0 does not exist
  and the CF Metadata Conventions require the year to be positive, but
  noting that a Julian calendar is used in periods before the Gregorian
  calendar was introduced.
- `proleptic_gregorian`: This is the Gregorian calendar with validity
  extended to periods prior to `1582-10-15`, including a year 0 and
  negative years. This calendar is the closest to what is being used in
  most OSes and what is being used by R. The difference is in leap
  seconds: while this calendar does not account for them (and neither
  does POSIXt), most computers are periodically synchronized against a
  time server running on UTC, which does include leap seconds.
- `tai`: International Atomic Time, a global standard for linear time:
  it counts seconds since its start at `1958-01-01T00:00:00`. For
  presentation it uses the Gregorian calendar. Timestamps prior to its
  start are not allowed.
- `utc`: Coordinated Universal Time, the standard for civil timekeeping
  all over the world. It is based on International Atomic Time but it
  uses occasional leap seconds to remain synchronous with Earth’s
  rotation around the Sun; at the end of 2025 it is 37 seconds behind
  `tai`. It uses the Gregorian calendar with a start at
  `1972-01-01T00:00:00`; earlier timestamps are not allowed. Future
  timestamps are also not allowed because the insertion of leap seconds
  is unpredictable. Most computer clocks synchronize with UTC but
  calculate time intervals without accounting for leap seconds (but
  `CFtime` does).
- `julian`: Adopted in the year 45 BCE, every fourth year is a leap
  year. Originally, the Julian calendar did not have a monotonically
  increasing year assigned to it and there are indeed several Julian
  calendars in use around the world today with different years assigned
  to them. Common interpretation is currently that the year is the same
  as that of the Gregorian calendar. The Julian calendar is currently 13
  days behind the Gregorian calendar. As with the standard calendar, the
  earliest valid time in this calendar is `0001-01-01T00:00:00`.
- `365_day` or `noleap`: “Model time” in which no years have a leap day.
  Negative years are allowed and year 0 exists.
- `366_day` or `all_leap`: “Model time” in which all years have a leap
  day. Negative years are allowed and year 0 exists.
- `360_day`: “Model time” in which every year has 12 months of 30 days
  each. Negative years are allowed and year 0 exists.
- `none`: Perpetual “calendar” for experiments that are simulated on a
  given instant during the year. All the elements in this calendar thus
  represent the same instant in time.

The three calendars of model time are specific to the CF Metadata
Conventions to reduce computational complexities of working with dates.
None of the nine calendars are compliant with the standard `POSIXt`
date/time facilities in `R` and using standard date/time functions would
quickly lead to problems. See the section on “CFtime and POSIXt”, below,
for a detailed description of the discrepancies between the CF calendars
and POSIXt.

In the below code snippet, the date of `1949-12-01` is the *origin* from
which other dates are calculated. When adding 43,289 days to this origin
for a data set that uses the `360_day` calendar, that should yield a
date some 120 years after the origin:

``` r
# POSIXt calculations on a standard calendar - INCORRECT
as.Date("1949-12-01") + 43289
#> [1] "2068-06-08"

# CFtime calculation on a "360_day" calendar - CORRECT
# See below examples for details on the two functions
as_timestamp(CFtime("days since 1949-12-01", "360_day", 43289))
#> [1] "2070-02-30"
```

Using standard `POSIXt` calculations gives a result that is about 21
months off from the correct date - obviously an undesirable situation.
This example is far from artificial: `1949-12-01` is the origin for all
CORDEX data, covering the period 1950-2005 for historical experiments
and the period 2006-2100 for RCP experiments (with some deviation
between data sets), and several models used in the CORDEX set use the
`360_day` calendar. The `365_day` or `noleap` calendar deviates by about
1 day every 4 years (disregarding centurial years), or about 24 days in
a century. The `366_day` or `all_leap` calendar deviates by about 3 days
every 4 years, or about 76 days in a century.

The `CFtime` package deals with the complexity of the different
calendars allowed by the CF Metadata Conventions. It properly formats
dates and times (even oddball dates like `2070-02-30`) and it can
generate calendar-aware factors for further processing of the data.

##### Time zones

The character of CF time series - a number of numerical offsets from a
base date - implies that there should only be a single time zone
associated with the time series, and then only for the `standard` and
`proleptic_gregorian` calendars. For the other calendars a time zone can
be set but it will have no effect. Daylight savings time information is
never considered by `CFtime` so the user should take care to avoid
entering times with DST; DST should be accounted for by indicating the
applicable DST time zone.

The time zone offset from UTC is stored in the `CFTime` instance and can
be retrieved with the
[`timezone()`](https://r-cf.github.io/CFtime/reference/properties.md)
function. If a vector of character timestamps with time zone information
is parsed with the
[`parse_timestamps()`](https://r-cf.github.io/CFtime/reference/parse_timestamps.md)
function and the time zones are found to be different from the `CFTime`
time zone, a warning message is generated but the timestamp is
interpreted as being in the `CFTime` time zone. No correction of
timestamp to `CFTime` time zone is performed.

The concept of time zones does not apply to the `utc` and `tai`
calendars as they represent universal time, i.e. the indicated time is
valid all over the globe. Timestamps passed to these calendars should
not have a time zone indicated, but if there are, anything other than a
0 offset will generate an error.

## Using CFtime to deal with calendars

Data sets that are compliant with the CF Metadata Conventions always
include a *origin*, a specific point in time in reference to a specified
*calendar*, from which other points in time are calculated by adding a
specified *offset* of a certain *unit*. This approach is encapsulated in
the `CFtime` package by the R6 class `CFTime`.

``` r
# Create a CFTime object from a definition string, a calendar and some offsets
(t <- CFtime("days since 1949-12-01", "360_day", 19830:90029))
#> CF calendar:
#>   Origin  : 1949-12-01T00:00:00
#>   Units   : days
#>   Type    : 360_day
#> 
#> Time series:
#>   Elements: [2005-01-01 .. 2199-12-30] (average of 1.000000 days between 70200 elements)
#>   Bounds  : not set
```

The
[`CFtime()`](https://r-cf.github.io/CFtime/reference/CFtime-function.md)
function takes a description (which is actually a unit - “days” - in
reference to an origin - `1949-12-01`), a calendar description, and a
vector of *offsets* from that origin. Once a `CFTime` instance is
created its origin and calendar cannot be changed anymore. Offsets may
be added.

In practice, these parameters will be taken from the data set of
interest. CF Metadata Conventions require data sets to be in the netCDF
format, with all metadata describing the data set included in a single
file, including the mandatory “Conventions” global attribute which
should have a string identifying the version of the CF Metadata
Conventions that this file adheres to (among possible others). Not
surprisingly, all the pieces of interest are contained in the “time”
coordinate variables of the file. The process then becomes as follows,
for a CMIP6 file of daily precipitation.

> In this vignette we are using the [`ncdfCF`
> package](https://cran.r-project.org/package=ncdfCF) as that provides
> the easiest interface to work with netCDF files. Package `CFtime` is
> integrated into `ncdfCF` which makes working with time dimensions in
> netCDF seamless.  
> Packages `RNetCDF` and `ncdf4` can work with `CFtime` as well but then
> the “intelligence” built into `ncdfCF` is not available, such as
> automatically identifying axes and data orientation. Other packages
> like `terra` and `stars` are not recommended because they do not
> provide access to the specifics of the time dimension of the data and
> do not consider any calendars other than “proleptic_gregorian”.

``` r
# install.packages("ncdfCF")
library(ncdfCF)

# Opening a data file that is included with the package.
# Usually you would `list.files()` on a directory of your choice.
fn <- list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)[1]
(ds <- ncdfCF::open_ncdf(fn))
#> <Dataset> pr_day_GFDL-ESM4_ssp245_r1i1p1f1_gr1_20150101-20991231_v20180701 
#> Resource   : /home/runner/work/_temp/Library/CFtime/extdata/pr_day_GFDL-ESM4_ssp245_r1i1p1f1_gr1_20150101-20991231_v20180701.nc 
#> Format     : netcdf4 
#> Collection : CMIP6 
#> Conventions: CF-1.7 CMIP-6.0 UGRID-1.0 
#> Has groups : FALSE 
#> 
#> Variable:
#>  name long_name     units      data_type axes          
#>  pr   Precipitation kg m-2 s-1 NC_FLOAT  lon, lat, time
#> 
#> External variable: areacella
#> 
#> Attributes:
#>  name                  type      length
#>  external_variables    NC_CHAR     9   
#>  history               NC_CHAR   124   
#>  table_id              NC_CHAR     3   
#>  activity_id           NC_CHAR    11   
#>  branch_method         NC_CHAR     8   
#>  branch_time_in_child  NC_DOUBLE   1   
#>  branch_time_in_parent NC_DOUBLE   1   
#>  comment               NC_CHAR    10   
#>  contact               NC_CHAR    32   
#>  Conventions           NC_CHAR    25   
#>  creation_date         NC_CHAR    20   
#>  data_specs_version    NC_CHAR     8   
#>  experiment            NC_CHAR    30   
#>  experiment_id         NC_CHAR     6   
#>  forcing_index         NC_INT      1   
#>  frequency             NC_CHAR     3   
#>  further_info_url      NC_CHAR    77   
#>  grid                  NC_CHAR    94   
#>  grid_label            NC_CHAR     3   
#>  initialization_index  NC_INT      1   
#>  institution           NC_CHAR   112   
#>  institution_id        NC_CHAR     9   
#>  license               NC_CHAR   805   
#>  mip_era               NC_CHAR     5   
#>  nominal_resolution    NC_CHAR     6   
#>  parent_activity_id    NC_CHAR     4   
#>  parent_experiment_id  NC_CHAR    10   
#>  parent_mip_era        NC_CHAR     5   
#>  parent_source_id      NC_CHAR     9   
#>  parent_time_units     NC_CHAR    19   
#>  parent_variant_label  NC_CHAR     8   
#>  physics_index         NC_INT      1   
#>  product               NC_CHAR    12   
#>  realization_index     NC_INT      1   
#>  realm                 NC_CHAR     5   
#>  source                NC_CHAR   560   
#>  source_id             NC_CHAR     9   
#>  source_type           NC_CHAR    18   
#>  sub_experiment        NC_CHAR     4   
#>  sub_experiment_id     NC_CHAR     4   
#>  title                 NC_CHAR    82   
#>  tracking_id           NC_CHAR    49   
#>  variable_id           NC_CHAR     2   
#>  variant_info          NC_CHAR     3   
#>  references            NC_CHAR    30   
#>  variant_label         NC_CHAR     8   
#>  value                                              
#>  areacella                                          
#>  File was processed by fremetar (GFDL analog of ... 
#>  day                                                
#>  ScenarioMIP                                        
#>  standard                                           
#>  60225                                              
#>  60225                                              
#>  <null ref>                                         
#>  gfdl.climate.model.info@noaa.gov                   
#>  CF-1.7 CMIP-6.0 UGRID-1.0                          
#>  2019-06-18T05:29:00Z                               
#>  01.00.27                                           
#>  update of RCP4.5 based on SSP2                     
#>  ssp245                                             
#>  1                                                  
#>  day                                                
#>  https://furtherinfo.es-doc.org/CMIP6.NOAA-GFDL.... 
#>  atmos data regridded from Cubed-sphere (c96) to... 
#>  gr1                                                
#>  1                                                  
#>  National Oceanic and Atmospheric Administration... 
#>  NOAA-GFDL                                          
#>  CMIP6 model data produced by NOAA-GFDL is licen... 
#>  CMIP6                                              
#>  100 km                                             
#>  CMIP                                               
#>  historical                                         
#>  CMIP6                                              
#>  GFDL-ESM4                                          
#>  days since 1850-1-1                                
#>  r1i1p1f1                                           
#>  1                                                  
#>  model-output                                       
#>  1                                                  
#>  atmos                                              
#>  GFDL-ESM4 (2018):\natmos: GFDL-AM4.1 (Cubed-sphe...
#>  GFDL-ESM4                                          
#>  AOGCM AER CHEM BGC                                 
#>  none                                               
#>  none                                               
#>  NOAA GFDL GFDL-ESM4 model output prepared for C... 
#>  hdl:21.14100/48767401-8960-4864-8738-e64640bef71d  
#>  pr                                                 
#>  N/A                                                
#>  see further_info_url attribute                     
#>  r1i1p1f1

# "Conventions" global attribute must have a string like "CF-1.*" for this package to work reliably

# Look at the "time" axis
(time <- ds[["time"]])
#> <Time axis> [6] time
#> Length     : 31025
#> Axis       : T 
#> Calendar   : noleap 
#> Range      : 2015-01-01T12:00:00 ... 2099-12-31T12:00:00 (days) 
#> Bounds     : 2015-01-01 ... 2100-01-01 
#> 
#> Attributes:
#>  name          type      length value                
#>  long_name     NC_CHAR    4     time                 
#>  axis          NC_CHAR    1     T                    
#>  calendar_type NC_CHAR    6     noleap               
#>  bounds        NC_CHAR    9     time_bnds            
#>  standard_name NC_CHAR    4     time                 
#>  description   NC_CHAR   13     Temporal mean        
#>  units         NC_CHAR   21     days since 1850-01-01
#>  calendar      NC_CHAR    6     noleap               
#>  actual_range  NC_DOUBLE  2     60225.5, 91249.5

# Get the CFTime instance from the "time" axis
(t <- time$time)
#> CF calendar:
#>   Origin  : 1850-01-01T00:00:00
#>   Units   : days
#>   Type    : noleap
#> 
#> Time series:
#>   Elements: [2015-01-01T12:00:00 .. 2099-12-31T12:00:00] (average of 1.000000 days between 31025 elements)
#>   Bounds  : set
```

You can see from the global attribute “Conventions” that the file
adheres to the CF Metadata Conventions, among others. According to the
CF conventions, `units` and `calendar` are required attributes of the
“time” dimension in the netCDF file.

The above example (and others in this vignette) use the `ncdfCF`
package. If you are using the `RNetCDF` or `ncdf4` package, checking for
CF conventions and then creating a `CFTime` instance goes like this:

``` r
library(RNetCDF)
nc <- open.nc(fn)
att.get.nc(nc, -1, "Conventions")
t <- CFtime(att.get.nc(nc, "time", "units"), 
            att.get.nc(nc, "time", "calendar"), 
            var.get.nc(nc, "time"))

library(ncdf4)
nc <- nc_open(fn)
nc_att_get(nc, 0, "Conventions")
t <- CFtime(nc$dim$time$units, 
            nc$dim$time$calendar, 
            nc$dim$time$vals)
```

The character representations of the time series can be easily
generated:

``` r
dates <- t$as_timestamp(format = "date")
dates[1:10]
#>  [1] "2015-01-01" "2015-01-02" "2015-01-03" "2015-01-04" "2015-01-05"
#>  [6] "2015-01-06" "2015-01-07" "2015-01-08" "2015-01-09" "2015-01-10"
```

…as well as the range of the time series:

``` r
t$range()
#> [1] "2015-01-01T12:00:00" "2099-12-31T12:00:00"
```

Note that in this latter case, if any of the timestamps in the time
series have a time that is other than `00:00:00` then the time of the
extremes of the time series is also displayed. This is a common
occurrence because the CF Metadata Conventions prescribe that the middle
of the time period (month, day, etc) is recorded, which for months with
31 days would be something like `2005-01-15T12:00:00`.

## Supporting processing of climate projection data

When working with high resolution climate projection data, typically at
a “day” resolution, one of the processing steps would be to aggregate
the data to some lower resolution such as a dekad (10-day period), a
month or a meteorological season, and then compute a derivative value
such as the dekadal sum of precipitation, monthly minimum/maximum daily
temperature, or seasonal average daily short-wave irradiance.

It is also possible to create factors for multiple “eras” in one go.
This greatly reduces programming effort if you want to calculate
anomalies over multiple future periods. A complete example is provided
in the vignette [“Processing climate projection
data”](https://r-cf.github.io/CFtime/articles/Processing.md).

It is easy to generate the factors that you need once you have a
`CFTime` instance prepared:

``` r
# Create a dekad factor for the whole `t` time series that was created above
f_k <- t$factor("dekad")
str(f_k)
#>  Factor w/ 3060 levels "2015D01","2015D02",..: 1 1 1 1 1 1 1 1 1 1 ...
#>  - attr(*, "era")= int -1
#>  - attr(*, "period")= chr "dekad"
#>  - attr(*, "CFTime")=CFTime with origin [days since 1850-01-01] using calendar [noleap] having 3060 offset values

# Create monthly factors for a baseline era and early, mid and late 21st century eras
baseline <- t$factor(era = 1991:2020)
future <- t$factor(era = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
str(future)
#> List of 3
#>  $ early: Factor w/ 12 levels "01","02","03",..: NA NA NA NA NA NA NA NA NA NA ...
#>   ..- attr(*, "era")= int 20
#>   ..- attr(*, "period")= chr "month"
#>   ..- attr(*, "CFTime")=CFClimatology with origin [days since 1850-01-01] using calendar [noleap] having 12 offset values $ mid  : Factor w/ 12 levels "01","02","03",..: NA NA NA NA NA NA NA NA NA NA ...
#>   ..- attr(*, "era")= int 20
#>   ..- attr(*, "period")= chr "month"
#>   ..- attr(*, "CFTime")=CFClimatology with origin [days since 1850-01-01] using calendar [noleap] having 12 offset values $ late : Factor w/ 12 levels "01","02","03",..: NA NA NA NA NA NA NA NA NA NA ...
#>   ..- attr(*, "era")= int 20
#>   ..- attr(*, "period")= chr "month"
#>   ..- attr(*, "CFTime")=CFClimatology with origin [days since 1850-01-01] using calendar [noleap] having 12 offset values
```

For the “era” version, there are two interesting things to note here:

- The eras do not have to coincide with the boundaries of the time
  series. In the example above, the time series starts in 2015, while
  the baseline era is from 1991. Obviously, the number of time steps
  from the time series that then fall within this era will then be
  reduced.
- The factor is always of the same length as the time series, with `NA`
  values where the time series values are not falling in the era. This
  ensures that the factor is compatible with the data set which the time
  series describes, such that functions like
  [`tapply()`](https://rdrr.io/r/base/tapply.html) will not throw an
  error.

There are six periods defined for factoring:

- `year`, to summarize data to yearly timescales
- `season`, the meteorological seasons. Note that the month of December
  will be added to the months of January and February of the following
  year, so the date `2020-12-01` yields the factor value “2021S1”.
- `quarter`, the standard quarters of the year.
- `month`, monthly summaries, the default period.
- `dekad`, 10-day period. Each month is subdivided in dekads as
  follows: (1) days 01 - 10; (2) days 11 - 20; (3) remainder of the
  month.
- `day`, to summarize sub-daily data.

##### New “time” dimension

A `CFTime` instance describes the “time” dimension of an associated data
set. When you process that dimension of the data set using
`CFTime$factor()` or another method to filter or otherwise subset the
“time” dimension, the resulting data set will have a different “time”
dimension. To associate a proper `CFTime` instance with your processing
result, the methods in this package return that `CFTime` instance as an
attribute:

``` r
  (new_time <- attr(f_k, "CFTime"))
#> CF calendar:
#>   Origin  : 1850-01-01T00:00:00
#>   Units   : days
#>   Type    : noleap
#> 
#> Time series:
#>   Elements: [2015-01-06T00:00:00 .. 2099-12-26T12:00:00] (average of 10.138771 days between 3060 elements)
#>   Bounds  : set
```

In the vignette [“Processing climate projection
data”](https://r-cf.github.io/CFtime/articles/Processing.md) is a fully
worked out example of this.

##### Incomplete time series

You can test if your time series is complete with the function
[`is_complete()`](https://r-cf.github.io/CFtime/reference/is_complete.md).
A time series is considered complete if the time steps between the two
extreme values are equally spaced. There is a “fuzzy” assessment of
completeness for time series with a datum unit of “days” or smaller
where the time steps are months or years apart - these have different
lengths in days in different months or years (e.g. a leap year).

If your time series is incomplete, for instance because it has missing
time steps, you should recognize that in your further processing. As an
example, you might want to filter out months that have fewer than 90% of
daily data from further processing or apply weights based on the actual
coverage.

``` r
# Is the time series complete?
is_complete(t)
#> [1] TRUE

# How many time units fit in a factor level?
t$factor_units(baseline)
#>  [1] 31 28 31 30 31 30 31 31 30 31 30 31

# What's the absolute and relative coverage of our time series
t$factor_coverage(baseline, "absolute")
#>  [1] 186 168 186 180 186 180 186 186 180 186 180 186
t$factor_coverage(baseline, "relative")
#>  [1] 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2
```

The time series is complete but coverage of the baseline era is only
20%! Recall that the time series starts in 2015 while the baseline
period in the factor is for `1991:2020` so that’s only 6 years of time
series data out of 30 years of the baseline factor.

An artificial example of missing data:

``` r
# 4 years of data on a `365_day` calendar, keep 80% of values
n <- 365 * 4
cov <- 0.8
offsets <- sample(0:(n-1), n * cov)

(t <- CFtime("days since 2020-01-01", "365_day", offsets))
#> Warning: Offsets not monotonically increasing.
#> CF calendar:
#>   Origin  : 2020-01-01T00:00:00
#>   Units   : days
#>   Type    : 365_day
#> 
#> Time series:
#>   Elements: [2020-01-04 .. 2023-12-31] (average of 1.247644 days between 1168 elements)
#>   Bounds  : not set
# Note that there are about 1.25 days between observations

mon <- t$factor("month")
t$factor_coverage(mon, "absolute")
#>  [1] 26 24 26 26 23 24 24 22 23 22 24 26 24 21 21 25 25 26 21 26 26 26 22 23 23
#> [26] 23 25 22 24 25 23 28 25 25 24 22 21 22 26 29 23 26 26 27 23 26 27 27
t$factor_coverage(mon, "relative")
#>  [1] 0.8387097 0.8571429 0.8387097 0.8666667 0.7419355 0.8000000 0.7741935
#>  [8] 0.7096774 0.7666667 0.7096774 0.8000000 0.8387097 0.7741935 0.7500000
#> [15] 0.6774194 0.8333333 0.8064516 0.8666667 0.6774194 0.8387097 0.8666667
#> [22] 0.8387097 0.7333333 0.7419355 0.7419355 0.8214286 0.8064516 0.7333333
#> [29] 0.7741935 0.8333333 0.7419355 0.9032258 0.8333333 0.8064516 0.8000000
#> [36] 0.7096774 0.6774194 0.7857143 0.8387097 0.9666667 0.7419355 0.8666667
#> [43] 0.8387097 0.8709677 0.7666667 0.8387097 0.9000000 0.8709677
```

Keep in mind, though, that there are data sets where the time unit is
lower than the intended resolution of the data. Since the CF conventions
recommend that the coarsest time unit is “day”, many files with monthly
data sets have a definition like `days since 2016-01-01` with offset
values for the middle of the month like `15, 44, 74, 104, ...`. Even in
these scenarios you can verify that your data set is complete with the
function `CFcomplete()`.

## CFtime and POSIXt

The CF Metadata Conventions supports 11 different calendars
(disregarding `none` here). None of these are fully compatible with
POSIXt, the basis for timekeeping on virtually all computers. The reason
for this is that POSIXt does not consider leap seconds (just like the
`tai` calendar) but computer clocks are periodically synchronized using
Network Time Protocol servers that report UTC time. The problem is
easily demonstrated:

``` r
# 1972-01-01 is the origin of UTC, when leap seconds came into existence
difftime(as.POSIXct("2024-01-01"), as.POSIXct("1972-01-01"), units = "sec")
#> Time difference of 1640995200 secs

# CFtime with a "utc" calendar
t <- CFTime$new("seconds since 1972-01-01", "utc", "2024-01-01")
t$offsets
#> [1] 1640995227

# Leap seconds in UTC
.leap.seconds
#>  [1] "1972-07-01 GMT" "1973-01-01 GMT" "1974-01-01 GMT" "1975-01-01 GMT"
#>  [5] "1976-01-01 GMT" "1977-01-01 GMT" "1978-01-01 GMT" "1979-01-01 GMT"
#>  [9] "1980-01-01 GMT" "1981-07-01 GMT" "1982-07-01 GMT" "1983-07-01 GMT"
#> [13] "1985-07-01 GMT" "1988-01-01 GMT" "1990-01-01 GMT" "1991-01-01 GMT"
#> [17] "1992-07-01 GMT" "1993-07-01 GMT" "1994-07-01 GMT" "1996-01-01 GMT"
#> [21] "1997-07-01 GMT" "1999-01-01 GMT" "2006-01-01 GMT" "2009-01-01 GMT"
#> [25] "2012-07-01 GMT" "2015-07-01 GMT" "2017-01-01 GMT"
```

[`difftime()`](https://rdrr.io/r/base/difftime.html) is off by 27
seconds, the number of leap seconds in UTC since their introduction in
1972. Your computer may have the correct time based on UTC, but
calculations over periods that include leap seconds are always off by a
number of seconds.

##### Duh!

If 27 seconds is of no concern to you or your application - perhaps your
data has a daily resolution - then you can safely forget about the leap
seconds in several of the calendars, in particular `standard` (for
periods after `1582-10-15`), `proleptic_gregorian` and `tai`. The `utc`
calendar does account for leap seconds so consider if you should use
that - this is the only calendar that considers leap seconds in
calculation. These calendars support the generation of timestamps in
POSIXct with the
[`as_timestamp()`](https://r-cf.github.io/CFtime/reference/as_timestamp.md)
function but note the potential for a discrepancy due to the presence of
leap seconds.

##### When seconds count

If second accuracy is of concern, then you should carefully consider the
time keeping in the source of your data and use a matching calendar. The
`utc` calendar is a sensible option if your equipment synchronizes time
with an NTP server or a computer that does so. Even then you should
ensure that time is accurate before your first new observation after a
new leap second is introduced.

##### Bigger problems

The other calendars have discrepancies with POSIXt that are much larger,
namely one or more days. These calendars do not support POSIXct
timestamps and an error will be thrown if you try. If you really want
the timestamps in POSIXct then you can generate the timestamps as
character strings using this package, and then convert to a `POSIXct` or
`Date` using the available R tools. Converting time series using these
incompatible calendars to `POSIXct` or `Date` is likely to produce
problems. This is most pronounced for the `360_day` calendar:

``` r
# Days in January and February
t <- CFtime("days since 2023-01-01", "360_day", 0:59)
ts_days <- t$as_timestamp("date")
as.Date(ts_days)
#>  [1] "2023-01-01" "2023-01-02" "2023-01-03" "2023-01-04" "2023-01-05"
#>  [6] "2023-01-06" "2023-01-07" "2023-01-08" "2023-01-09" "2023-01-10"
#> [11] "2023-01-11" "2023-01-12" "2023-01-13" "2023-01-14" "2023-01-15"
#> [16] "2023-01-16" "2023-01-17" "2023-01-18" "2023-01-19" "2023-01-20"
#> [21] "2023-01-21" "2023-01-22" "2023-01-23" "2023-01-24" "2023-01-25"
#> [26] "2023-01-26" "2023-01-27" "2023-01-28" "2023-01-29" "2023-01-30"
#> [31] "2023-02-01" "2023-02-02" "2023-02-03" "2023-02-04" "2023-02-05"
#> [36] "2023-02-06" "2023-02-07" "2023-02-08" "2023-02-09" "2023-02-10"
#> [41] "2023-02-11" "2023-02-12" "2023-02-13" "2023-02-14" "2023-02-15"
#> [46] "2023-02-16" "2023-02-17" "2023-02-18" "2023-02-19" "2023-02-20"
#> [51] "2023-02-21" "2023-02-22" "2023-02-23" "2023-02-24" "2023-02-25"
#> [56] "2023-02-26" "2023-02-27" "2023-02-28" NA           NA
```

31 January is missing from the vector of `Date`s because the `360_day`
calendar does not include it and 29 and 30 February are `NA`s because
POSIXt rejects them. This will produce problems later on when processing
your data.

The general advice is therefore: **do not convert CFTime objects to Date
objects** unless you are sure that the `CFTime` object uses a
POSIXt-compatible calendar.

The degree of incompatibility for the various calendars is as follows:

- `standard`: Only valid for periods after 1582-10-15. The preceeding
  period uses the Julian calendar.
- `julian`: Every fouth year is a leap year. Dates like `2100-02-29` and
  `2200-02-29` are valid.
- `365_day` or `noleap`: No leap year exists. `2020-02-29` does not
  occur.
- `366_day` or `all_leap`: All years are leap years.
- `360_day`: All months have 30 days in every year. This means that 31
  January, March, May, July, August, October and December never occur,
  while 29 and 30 February occur in every year.

##### So how do I compare climate projection data with different calendars?

One reason to convert the time dimension from different climate
projection data sets is to be able to compare the data from different
models and produce a multi-model ensemble. The correct procedure to do
this is to first calculate **for each data set individually** the
property of interest (e.g. average daily rainfall per month anomaly for
some future period relative to a baseline period), which will typically
involve aggregation to a lower resolution (such as from daily data to
monthly averages), and only then combine the aggregate data from
multiple data sets to compute statistically interesting properties (such
as average among models and standard deviation, etc).

Once data is aggregated from daily or higher-resolution values to a
lower temporal resolution - such as a “month” - the different calendars
no longer matter (although if you do need to convert averaged data
(e.g. average daily precipitation in a month) to absolute data
(e.g. precipitation per month) you should use
[`CFfactor_units()`](https://r-cf.github.io/CFtime/reference/CFfactor_units.md)
to make sure that you use the correct scaling factor).

Otherwise, there really shouldn’t be any reason to convert the time
series in the data files to `Date`s. Climate projection data is
virtually never compared on a day-to-day basis between different models
and neither does complex date arithmetic make much sense (such as adding
intervals) - `CFtime` can support basic arithmetic by manipulation the
offsets of the `CFTime` object. The character representations that are
produced are perfectly fine to use for
[`dimnames()`](https://rdrr.io/r/base/dimnames.html) on an array or as
[`rownames()`](https://rdrr.io/r/base/colnames.html) in a `data.frame`
and these also support basic logical operations such as
`"2023-02-30" < "2023-03-01"`. So ask yourself, do you really need
`Date`s when working with unprocessed climate projection data? (If so,
[open an issue on GitHub](https://github.com/R-CF/CFtime/issues)).

A complete example of creating a multi-model ensemble is provided in the
vignette [“Processing climate projection
data”](https://r-cf.github.io/CFtime/articles/Processing.md).

## Final observations

- This package is intended to facilitate processing of climate
  projection data. It is a near-complete implementation of the CF
  Metadata Conventions “time” component.
- In parsing and deparsing of offsets and timestamps, data is rounded to
  3 digits of precision of the unit of the calendar. When using a
  description of time that is very different from the calendar unit,
  this may lead to some loss of precision due to rounding errors. For
  instance, if milli-second precision is required, use a unit of
  “seconds”. The authors have no knowledge of published climate
  projection data that requires milli-second precision so for the
  intended use of the package this issue is marginal.
