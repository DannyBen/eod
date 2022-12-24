require 'apicake'

module EOD
  # Provides access to all the EOD API endpoints with dynamic methods
  # anc caching.
  class API < APICake::Base
    base_uri 'https://eodhistoricaldata.com/api'

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

    def get_csv(*args)
      payload = get!(*args)

      if payload.response.code != '200'
        raise BadResponse, "#{payload.response.code} #{payload.response.msg}"
      end

      data = payload.parsed_response
      data = csv_node data if data.is_a? Hash

      header = data.first.keys

      CSV.generate do |csv|
        csv << header
        data.each { |row| csv << row.values }
      end
    end
  end
end
