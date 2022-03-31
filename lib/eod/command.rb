require 'lp'
require 'mister_bin'
require 'eod/refinements'

module EOD
  class Command < MisterBin::Command
    using EOD::Refinements

    help "EOD Historical Data API"
    version EOD::VERSION

    usage "eod data SYMBOL [options] [PARAMS...]"
    usage "eod bulk EXCHANGE [options] [PARAMS...]"
    usage "eod live SYMBOL [options] [PARAMS...]"
    usage "eod fundamental SYMBOL [options] [PARAMS...]"
    usage "eod fundamental_bulk SYMBOL [options] [PARAMS...]"
    usage "eod dividends SYMBOL [options] [PARAMS...]"
    usage "eod splits SYMBOL [options] [PARAMS...]"
    usage "eod technical SYMBOL [options] [PARAMS...]"
    usage "eod intraday SYMBOL [options] [PARAMS...]"
    usage "eod opts SYMBOL [options] [PARAMS...]"
    usage "eod events [options] [PARAMS...]"
    usage "eod insider [options] [PARAMS...]"
    usage "eod calendar CALENDAR [options] [PARAMS...]"
    usage "eod macro COUNTRY [options] [PARAMS...]"
    usage "eod bond SYMBOL [options] [PARAMS...]"
    usage "eod (-h|--help|--version)"

    command "data", "Download historical EOD data (/eod)"
    command "bulk", "Download historical EOD bulk data (/eod-bulk-last-day)"
    command "live", "Download live data (/real-time)"
    command "fundamental", "Download fundamental data (/fundamentals)"
    command "fundamental_bulk", "Download bulk fundamental data (/bulk-fundamentals)"
    command "dividends", "Download dividends data (/div)"
    command "splits", "Download splits data (/splits)"
    command "technical", "Download technical data (/technical)"
    command "intraday", "Download intraday data (/intraday)"
    command "opts", "Download options data (/options)"
    command "events", "Download economic events data (/economic-events)"
    command "insider", "Download insider transactions data (/insider-transactions)"
    command "calendar", "Download calendar data (earnings, trends, IPOs and splits) (/calendar)"
    command "macro", "Download macroeconomics data (/macro-indicator)"
    command "bond", "Download bond fundamental data (/bond-fundamentals)"

    option "-f --format FORMAT", "Output format: csv, json, yaml, pretty or url [default: pretty]"
    option "-s --save PATH", "Save output to file"

    param "SYMBOL", "Ticker symbol"
    param "CALENDAR", "Calendar type: earnings, trends, ipos or splits"
    param "COUNTRY", "Country code in the Alpha-3 ISO format"
    param "EXCHANGE", "Exchange code"
    param "PARAMS", <<~EOF
      An optional list of query string parameters, separated by a space, to send with the request. \
      Each parameter should be in the format of key:value.
      example: period:w from:2022-01-01

      See https://eodhistoricaldata.com/financial-apis/ for all supported params.
    EOF
    
    environment "EOD_API_TOKEN", "Your EOD Historical Data API token [required]"
    environment "EOD_CACHE_DIR", "API cache diredctory [default: cache]"
    environment "EOD_CACHE_LIFE", <<~EOF
      API cache life. These formats are supported:
      off - No cache
      20s - 20 seconds
      10m - 10 minutes
      10h - 10 hours
      10d - 10 days
    EOF
    environment "EOD_API_URI", "Override the API URI [default: #{EOD::API.base_uri}]"

    example "eod data AAPL.US"
    example "eod data AAPL.US --format csv period:m from:2022-01-01"
    example "eod live AAPL.US -fyaml"
    example "eod fundamental 'AAPL.US' filter:General"
    example "eod technical AAPL.US function:sma"
    example "eod macro USA indicator:inflation_consumer_prices_annual"

    def data_command
      send_output get("eod/#{symbol}")
    end

    def bulk_command
      send_output get("eod-bulk-last-day/#{exchange}")
    end

    def live_command
      send_output get("real-time/#{symbol}")
    end

    def fundamental_command
      disallow :csv
      send_output get("fundamentals/#{symbol}")
    end

    def fundamental_bulk_command
      disallow :csv
      send_output get("bulk-fundamentals/#{symbol}")
    end

    def dividends_command
      send_output get("div/#{symbol}")
    end

    def splits_command
      send_output get("splits/#{symbol}")
    end

    def technical_command
      send_output get("technical/#{symbol}")
    end

    def intraday_command
      send_output get("intraday/#{symbol}")
    end

    def opts_command
      disallow :csv
      send_output get("options/#{symbol}")
    end

    def events_command
      send_output get("economic-events")
    end

    def insider_command
      send_output get("insider-transactions")
    end

    def calendar_command
      allowed = %w[earnings trends ipos splits]
      
      unless allowed.include? calendar
        raise InputError, "Invalid calendar #{calendar}. Expecting earnings, trends, ipos or splits"
      end

      send_output get("calendar/#{calendar}")
    end

    def macro_command
      send_output get("macro-indicator/#{country}")
    end    

    def bond_command
      disallow :csv
      send_output get("bond-fundamentals/#{symbol}")
    end

    def send_output(data)
      if save
        say "saved #{save}"
        File.write save, data
      elsif pretty
        lp data
      else
        puts data
      end
    end

    def get(endpoint)
      case format
      when :url           then api.url endpoint, params
      when :csv           then api.get_csv endpoint, params
      when :json, :pretty then api.get endpoint, params
      when :yaml          then api.get(endpoint, params).to_yaml
      else
        raise InputError, "Invalid format #{format}. Expecting csv, json, yaml or pretty"
      end
    end

  private

    def disallow(disallowed_format)
      raise InputError, "The format #{format} is not supported for this command" if format == disallowed_format
    end

    def api
      @api ||= begin
        EOD::API.base_uri ENV['EOD_API_URI'] if ENV['EOD_API_URI']
        EOD::API.new api_token, 
          use_cache: (ENV['EOD_CACHE_LIFE'] != 'off'),
          cache_dir: ENV['EOD_CACHE_DIR'],
          cache_life: ENV['EOD_CACHE_LIFE']
      end
    end

    def api_token
      ENV['EOD_API_TOKEN'] or raise MissingAuth, "Please set the 'EOD_API_TOKEN' environment variable"
    end

    def pretty
      format == :pretty
    end

    def params
      args['PARAMS'].translate_params
    end

    def symbol
      args['SYMBOL']
    end

    def calendar
      args['CALENDAR']
    end

    def country
      args['COUNTRY']
    end

    def exchange
      args['EXCHANGE']
    end

    def format
      args['--format'].to_sym
    end

    def save
      args['--save']
    end

  end
end
