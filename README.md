# EOD Historical Data API Library and Command Line

[![Gem Version](https://badge.fury.io/rb/eod.svg)](https://badge.fury.io/rb/eod)
[![Build Status](https://github.com/DannyBen/eod/workflows/Test/badge.svg)](https://github.com/DannyBen/eod/actions?query=workflow%3ATest)

---

This gem provides both a Ruby library and a command line interface for the 
[EOD Historical Data][docs] data service.

---


## Install

```
$ gem install eod
```


## Features

* Easy to use interface.
* Use as a library or through the command line.
* Access any EOD Historical Data endpoint and option directly, no need to learn
  anything other than the original API documentation.
* Display output as JSON, YAML or CSV.
* Save output to a file as JSON, YAML or CSV.
* Includes a built in file cache, so you can avoid wasting API calls.
* Lightweight.
* Future proof. In case new endpoints are added to the API, they will
  immediately become available in the Ruby library (but not in the CLI).


## Usage

First, require and initialize with your EOD API token:

```ruby
require 'eod'
api_token = 'OeAFFmMliFG5orCUuwAKQ8l4WWFQ67YX'  # demo token
api = EOD::API.new api_token
```

Now, you can access any of the API endpoints with any optional parameter, like
this:

```ruby
result = api.get "eod", 'AAPL.US', period: 'm'
```

In addition, for convenience, you can use the first part of the endpoint as
a method name, like this:

```ruby
result = api.eod 'AAPL.US', period: 'm', from: '2022-01-01'
```

In other words, these calls are the same:

```ruby
api.get 'endpoint', param: value
api.endpoint, param: value
```

as well as these two:

```ruby
api.get 'endpoint/sub', param: value
api.endpoint 'sub', param: value
```

By default, you will get a ruby hash in return. If you wish to have more 
control over the response, use the `get!` method instead:

```ruby
payload = api.get! 'eod', 'AAPL.US'

# Request Object
p payload.request.class
# => HTTParty::Request

# Response Object
p payload.response.class
# => Net::HTTPOK

p payload.response.body
# => JSON string

p payload.response.code
# => 200

p payload.response.msg
# => OK

# Headers Object
p payload.headers
# => Hash with headers

# Parsed Response Object
p payload.parsed_response
# => Hash with HTTParty parsed response 
#    (this is the content returned with #get)
```

You can get the response as CSV by calling `get_csv`:

```ruby
result = api.get_csv "eod", 'AAPL.US'
# => CSV string
```

or, if you prefer, you can request a CSV from the API directly, by using the
`fmt` argument:

```ruby
result = api.eod 'AAPL.US', fmt: 'csv'
# => CSV string
```

To save the output directly to a file, use the `save` method:

```ruby
api.save 'filename.json', 'eod/AAPL.US', period: 'm'
```

Or, to save CSV, use the `save_csv` method:

```ruby
api.save_csv "filename.csv", "eod/AAPL.US", period: 'm'
```

## Command Line Interface

The command line utility `eod` that is installed when installing the gem acts
in a similar way. The main difference is that you provide any API query string
argument using the `key:value` format. 

First, set your API token in the environment variable `EOD_API_TOKEN`:

```bash
$ export EOD_API_TOKEN=OeAFFmMliFG5orCUuwAKQ8l4WWFQ67YX
````

Now, you can run one of the many API commands, for example:

```shell
# Show monthly AAPL data in a pretty colorful output
$ eod data AAPL.US period:m

# Show monthly AAPL data in CSV format
$ eod data AAPL.US --format csv from:2022-01-01 period:m

# Saves a file
$ eod data AAPL.US --format csv --save aapl.csv from:2022-01-01 period:m

# Show live (delayed) data
# eod live AAPL.US
```

Run [`eod --help`](#full-command-line-usage-patterns) for the full list of usage
patterns.

## Supported endpoints

- The Ruby library supports all current and future endpoints.
- The CLI supports most (if not all) current endpoints. If you know of an
  endpoint that is not supported, please create an [issue][issues].


## Caching

We are using the [Lightly][lightly] gem for automatic HTTP caching.

You can disable or customize it by either passing options on 
initialization, or by accessing the `WebCache` object directly at 
a later stage.

```ruby
# Disable cache completely
api = EOD::API.new api_token,  use_cache: true

# Set different cache directory or lifetime
api = EOD::API.new api_token, cache_dir: 'data', cache_ilfe: '2h'

# or 

intrinio = Intrinio::API.new username: user, password: pass
intrinio.cache.disable
intrinio.cache.enable
intrinio.cache.dir = 'tmp/cache'   # Change cache folder
intrinio.cache.life = '30m'        # Change cache life to 30 minutes
```

To enable caching for the command line, simply set one or both of 
these environment variables:

```shell
$ export EOD_CACHE_DIR=cache   # default: 'cache'
$ export EOD_CACHE_LIFE=2h     # default: 3600 (1 hour)
```

To disable cache for the CLI, set `EOD_CACHE_LIFE=off`.

The cache life argument supports these formats:

- `20s` - 20 seconds
- `10m` - 10 minutes
- `10h` - 10 hours
- `10d` - 10 days

## Full command line usage patterns

<!-- USAGE -->
```
$ eod --help

EOD Historical Data API

  API Documentation:
  https://eodhistoricaldata.com/financial-apis/

Usage:
  eod bond SYMBOL [options] [PARAMS...]
  eod bulk EXCHANGE [options] [PARAMS...]
  eod calendar CALENDAR [options] [PARAMS...]
  eod data SYMBOL [options] [PARAMS...]
  eod dividends SYMBOL [options] [PARAMS...]
  eod events [options] [PARAMS...]
  eod exchange EXCHANGE [options] [PARAMS...]
  eod exchanges [options] [PARAMS...]
  eod fundamental SYMBOL [options] [PARAMS...]
  eod fundamental_bulk SYMBOL [options] [PARAMS...]
  eod insider [options] [PARAMS...]
  eod intraday SYMBOL [options] [PARAMS...]
  eod live SYMBOL [options] [PARAMS...]
  eod macro COUNTRY [options] [PARAMS...]
  eod news [options] [PARAMS...]
  eod opts SYMBOL [options] [PARAMS...]
  eod screener [options] [PARAMS...]
  eod search QUERY [options] [PARAMS...]
  eod splits SYMBOL [options] [PARAMS...]
  eod symbols EXCHANGE [options] [PARAMS...]
  eod technical SYMBOL [options] [PARAMS...]
  eod (-h|--help|--version)

Commands:
  bond
    Bond fundamental data (/bond-fundamentals)

  bulk
    Historical EOD bulk data (/eod-bulk-last-day)

  calendar
    Calendar data (earnings, trends, IPOs and splits) (/calendar)

  data
    Historical EOD data (/eod)

  dividends
    Dividends data (/div)

  events
    Economic events data (/economic-events)

  exchange
    Details about an exchange (/exchanges-details)

  exchanges
    List of exchanges (/exchanges-list)

  fundamental
    Fundamental data (/fundamentals)

  fundamental_bulk
    Bulk fundamental data (/bulk-fundamentals)

  insider
    Insider transactions data (/insider-transactions)

  intraday
    Intraday data (/intraday)

  live
    Live data (/real-time)

  macro
    Macroeconomics data (/macro-indicator)

  news
    Financial news (/news)

  opts
    Options data (/options)

  screener
    Stock market screener (/screener)

  search
    Search for stocks, ETFs, funds or indices (/search)

  splits
    Splits data (/splits)

  symbols
    List of symbols for an exchange (/exchange-symbol-list)

  technical
    Technical data (/technical)

Options:
  -f --format FORMAT
    Output format: csv, json, yaml, pretty or url [default: pretty]

  -s --save PATH
    Save output to file

  -h --help
    Show this help

  --version
    Show version number

Parameters:
  SYMBOL
    Ticker symbol

  CALENDAR
    Calendar type: earnings, trends, ipos or splits

  COUNTRY
    Country code in the Alpha-3 ISO format

  EXCHANGE
    Exchange code

  PARAMS
    An optional list of query string parameters, separated by a space, to send
    with the request. Each parameter should be in the format of key:value.
    example: period:w from:2022-01-01
    
    See https://eodhistoricaldata.com/financial-apis/ for all supported params.

Environment Variables:
  EOD_API_TOKEN
    Your EOD Historical Data API token [required]

  EOD_CACHE_DIR
    API cache diredctory [default: cache]

  EOD_CACHE_LIFE
    API cache life. These formats are supported:
    off - No cache
    20s - 20 seconds
    10m - 10 minutes
    10h - 10 hours
    10d - 10 days

  EOD_API_URI
    Override the API URI [default: https://eodhistoricaldata.com/api]

Examples:
  eod symbols NASDAQ
  eod data AAPL.US
  eod data AAPL.US --format csv period:m from:2022-01-01
  eod live AAPL.US -fyaml
  eod fundamental 'AAPL.US' filter:General
  eod technical AAPL.US function:sma
  eod macro USA indicator:inflation_consumer_prices_annual

```
<!-- USAGE -->


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].



[docs]: https://eodhistoricaldata.com/financial-apis
[issues]: https://github.com/DannyBen/eod/issues
[lightly]: https://github.com/DannyBen/lightly
