require 'open-uri'
require 'securerandom'
require 'sinatra'

configure do
  # [Redis Cloud | Heroku Dev Center](https://devcenter.heroku.com/articles/rediscloud)
  require 'redis'
  uri = URI.parse(ENV['REDISCLOUD_URL'])
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end

get '/:repository/:branch/:subject' do |repository, branch, subject|
  key = "#{repository}:#{branch}:#{subject}"
  badge = REDIS.get(key)

  content_type 'image/svg+xml;charset=utf-8'
  cache_control :no_cache
  etag SecureRandom.hex

  badge || open("https://img.shields.io/badge/#{subject}-undefined-red.svg?style=flat-square").read
end

post '/:repository/:branch/:subject' do |repository, branch, subject|
  key = "#{repository}:#{branch}:#{subject}"
  badge = open("https://img.shields.io/badge/#{subject}-#{URI.encode(params[:status])}-#{params[:color]}.svg?style=flat-square").read
  REDIS.set(key, badge)

  "It was saved #{branch} on #{repository}."
end
