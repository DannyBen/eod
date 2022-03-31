require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'eod/cli'
include EOD

ENV['EOD_CACHE_DIR'] = 'spec/cache'
ENV['EOD_API_TOKEN'] = 'fake-test-token'

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
  c.before :suite do
    require_mock_server!
    system 'mkdir -p spec/tmp'
    API.base_uri "http://localhost:3000/"
  end
end
