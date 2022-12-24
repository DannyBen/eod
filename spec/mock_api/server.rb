require 'sinatra'
require 'byebug'
require 'yaml'
require 'json'

set :port, 3000
set :bind, '0.0.0.0'

def json(hash)
  content_type :json
  JSON.pretty_generate hash
end

get '/' do
  json mockserver: :online
end

get '/err/:code' do
  halt params[:code].to_i
end

get '/*' do
  # path = params['splat'].first
  if params[:fmt] == 'csv'
    "date,price\n2022-01-01,123\n2022-01-02,123\n"
  else
    json [{ date: '2022-01-01', price: 123 }, { date: '2022-01-02', price: 124 }]
  end
end
