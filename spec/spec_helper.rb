require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'eod/cli'
include EOD

FAKE_API_TOKEN = 'fake-test-token'
ENV['EOD_CACHE_DIR'] = 'spec/cache'
ENV['EOD_API_TOKEN'] = FAKE_API_TOKEN

def require_mock_server!
  result = HTTParty.get('http://localhost:3000/')
  result = JSON.parse result.body
  raise "Please start the mock server" unless result['mockserver'] == 'online'
rescue Errno::ECONNREFUSED
  # :nocov:
  raise "Please start the mock server"
  # :nocov:
end

RSpec.configure do |c|
  c.filter_run_excluding :require_test_api_token unless ENV['EOD_TEST_API_TOKEN']

  c.before :suite do
    PRODUCTION_API_BASE = API.base_uri
    TEST_API_BASE = "http://localhost:3000/"
    API.base_uri TEST_API_BASE
    
    system 'mkdir -p spec/tmp && rm -rf spec/cache'
  end
end
