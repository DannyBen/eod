require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'eod/cli'
include EOD

# Public data, as published in the API docs
def public_api_token
  'OeAFFmMliFG5orCUuwAKQ8l4WWFQ67YX'
end

def public_eod_sumbol
  'MCD.US'
end

ENV['EOD_API_TOKEN'] = public_api_token

RSpec.configure do |config|
  unless ENV['RSPEC_KEEP_CACHE']
    config.before :suite do 
      puts "Running spec_helper > before :suite"
      puts "Flushing cache"
      APICake::Base.new.cache.flush
    end
  end
end
