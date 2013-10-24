# enoding: utf-8

require 'sinatra'

# [Redis To Go | Heroku Dev Center](https://devcenter.heroku.com/articles/redistogo)
configure do
  require 'redis'
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/*' do
  label = params[:splat].first
  status = REDIS.get(label)
  if status
    redirect "http://img.shields.io/#{label}/#{status}.png"
  else
    redirect "http://img.shields.io/#{label}/undefined.png?color=red"
  end
end

post '/:label' do |label|
  label = params[:splat].first
  REDIS.set(label, params[:status])
end
