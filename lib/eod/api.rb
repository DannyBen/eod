require 'apicake'

module EOD
  # Provides access to all the EOD API endpoints with dynamic methods
  # anc caching.
  class API < APICake::Base
    base_uri 'https://eodhistoricaldata.com/api/'

    attr_reader :api_token

    def initialize(api_token, use_cache: true, cache_dir: nil, cache_life: nil)
      @api_token = api_token
      cache.disable unless use_cache
      cache.dir = cache_dir if cache_dir
      cache.life = cache_life if cache_life
    end

    def default_query
      { api_token: api_token, fmt: :json } 
    end

    # Access the /eod API endpoint is provided implicitely by APICake
    # Access the /fundumentals API endpoint is provided implicitely by APICake

    # Access the /real-time API endpoint is explicitly, due to the fact it
    # contains a hyphen. In addition, symbols can be provided as an array, which
    # is converted to the multi-symbol request format specified by the API
    # (using the first symbol as a path argument, and the others in the `s`
    # auery argument, comma delimited).
    def real_time(symbols, args = {})
      if symbols.is_a? Array
        symbol = symbols.first
        args[:s] = symbols.drop(1).join ','
      else
        symbol = symbols
      end

      get "/real-time", symbol, args
    end

    def get_csv(*args)
      payload = get! *args

      if payload.response.code != "200"
        raise BadResponse, "#{payload.response.code} #{payload.response.msg}"
      end

      data = payload.parsed_response
      data = csv_node data if data.is_a? Hash

      unless data.is_a? Array
        raise BadResponse, "Cannot parse response, expecting Array, got #{data.class}"
      end

      header = data.first.keys

      result = CSV.generate do |csv|
        csv << header
        data.each { |row| csv << row.values }
      end

      result
    end
  end
end