require 'open-uri'
require 'sinatra'

configure do
  # [Redis To Go | Heroku Dev Center](https://devcenter.heroku.com/articles/redistogo)
  require 'redis'
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end

get '/:repository/:branch/:subject' do |repository, branch, subject|
  key = "#{repository}:#{branch}:#{subject}"
  badge = REDIS.get(key)

  content_type 'image/svg+xml;charset=utf-8'
  cache_control :no_cache

  if badge
    badge
  else
    open("http://img.shields.io/badge/#{subject}-undefined-red.svg").read
  end
end

post '/:repository/:branch/:subject' do |repository, branch, subject|
  key = "#{repository}:#{branch}:#{subject}"
  badge = open("http://img.shields.io/badge/#{subject}-#{params[:status]}-#{params[:color]}.svg").read
  REDIS.set(key, badge)

  "It was saved #{branch} on #{repository}."
end
