# Properties of a CFTime object

These functions return the properties of an instance of the
[CFTime](https://r-cf.github.io/CFtime/reference/CFtime.md) class. The
properties are all read-only, but offsets can be added using the `+`
operator.

## Usage

``` r
definition(t)

calendar(t)

unit(t)

origin(t)

timezone(t)

offsets(t)

resolution(t)
```

## Arguments

- t:

  An instance of `CFTime`.

## Value

`calendar()` and `unit()` return a character string. `origin()` returns
a data frame of timestamp elements with a single row of data.
`timezone()` returns the calendar time zone as a character string.
`offsets()` returns a vector of offsets or `NULL` if no offsets have
been set.

## Functions

- `definition()`: The definition string of the `CFTime` instance.

- `calendar()`: The calendar of the `CFTime` instance.

- `unit()`: The unit of the `CFTime` instance.

- `origin()`: The origin of the `CFTime` instance in timestamp elements.

- `timezone()`: The time zone of the calendar of the `CFTime` instance
  as a character string.

- `offsets()`: The offsets of the `CFTime` instance as a numeric vector.

- `resolution()`: The average separation between the offsets in the
  `CFTime` instance.

## Examples

``` r
t <- CFtime("days since 1850-01-01", "julian", 0:364)
definition(t)
#> [1] "days since 1850-01-01"
calendar(t)
#> [1] "julian"
unit(t)
#> [1] "days"
timezone(t)
#> [1] "+0000"
origin(t)
#>   year month day hour minute second    tz offset
#> 1 1850     1   1    0      0      0 +0000      0
offsets(t)
#>   [1]   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
#>  [19]  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35
#>  [37]  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53
#>  [55]  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71
#>  [73]  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89
#>  [91]  90  91  92  93  94  95  96  97  98  99 100 101 102 103 104 105 106 107
#> [109] 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125
#> [127] 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143
#> [145] 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161
#> [163] 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179
#> [181] 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197
#> [199] 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215
#> [217] 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233
#> [235] 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251
#> [253] 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269
#> [271] 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287
#> [289] 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305
#> [307] 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323
#> [325] 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341
#> [343] 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359
#> [361] 360 361 362 363 364
resolution(t)
#> [1] 1
```
